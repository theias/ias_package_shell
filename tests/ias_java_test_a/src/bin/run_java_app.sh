#!/bin/bash

app_name="$1"

if [ -z "$app_name" ]
then
	app_name="edu.ias.net.SampleApplication"
fi

bash_source_real_path="$( realpath "${BASH_SOURCE[0]}" )"
script_realpath="$( cd "$( dirname "${bash_source_real_path}" )" >/dev/null 2>&1 && pwd )"

java \
	-classpath "$( $script_realpath/java_paths.sh classpath)" \
	"$app_name"
