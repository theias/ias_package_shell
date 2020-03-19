#!/bin/bash

set -e

cd CMD /[% project_dir %]/
fakeroot make package-rpm
