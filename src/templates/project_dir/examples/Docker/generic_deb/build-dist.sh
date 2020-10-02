#!/bin/bash

set -e

cd /[% project_dir %]/
fakeroot make package-deb
