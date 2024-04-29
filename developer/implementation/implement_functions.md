---
title: Implementing a function
category: implementation
order: 0
---

There are two main classes of functions in RevBayes: regular functions and member functions.  For our example, we will be implement a regular function. First we need to add two files to the RevBayes source code, `Func_hyperbolicCosineFunction.cpp` and `Func_hyperbolicCosineFunction.h`. These will go within `revbayes/src/revlanguage/functions/math` since we are adding a function and it is a mathematical function. Second, we need to register the function by modifying `revbayes/src/revlanguage/workspace/RbRegister_Func.cpp`.

RevLanguage Header file
-----------------
{:.subsection}

The file `Func_hyperbolicCosine.h` should look like the following:

```cpp

#ifndef Func_hyperbolicCosine_h
#define Func_hyperbolicCosine_h

#include "Real.h"
#include "RlTypedFunction.h"

#include <string>

namespace RevLanguage {
    
    /**
     * The RevLanguage wrapper of the hyperbolic Cosine function (sinh()).
     *
     * The RevLanguage wrapper of the hyperbolic function function connects
     * the variables/parameters of the function and creates the internal HyperbolicCosineFunction object.
     * Please read the HyperbolicCosineFunction.h for more info.
     *
     *
     * @copyright Copyright 2024-
     * @author The RevBayes Development Core Team (<your-name>)
     * @since 2024-04-26, version 1.0
     *
     */
    class Func_hyperbolicCosine :  public TypedFunction<Real> {
        
    public:
        // Basic utility functions
        Func_hyperbolicCosine*                         clone(void) const;                                          //!< Clone the object
        static const std::string&                       getClassType(void);                                         //!< Get Rev type
        static const TypeSpec&                          getClassTypeSpec(void);                                     //!< Get class type spec
        std::string                                     getFunctionName(void) const;                                //!< Get the primary name of the function in Rev
        const TypeSpec&                                 getTypeSpec(void) const;                                    //!< Get the type spec of the instance
        
        // Function functions you have to override
        RevBayesCore::TypedFunction<double>*            createFunction(void) const;                                 //!< Create internal function object
        const ArgumentRules&                            getArgumentRules(void) const;                               //!< Get argument rules
        
    };
    
}


#endif /* Func_hyperbolicCosine_h */

```

RevLanguage Implementation file
-----------------
{:.subsection}

And the `Func_hyperbolicCosine.cpp` should look like this:

```cpp
#include "Func_hyperbolicCosine.h"
#include "HyperbolicCosineFunction.h"
#include "Probability.h"
#include "Real.h"
#include "RlDeterministicNode.h"
#include "TypedDagNode.h"

using namespace RevLanguage;

double* hyperbolicCosine(double x)
{
    double result = (exp(x) + exp(-x))/2;
    return new result;
}


/**
 * The clone function is a convenience function to create proper copies of inherited objected.
 * E.g. a.clone() will create a clone of the correct type even if 'a' is of derived type 'b'.
 *
 * \return A new copy of the function.
 */
Func_hyperbolicCosine* Func_hyperbolicCosine::clone( void ) const
{
    return new Func_hyperbolicCosine( *this );
}


RevBayesCore::TypedFunction<double>* Func_hyperbolicCosine::createFunction( void ) const
{
    RevBayesCore::TypedDagNode<double>* x = static_cast<const Real&>( this->args[0].getVariable()->getRevObject() ).getDagNode();
    
    return RevBayesCore::generic_function_ptr< double >( hyberbolicCosine, x );
}


/* Get argument rules */
const ArgumentRules& Func_hyperbolicCosine::getArgumentRules( void ) const
{
    static ArgumentRules argumentRules = ArgumentRules();
    static bool          rules_set = false;
    
    if ( !rules_set )
    {
        
        argumentRules.push_back( new ArgumentRule( "x", Real::getClassTypeSpec(), "The value.", ArgumentRule::BY_CONSTANT_REFERENCE, ArgumentRule::ANY ) );
        
        rules_set = true;
    }

    return argumentRules;
}


const std::string& Func_hyperbolicCosine::getClassType(void)
{
    static std::string rev_type = "Func_hyperbolicCosine";
    
    return rev_type;
}

/* Get class type spec describing type of object */
const TypeSpec& Func_hyperbolicCosine::getClassTypeSpec(void)
{
    static TypeSpec rev_type_spec = TypeSpec( getClassType(), new TypeSpec( Function::getClassTypeSpec() ) );
    
    return rev_type_spec;
}


/**
 * Get the primary Rev name for this function.
 */
std::string Func_hyperbolicCosine::getFunctionName( void ) const
{
    // create a name variable that is the same for all instance of this class
    std::string f_name = "cosh";
    
    return f_name;
}

const TypeSpec& Func_hyperbolicCosine::getTypeSpec( void ) const
{
    static TypeSpec type_spec = getClassTypeSpec();
    
    return type_spec;
}
```

Registering the new function
-----------------
{:.subsection}

In order to make the new function available for use within the Rev language, we first need to register it.
To do this,
1. Go to the `src/revlanguage/workspace/` directory.
2. Open the file `RbRegister_Func.cpp` file in your editor.
3. Scroll down until you find the `#include` commands for math functions.       
4. **Add the line `#include Func_hyperbolicCosine.h` in the correct alphabetical order for that group.**
5. Scroll down in that file until you find the section of the code that adds math functions.
6. **Add the line `addFunction( new Func_hyperbolicCosine() );`**

Functions with caching and optimized recalculation
==================================================
{:.section}

When recalculating a function, sometimes we wish to avoid starting over from scratch.
Instead, we wish to save and re-use some part of the previous calculation that has not changed.
For example, if our function computes `x*(y+z)`, then if only `x` has changed, we could save the old value of `y+z` and re-use it instead of computing `y+z` from scratch. (In this case, `y+x` is not expensive enough to be worth saving; it is just an example).

To accomplish this, we will write our own `RevBayesCore::Function`.  It will have an `update()` method to intelligently recalculate the value.  (If this were a real example, it would also include additional data members to save sub-calculations, and we would use these in the `update()` method if they have not changed.)

A `RevBayesCore::Function` is different from a `RevLanguage::Function`.  The `RevBayesCore::Function` is an object that performs the calculation and stores the result, whereas the `RevLanguage::Function` is used to parse the Rev language command, interpret the function arguments, and create the `RevBayesCore::Function`.

RevBayesCore Header file
-----------
{:.subsection}

First, we will write our new header file. Within our header file, we need to `#include` a few other RevBayes header files, including `TypedDagNode.h` since our typed function deals with nodes of DAGs. Note that the directory structure of `core` is similar to that of the `revlanguage`.  The file `src/core/functions/math/HyperbolicCosineFunction.h` will be:

```cpp
#ifndef HyperbolicCosineFunction_h 
#define HyperbolicCosineFunction_h

#include "TypedFunction.h"
#include "TypedDagNode.h"
#include <cmath>

namespace RevBayesCore {
    /**
     * \brief Hyperbolic Cosine of a real number.
     *
     * Compute the hyperbolic cosine of a real number x. (cosh(x) = (exp(x) + exp(-x))/2).
     *
     * \copyright (c) Copyright 2009-2018 (GPL version 3)
     * \author <your-name>
     * \since Version 1.0, 2015-01-31
     *
     */
    class HyperbolicCosineFunction : public TypedFunction<double> {

        public:
                                          HyperbolicCosineFunction(const TypedDagNode<double> *a); 

            HyperbolicCosineFunction*     clone(void) const; //!< creates a clone
            void                          update(void);      //!< recomputes the value

        protected:
            void                          swapParameterInternal(const DagNode *oldP, const DagNode *newP); //!< Implementation of swapping parameters

        private:
            const TypedDagNode<double>* x;

    };
}


#endif
```
The first part of this file should be the standard header that goes in all the files giving a brief description about what that file is as well as information about the copyright and the author of that file.


RevBayesCore Implementation file
-----------
{:.subsection}

Next, after including the necessary header files, we have to ensure that our new function is included within the `RevBayesCore` namespace.
Here we are implementing our hyperbolic cosine function as its own class that is derived from the typed function class. This class stores the hyperbolic cosine of a value that is held in a DAG node. We have also defined a clone method which can create a clone of our class, and an update method which will update the value of our Hyperbolic Cosine class whenever the value of the DAG node changes.

The file `src/core/functions/math/HyperbolicCosineFunction.cpp` will look like:

```cpp
#include "HyperbolicCosineFunction.h"

using namespace RevBayesCore;

HyperbolicCosineFunction::HyperbolicCosineFunction(const TypedDagNode<double> *a) : TypedFunction<double>( new double(0.0) ),
x( a )
{
    addParameter( a );
}


HyperbolicCosineFunction* HyperbolicCosineFunction::clone( void ) const
{
    return new HyperbolicCosineFunction(*this);
}


void HyperbolicCosineFunction::swapParameterInternal(const DagNode *oldP, const DagNode *newP)
{
    if (oldP == x)
    {
        x = static_cast<const TypedDagNode<double>* >( newP );
    }
    
}

void HyperbolicCosineFunction::update( void )
{
    // get the current value of x
    double xValue = x -> getValue();

    // compute the function result
    double result = exp(xValue) + exp(-xValue);

    // update the stored value
    *value = result;        

}
```

Alternate implemention for `createFunction`
-------------------------------------------

In order to use the new `RevBayesCore::HyperbolicCosineFunction` class, we need to modify the `RevLanguage::Func_hyperbolicCosine` class to use it instead of `generic_function_ptr( )`.  To do this,

1. Open `src/revlanguage/functions/math/Func_hyperbolicCosine.cpp` in your editor.
2. **Add an `#include` statement to make the `RevBayesCore::HyperbolicCosineFunction` class visible**
3. **Modify the definition of `Func_hyperbolicCosine::createFunction()`** as follows:

``` cpp
...
#include "HyperbolicCosineFunction.h"
...
         
RevBayesCore::TypedFunction<double>* Func_hyperbolicCosine::createFunction( void ) const
{
    
    RevBayesCore::TypedDagNode<double>* x = static_cast<const Real&>( this->args[0].getVariable()->getRevObject() ).getDagNode();
    
    return new RevBayesCore::HyperbolicCosineFunction( x );
}
```