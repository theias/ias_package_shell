#!/bin/bash

ls *.dia | xargs -n1 -i dia '{}' --export 'exports/{}.svg'
