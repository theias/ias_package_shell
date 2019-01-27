#!/bin/bash

# The idea:
# You add your extra class paths to JAVA_ARTIFACT_CLASSPATH below.
#
# You ask this script for the sourcepath option (for compiling)
# You ask this script for the classpath option (for running)
#
# This allows you to store your classpath and sourcepath information
# for running your java app in ONE place, without environment variables

path_type="$1"

function java_paths_usage
{
	echo "First parameter is path type.  Must be only one of:"
	echo "	sourcepath"
	echo "	classpath"
}

if [ -z "$path_type" ]
then
	java_paths_usage
	exit 1
fi

bash_source_real_path="$( realpath "${BASH_SOURCE[0]}" )"
script_realpath="$( cd "$( dirname "${bash_source_real_path}" )" >/dev/null 2>&1 && pwd )"

# Put your extra class paths here
JAVA_ARTIFACT_CLASSPATH=''

JAVA_SRC_JAVA_DIR="${script_realpath}/../lib/java"
JAVA_SRC_LIB_DIR="${script_realpath}/../java/"
JAVA_BASE_LIB_DIR="/opt/IAS/lib/java"

class_path_argument="${JAVA_SRC_JAVA_DIR}:${JAVA_SRC_LIB_DIR}:${JAVA_ARTIFACT_CLASSPATH}:${JAVA_BASE_LIB_DIR}"

case "$path_type" in
"classpath")
	echo "$class_path_argument"
	;;
"sourcepath")
	echo "${JAVA_SRC_JAVA_DIR}"
	;;
*)
	java_paths_usage
	exit 1
	;;
esac
