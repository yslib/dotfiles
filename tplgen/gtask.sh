#!/bin/bash

echo "This bash shell is used to create template dotfile for asynctask, a vim plugin"

. ./utils.sh

file=".tasks"
checkFileExists $file

echo "build cmd:"
read build_cmd

echo "run_cmd:"
read run_cmd

#template
cat << EOF > ${file}
[project-build]
command=${build_cmd}
cwd=\$(VIM_ROOT)/build
output=quickfix
pos=tab

[project-run]
command=${run_cmd}
cwd=<root>
output=quickfix
pos=tab
EOF

echo ".tasks is created"
