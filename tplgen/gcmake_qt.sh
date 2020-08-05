
#!/bin/bash
file="CMakeLists.txt"

. $(dirname ${BASH_SOURCE})/utils.sh
checkFileExists $file


echo "target name:"
read project_name

echo "source directory:"
read src_dir

echo "include directory:"
read inc_dir

echo "${inc_dir}"

echo "external lib modules:"
read lib_modules
echo "${lib_modules}"

echo "qt lib modules:"
read qt_modules


inc_dir_cmake_cmd=""
libs_cmake_cmd=""

if test -n "${lib_modules}"
then
  libs_cmake_cmd="target_link_libraries(\${PROJ_NAME} ${lib_modules})"

fi

if test -n "${inc_dir}"
then
  dir_str=""
  for d in ${inc_dir}
  do
    dir_str="$dir_str \"$d\""
  done
  inc_dir_cmake_cmd="target_include_directories(\${PROJ_NAME} PRIVATE ${dir_str})"
fi

cat << EOF > ${file}

cmake_minimum_required(VERSION 3.12)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(PROJ_NAME ${project_name})
project(\${PROJ_NAME})

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS ON)
set(CMAKE_AUTOMOC)

set(\${SRC_DIR} ${src_dir})
aux_source_directory(\${SRC_DIR} SRC)

add_executable(\${PROJ_NAME})
target_sources(\${PROJ_NAME} PRIVATE \${SRC})

${inc_dir_cmake_cmd}

${libs_cmake_cmd}

install(TARGETS \${PROJ_NAME} LIBRARY DESTINATION "lib" RUNTIME DESTINATION "bin" ARCHIVE DESTINATION "lib")
EOF
