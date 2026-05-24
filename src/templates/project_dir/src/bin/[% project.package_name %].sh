#!/bin/bash

# Save a copy of all of the arguments
all_arguments=( "$@" )


function usage
{
	cat <<EndOfUsage
NAME
$0

DESCRIPTION
Does stuff

SYNOPSIS
	$0 [-v] [-e]

OPTIONS
	-v : enable verbose
	-e : exit with a non-zero status

EndOfUsage
}

function verbose_output
{
	if [[ "$verbose" == "1" ]]
	then
		printf "$@"
	fi
}

# Process options
verbose=0
exit_with_error=0

while getopts "ve" o; do
    case "${o}" in
        v)
            verbose=1
            ;;
		e)
			exit_with_error=1
			;;
        *)
            usage
			exit 1
            ;;
    esac
done

shift $((OPTIND-1))

timestamp=$( date "+%Y-%m-%d %H:%M:%S" )

printf '%s\t%s\n' "$timestamp" "Hello."
all_arguments_string="${all_arguments[@]}"

verbose_output "%s: %s\n" 'All arguments' "$all_arguments_string"

exit $exit_with_error
