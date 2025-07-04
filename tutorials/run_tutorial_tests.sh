#!/bin/bash

if [ -z "$1" ] ; then
    printf "Please supply the full path to rb as first argument.\n\n"
    printf "Examples:\n"
    printf '  ./run_integration_tests.sh "$(readlink -f ../projects/cmake/rb)"\n'
    printf '  ./run_integration_tests.sh "$PWD/../projects/cmake/rb"\n'
    printf '  ./run_integration_tests.sh  -mpi true "$PWD/../projects/cmake/rb"\n'
#    printf '  ./run_integration_tests.sh mpirun -np 4 "$(readlink -f ../projects/cmake/rb)"\n'
    exit 101
fi


mpi="false"

# parse command line arguments
while echo $1 | grep ^- > /dev/null; do
    # intercept help while parsing "-key value" pairs
    if [ "$1" = "--help" ] || [ "$1" = "-h" ]
    then
        echo '
Command line options are:
-h                              : print this help and exit.
'
        exit
    fi

    # parse pairs
    eval $( echo $1 | sed 's/-//g' | tr -d '\012')=$2
    shift
    shift
done

if [ $mpi = "true" ]; then
#    rb_exec="mpirun --oversubscribe -np 4 $@"
#    rb_exec="mpirun -np 4 $@"
    rb_exec="$@"
else
    rb_exec="$@"
fi

export rb_exec


if ! ${rb_exec} --help > /dev/null 2>&1 ; then
    echo "RevBayes command '${rb_exec}' seems not to work!\n"
    exit 102
fi

tests=()
status=()

for t in */tests.txt; do
    testname=`echo $t | cut -d '/' -f 1`;

    cd $testname
    tests+=($testname)

    printf "\n\n#### Running test: $testname\n\n"
    
    for script in $(cat tests.txt); 
    do
        (
        cd scripts
        cat "$script" |
            sed 's/generations=[0-9]*/generations=1/g' |
            sed 's/^n_gen *= *[0-9]*/n_gen = 1/' |
            sed 's/\.burnin([0-9][0-9]*/.burnin(1/' |
            sed 's/\.run([0-9][0-9]*/.run(1/' |
            sed 's/checkpointInterval=[0-9]*/checkpointInterval=1/g'  > "cp_$script"
        )
        ${rb_exec} -b scripts/cp_$script
        res="$?"
        if [ $res = 1 ]; then
            res="error: $f"
            break
        elif [ $res = 139 ]; then
            res="segfault: $f"
            break
        elif [ $res != 0 ]; then
            res="error $res: $f"
            break
        fi
        if [ $res != 0 ] ; then
            echo "${testname} ==> error $res"
        fi
        rm scripts/cp_$script
        rm -rf output
    done

    status+=("$res")

    cd -
done

printf "\n\n#### Checking output from tests... \n"
xfailed=0
failed=0
pass=0
i=0
while [  $i -lt ${#tests[@]} ]; do
    t=${tests[$i]}

    if [ -d test_$t ]; then
        cd test_$t

        # check if output matches expected output
        errs=()
        exp_out_dir="output_expected"
        # Sebastian: For now we only use single cores until we fix Travis mpirun
    #    if [ "${mpi}" = "true" ]; then
    #        if [ -d "output_expected_mpi" ]; then
    #            exp_out_dir="output_expected_mpi"
    #        fi
    #    fi
        if [ "$windows" = "true" ]; then
            find output -type f -exec dos2unix {} \;
            find output -type f -exec sed -i 's/e-00/e-0/g' {} \;
            find output -type f -exec sed -i 's/e+00/e+0/g' {} \;
        fi
        
        # some special handling for the *.errout files
        for f in scripts/*.[Rr]ev ; do
            tmp0=${f#scripts/}
            tmp1=${tmp0%.[Rr]ev}
            
            # Delete all before the 1st occurrence of the string '   Processing file' (inclusive)
            # Use a temporary intermediate file to make this work w/ both GNU and BSD sed
            sed '1,/   Processing file/d' output/${tmp1}.errout > output/${tmp1}.errout.tmp
            mv output/${tmp1}.errout.tmp output/${tmp1}.errout
            
            # Also delete the final line of failing tests, which reprints the path to the script
            # that differs between Windows and Unix (has no effect if the line is absent)
            sed '/   Error:\tProblem processing/d' output/${tmp1}.errout > output/${tmp1}.errout.tmp
            mv output/${tmp1}.errout.tmp output/${tmp1}.errout
            
            # Account for OS-specific differences in path separators
            if [ "$windows" = "true" ]; then
                sed 's/\\/\//g' output/${tmp1}.errout > output/${tmp1}.errout.tmp
                mv output/${tmp1}.errout.tmp output/${tmp1}.errout
            fi
        done
        
        for f in $(ls ${exp_out_dir}); do
            if [ ! -e output/$f ]; then
                errs+=("missing:  $f")
            elif ! diff output/$f ${exp_out_dir}/$f > /dev/null; then
                errs+=("mismatch: $f")
            fi
        done

        cd ..
    fi
    
    # check if a script exited with an error
    if [ "${status[$i]}" != 0 ]; then
        errs=("${status[$i]}")
    fi

    # failure if we have an error message
    if [ ${#errs[@]} -gt 0 ]; then
        if [ -f XFAIL ] ; then
            ((xfailed++))
            printf ">>>> Test failed: $t (expected)\n"
        else
            ((failed++))
            printf ">>>> Test failed: $t\n"
        fi
        for errmsg in "${errs[@]}"; do
            printf "\t$errmsg\n"
        done
    else
        ((pass++))
        printf "#### Test passed: $t\n"
    fi

    ((i++))
done


if [ $failed -gt 0 ]; then
    printf "\n\n#### Warning! unexpected failures: $failed   expected failures: $xfailed   total tests: $i\n\n"
    exit 113
else
    printf "\n\n#### Success! unexpected failures: $failed   expected failures: $xfailed   total tests: $i\n\n"
    printf "\n\n#### All tests passed.\n\n"
fi
