
#!/bin/bash

checkFileExists()
{
  file=$1
  if test -f $file
  then
    echo "${file} is already exists, override it?(y)"
    read ans
    if test -z $ans || test $ans != 'y'
    then
      exit 1
    fi
  fi
}
