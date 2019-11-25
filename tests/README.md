# IMPORTANT

Some of these directories contain symbolic links to the files under src/template
because they can be used directly from the test, without having to regenerate
another package template every time you want to test something.

# Notes

Several different tests are automated.  The tests in this section are currently
included in the Makefile, and part of the "regular" tests.

Run **make package_shell_all_tests** to do the testing.

These tests require the Debian package build programs, and the RPM package
build programs.

## ias_package_shell_test_package_basic

Contains just a file under src/bin .  This is quite the lowest common
denominator for a package test.

## ias_package_shell_test_package_a

Should contain examples of ALL of the directories / features.

## ias_package_shell_package_division_test

Demonstrates the ability to have different artifacts generated from the same
project tree.

## ias_package_shell_test_fresh_package

Generates a fresh project every time based off of answers found in
answers_ias_package_shell_test_fresh_package.txt .

# Oddballs

## ias_java_test_a

This is probably at a point where it should be moved out of this directory.

In order to try to avoid making design decisions that exclude languages like
Java, I included an example for how to create a package containing Java
components.  It eventually grew into a layout, and the ability to run against
class files under lib; along with being able to run correctly when installed
using the full project layout.

## run_parts_example

I don't think I'm using this for anything (yet).

I believe I was going to have a list of directories for which run parts could
run testing.  I ended up (currently) specifying tests in the Makefile.
