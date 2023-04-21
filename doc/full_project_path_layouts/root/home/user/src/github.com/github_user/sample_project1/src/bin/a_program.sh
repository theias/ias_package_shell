#!/usr/bin/bash

# Identifies itself
# Says hello
# Displays the arguments it was run with
# Outputs a file if it's provided.

all_arguments=( "$@" )

some_file="$1"; shift

date
printf "%s\n" "I am $(basename $0)"
printf "%s\n" "Hello"
printf "%s\n\t%s\n" "I was run with:" "${all_arguments[@]}"
if [[ -f "$some_file" ]]
then
	printf "%s\n" "Here are the contents of $some_file"
	cat "$some_file"
else
	printf "%s\n" "I wasn't given anything to process"
fi

