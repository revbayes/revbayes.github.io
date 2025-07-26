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

RED="\033[31;1m" #bold red
GREEN="\033[32;1m" #bold green
BLUE="\033[34;1m" # bold blue
BOLD="\033[1m"
CLEAR="\033[0m"
UNDERLINE="\033[4m"

BLUE2=$'\033[34;1m'
CLEAR2=$'\033[0m'


for t in */tests.txt; do
    testname=`echo $t | cut -d '/' -f 1`;

    cd $testname
    tests+=($testname)

    printf "\n${BOLD}#### Running tests for tutorial ${CLEAR}${UNDERLINE}$testname${CLEAR}\n"

    test_result=0
    for script in $(cat tests.txt); do
        printf "   ${script}: "

        if [ ! -e "scripts/${script}" ] ; then
            echo "script '${script}' from ${t} is missing!"
            exit 1
        fi

        mkdir -p output
        (
            cd scripts
            cat "$script" |
            sed 's/generations=[0-9]*/generations=1/g' |
            sed 's/^n_gen *= *[0-9]*/n_gen = 1/' |
            sed 's/\.burnin([0-9][0-9]*/.burnin(1/' |
            sed 's/\.run([0-9][0-9]*/.run(1/' |
            sed 's/checkpointInterval=[0-9]*/checkpointInterval=1/g'  > "cp_$script"
        )
        ${rb_exec} -b scripts/cp_$script &> "output/${script%.[Rr]ev}.errout"
        script_result="$?"

        if [ "${script_result}" = 139 ]; then
            script_result="SEGFAULT"
        elif [ "${script_result}" != 0 ]; then
            script_result="error ${script_result}"
        fi

        if [ "${script_result}" != 0 ] ; then
            script_result="${script}=${script_result}"
            tail -n 5 "output/${script%.[Rr]ev}.errout" | sed "s/^/       ${BLUE2}|${CLEAR2}  /g"
            printf "\n   ${RED}FAIL${CLEAR}: ${script_result}\n"
            echo
            if [ "${test_result}" = 0 ] ; then
                test_result="\t${script_result}\n"
            else
                test_result="${test_result}\t${script_result}\n"
            fi
        else
            printf "${GREEN}done${CLEAR}.\n"
        fi
        rm scripts/cp_$script
        rm -rf output
    done

    status+=("${test_result}")

    cd $OLDPWD

done

printf "\n\n#### Checking output from tests... \n"
xfailed=0
failed=0
pass=0
i=0
while [  $i -lt ${#tests[@]} ]; do
    t=${tests[$i]}

    # failure if we have an error message
    if [ "${status[$i]}" != 0 ]; then
        if [ -f XFAIL ] ; then
            ((xfailed++))
            printf ">>>> Test ${RED}failed${CLEAR}: $t (expected)\n"
        else
            ((failed++))
            printf ">>>> Test ${RED}failed${CLEAR}: $t\n"
        fi
        printf "${status[$i]}"
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
