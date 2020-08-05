
#!/bin/bash

. $(dirname ${BASH_SOURCE})/utils.sh

echo "Creates the dotfile template for vimspector, a visualized debug plugin for vim"

file=".vimspector.json"
checkFileExists $file

echo "Please enter the template parameters:"
echo "program:"
read program

cat << EOF > $file
{
"\$schema": "https://puremourning.github.io/vimspector/schema/vimspector.schema.json#",
"configurations": {
    "Launch": {
      "adapter": "vscode-cpptools",
      "configuration": {
        "request": "launch",
        "program": "${program}",
        "args": [],
        "cwd": "${workspaceRoot}",
        "environment":"",
        "externalConsole": true,
        "MIMode": "gdb"
      }
    }
}
}
EOF
