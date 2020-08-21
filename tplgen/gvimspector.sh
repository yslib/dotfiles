
#!/bin/bash

. $(dirname ${BASH_SOURCE})/utils.sh

echo "Creates the dotfile template for vimspector, a visualized debug plugin for vim"

file=".vimspector.json"
checkFileExists $file

echo "Please enter the template parameters:"
echo "language:(python,cpp)"
read language

if test -z $language
then 
  exit 1
fi

echo "program:(executable)"
read program


if test $language = "c++" 
then 
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
elif test ${language} = "python"
then
cat << EOF > $file
{
"\$schema": "https://puremourning.github.io/vimspector/schema/vimspector.schema.json#",
"configurations": {

      "Launch": {
            "adapter": "debugpy",
            "configuration": {
                    "name": "Launch",
                    "type": "python",
                    "request": "launch",
                    "cwd": "${workspaceRoot}",
                    "python": "python2",
                    "stopOnEntry": true,
                    "console": "externalTerminal",
                    "debugOptions": [],
                    "program": "${workspaceRoot}/${program}"
                  }
          }
}
}
EOF
fi

