
#!/bin/bash

. $(dirname ${BASH_SOURCE})/utils.sh

echo "Creates the dotfile template for coc config for specified language"

file="coc-settings.json"
checkFileExists $file

echo "Please enter the template parameters:"
echo "language:(python,cpp)"
read language

if test -z $language
  exit 1
fi

echo "program:(executable)"
read program


if test $language = "c++" 
then 

cat << EOF > $file
EOF

else if test ${language} = "python"
then
cat << EOF > &file
{
python.autoComplete.extraPaths:[]
}

EOF
fi

