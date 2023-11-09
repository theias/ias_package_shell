#!/bin/bash

# For simplicity, you can add functions to this file.
# Eventually, though, maybe they should live under
# tests/lib/bash5/ somewhere.

function say_bashlib_test_hello
{
	printf "%s\n" "Hello from $BASH_SOURCE"
}
