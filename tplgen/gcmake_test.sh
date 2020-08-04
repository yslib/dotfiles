#!/bin/bash

. ./utils.sh
file="CMakeLists.txt"
checkFileExists $file


cat << EOF > $file
cmake_minimum_required(VERSION 3.12)
file(GLOB_RECURSE TEST_SRC *.cpp)

add_executable(test_all)
target_sources(test_all PRIVATE \${TEST_SRC})


\# TODO:: Uncomment the two lines below to specifiy external dependencies manually.
\# target_link_libraries(test_all {...})
\# target_include_directories(test_all PRIVATE {...})

enable_testing()
find_package(GTest CONFIG REQUIRED)
target_link_libraries(test_all GTest::gtest_main GTest::gtest GTest::gmock GTest::gmock_main)

include(GoogleTest)
gtest_add_tests(test_all "" AUTO)
install(TARGETS test_all LIBRARY DESTINATION "lib" RUNTIME DESTINATION "bin" ARCHIVE DESTINATION "lib")
EOF

echo "Create finished"
echo "But you need to specifiy external dependencies manually!!!! see the TODO section"
