---
title: Documentation guidelines
category: best_practices
order: 1
---

RevBayes uses Doxygen to compile documentation from the code. Documentation is critical to help other programmers understand the code, so here are some guidelines to get you started.

## Important notes
 * member functions which reimplement functions from a parent class will automatically inherit their documentation from the parent. Only document these if additional details are required. The `@copydoc` commands allows to copy documentation from any other class or member.
 * long documentation should always be placed just before the definition it applies to. Brief descriptions can be placed after members.

## Header files (.h)
 * document the class, with references (using the `@cite` command with a BibTEX reference) if applicable.
 * all members (functions and variables) including the private ones should be followed by a brief description (unless the parent description is adequate).
 * the `@file` annotation should be used only when the file contains no classes, otherwise classes should be documented rather than files.

## Implementation files (.cpp)
 * detailed descriptions of member functions go there (unless the parent description is adequate).
 * the commands `@param`, `@return` and `@throw` are used to document respectively the parameters, the return value and the exceptions thrown.
 * simple getters and setters do not need detailed documentation.

## Other useful doxygen commands
 * LateX-style formulas can be included using the `@f$` annotation for inline text (example: `@f$n^2@f$`), and the `@f[` and `@f]` annotations for equations (example: `@f[ x = sum_{i=1}^n y^i @f]`)
 * `@todo` and `@bug` to document problematic behavior or missing features
 * `@note` and `@warning` to document tricky or unexpected behavior
 * `@see` to reference other classes/methods

## Do
 * include information about memory side-effects of the code, in particular the use of new and delete.
 * document the default values of the parameters, if applicable.
 * document private members.
 * inherit documentation or use the `@copydoc` command instead of copy-pasting whenever possible.
 * run Doxygen and check the output before submitting your new documentation.

## Do not
 * replicate information given by git, such as author, license or modification dates of the files. Exception: code adapted or copied from outside the RevBayes project should be credited to the original author and include licensing information if applicable.
 * restate information easily available in the code, such as the parent class.
 * leave commented-out code unless accompanied by a comment stating what it does and why it was left in.