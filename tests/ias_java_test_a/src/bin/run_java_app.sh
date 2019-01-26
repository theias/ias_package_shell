#!/bin/bash

app_name="$1"

if [ -z "$app_name" ]
then
	app_name="IAS/SampleApplication"
fi

bash_source_real_path="$( realpath "${BASH_SOURCE[0]}" )"
script_realpath="$( cd "$( dirname "${bash_source_real_path}" )" >/dev/null 2>&1 && pwd )"

# Put your extra class paths here
JAVA_ARTIFACT_CLASSPATH=''

JAVA_SRC_JAVA_DIR="${script_realpath}/../lib/java"
JAVA_SRC_LIB_DIR="${script_realpath}/../java/"
JAVA_BASE_LIB_DIR="/opt/IAS/lib/java"

class_path_argument="${JAVA_SRC_JAVA_DIR}:${JAVA_SRC_LIB_DIR}:${JAVA_ARTIFACT_CLASSPATH}:${JAVA_BASE_LIB_DIR}"

# echo "$class_path_argument"

java \
	-classpath "$class_path_argument" \
	"$app_name"
