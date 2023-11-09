# Tests

This project contains working examples for:

* program wrappers ( test_[% project.package_name %].sh )
* showing what testing variables are available ( dump_test_vars.sh )

## Workflow

It is very common for programmers to run their programs repeatedly.
Wrappers allow for:

* Consistency 
	* It (should be) easier to run your programs under the same conditions
when you run them with a wrapper.
	* It (should be) easy to identify which wrapping scripts were
used for development.

### Stage 1: Using Wrappers to run your tests

* Start writing your program.
* Configure (and/or) rename test_[% project.package_name %].sh to run your program
under the main use case
* Run test_[% project.package_name %].sh to test the use case.

When you need to test other scenarios, you can copy test_[% project.package_name %].sh
to something else in the tests/bin dir.

Make sure these scripts (for example) create a proper environment for
the tests to run.

### Stage 2: Use the Test Anything Protocol

* The tests/t directory contains a main_tests.t program.
* Add (some of / as many as you want) tests from Stage 1.


## Testing Directory Layout

All of these variables are defined under etc/test_project_paths.bash :

* $test_dir: Tests shall be defined under the project root under "tests".
	* project_dir/tests/ (typically)
* $test_etc_dir - Configuration for how tests should be run, and for tests
themselves.
	* project_dir/tests/etc
* $test_lib_dir - Libraries for testing purposes.
	* project_dir/tests/lib
* $test_bin_dir - Where you put programs that actually do the testing.
	* project_dir/tests/bin
* $test_data_dir - Put (redacted) data files here for testing.
	* project_dir/tests/data
* $test_t_dir - Tests that conform to the [TAP](https://testanything.org) protocol.
You can use this to call your scripts in the $test_bin_dir.
	* project_dir/tests/t

## Other (Useful) Available Variables

* $project_dir - the root of the project
* $project_bin_dir - where your programs live
	* project_dir/src/bin
* $project_lib_dir - your script libraries
	* project_dir/src/lib
* $project_etc_dir - your programs configuration files
	* project_dir/src/etc
* $project_root_etc_dir - configuration files that will be stored under /etc/
	* project_dir/src/root_etc
* $project_input_dir - transient files for using as input
	* project_dir/src/input
* $project_output_dir - directory for storing transient output files
	* project_dir/src/output


