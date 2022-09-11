#!/bin/bash

# Bootstrap testing infrastructure
this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
my_etc_dir=${my_etc_dir:-"$this_dir/../etc"}
. "$my_etc_dir/test_project_paths.bash"


# debug_test_project_paths

"$project_bin_dir/[% project.package_name %]_hello.sh"
