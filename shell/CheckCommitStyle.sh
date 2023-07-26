CLANG_TIDY=clang-tidy
if git rev-parse --verify HEAD >/dev/null 2>&1
then
	against=HEAD
else
	# Initial commit: diff against an empty tree object
	against=$(git hash-object -t tree /dev/null)
fi
changed_files=$(git diff-index --cached --diff-filter=ACMR --name-only $against -- '*.c' '*.cpp' '*.cxx' '*.cc' '*.h')

if [ -z "$changed_files" ]
then
    echo "no file changes"
    exit 0
fi

if [ -z "$1" ]
then
    cmd="$CLANG_TIDY --use-color $changed_files"
else
    cmd="$CLANG_TIDY --use-color -p $1 $changed_files"
fi

{ tidy_res=$(eval $cmd | tee >(grep readability-identifier-naming) >&3); } 3>&2
if [ ! -z "$tidy_res" ]; then
    echo "fix things listed above. You need only fix those with [readability-identifier-naming] check"
    exit 1
fi

exit 0
