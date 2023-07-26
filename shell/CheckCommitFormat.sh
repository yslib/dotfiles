CLANG_FORMAT=clang-format
if git rev-parse --verify HEAD >/dev/null 2>&1
then
	against=HEAD
else
	# Initial commit: diff against an empty tree object
	against=$(git hash-object -t tree /dev/null)
fi
changed_files=$(git diff-index --cached --diff-filter=ACMR --name-only $against -- '*.c' '*.cpp' '*.cxx' '*.cc' '*.h' '*.hpp')

if [ -z "$changed_files" ]
then
    echo "no file changes"
    exit 0
fi
$CLANG_FORMAT --dry-run -Werror $changed_files

if [ $? -ne 0 ]; then
    echo "fix things listed above"
    exit 1
fi

exit 0
