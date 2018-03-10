---
title: Implementing a function
category: implementation
order: 0
---

There are two main classes of functions in RevBayes: member functions and typed functions. Member functions are functions used inside of deterministic nodes and allow access to member methods of a member object. Typed functions are either values within directed acyclic graph (DAG) nodes (i.e. random variables of some distribution), or are associated with a deterministic node. All deterministic nodes hold a function, the value of these deterministic nodes are returned by a call to that function. This has the advantage of simply modifying the value instead of creating a new object.

For our example implementation we will be implementing a typed function. We will begin with a simple example of implementing a mathematical function, the hyperbolic cosine function. First we need to add two files to the RevBayes source code, a `HyperbolicCosineFunction.cpp` and a `HyperbolicCosineFunction.h`. These will go within `revbayes/src/core/functions/math` since we are adding a function and it is a mathematical function.

First, we will write our header file. Within our header file, we need to `include` a few other RevBayes header files, including `ContinousFunction.h` since hyperbolic cosine is a continuous function, and `TypedDagNode.h` since our typed function deals with nodes of DAGs.

```cpp
#ifndef HyperbolicCosineFunction_h 
#define HyperbolicCosineFunction_h

#include "ContinuousFunction.h"
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
    class HyperbolicCosineFunction : public ContinuousFunction {

        public:
                                        HyperbolicCosineFunction(const TypedDagNode<double> *a); 

            HyperbolicCosineFunction*     clone(void) const; //!< creates a clone
            void                        update(void); //!< recomputes the value

        protected:
            void                        swapParameterInternal(const DagNode *oldP, const DagNode *newP); //!< Implementation of swapping parameters

        private:
            const TypedDagNode<double>* x;

    };
}


#endif
```
The first part of this file should be the standard header that goes in all the files giving a brief description about what that file is as well as information about the copyright and the author of that file.
Next, after including the necessary header files, we have to ensure that our new function is included within the `RevBayesCore` namespace.
Here we are implementing our hyperbolic cosine function as its own class that is derived from the continuous function class that is derived from the typed function class. This class stores the hyperbolic cosine of a value that is held in a DAG node. We have also defined a clone method which can create a clone of our class, and an update method which will update the value of our Hyperbolic Cosine class whenever the value of the DAG node changes. Now we will move on to the `HyperbolicCosineFunction.cpp` file.

```cpp
#include "HyperbolicCosineFunction.h"

using namespace RevBayesCore;

HyperbolicCosineFunction::HyperbolicCosineFunction(const TypedDagNode<double> *a) : ContinuousFunction( new double(0.0) ),
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
    
    // recompute and set the internal value
    double myValue = x -> getValue();
    double x1 = exp(myValue) + exp(-myValue);
    *value = 0.5 * x1;

}
```


Now all we need to do is add the hyperbolic cosine function to the `revlanguage` side of things so that when we are using `Rev` we can use our function. First we need to add `Func_hyperbolicCosine.cpp` and `Func_hyperbolicCosine.h` to `/src/revlanguage/functions/math/`. Note that the directory structure of `revlanguage` is similar to that of the `core`. The Revlanguage side serves as a wrapper of the function that we just wrote in the `core`.

The `Func_hyperbolicCosine.h` should look like the following:

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
     * @copyright Copyright 2009-
     * @author The RevBayes Development Core Team (<your-name>)
     * @since 2016-09-26, version 1.0
     *
     */
    class Func_hyperbolicCosine :  public TypedFunction<Real> {
        
    public:
        Func_hyperbolicCosine( void );
        
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

And the `Func_hyperbolicCosine.cpp` should look like this:

```cpp
#include "Func_hyperbolicCosine.h"
#include "HyperbolicCosineFunction.h"
#include "Probability.h"
#include "Real.h"
#include "RlDeterministicNode.h"
#include "TypedDagNode.h"

using namespace RevLanguage;

/** default constructor */
Func_hyperbolicCosine::Func_hyperbolicCosine( void ) : TypedFunction<Real>( )
{
    
}


/**
 * The clone function is a convenience function to create proper copies of inherited objected.
 * E.g. a.clone() will create a clone of the correct type even if 'a' is of derived type 'b'.
 *
 * \return A new copy of the process.
 */
Func_hyperbolicCosine* Func_hyperbolicCosine::clone( void ) const
{
    
    return new Func_hyperbolicCosine( *this );
}


RevBayesCore::TypedFunction<double>* Func_hyperbolicCosine::createFunction( void ) const
{
    
    RevBayesCore::TypedDagNode<double>* x = static_cast<const Real&>( this->args[0].getVariable()->getRevObject() ).getDagNode();
    RevBayesCore::HyperbolicCosineFunction* f = new RevBayesCore::HyperbolicCosineFunction( x );
    
    return f;
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


Finally, we need to include the hyperbolic cosine function in the `RbRegister_Func.cpp` file located in the `/revlanguage/workspace/` directory. To do this go to the `RbRegister_Func.cpp` file and locate the math functions and type `#include Func_hyperbolicCosine.h` in the correct alphabetical order for that group. Now scroll down in that file until you find the math functions and add the line `addFunction( new Func_hyperbolicCosine());`
