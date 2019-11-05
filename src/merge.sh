#!/bin/sh

usage() {
    cat <<END_USAGE
merge - merge unique lines from sorted text files in a directory

Usage:  $0 [options ...] <INPUT_DIRECTORY> <OUTPUT_FILE>

Merge the lines of all of the files in INPUT_DIRECTORY into the one
OUTPUT_FILE. Skip empty lines in the input files.  Aside from the empty
lines, the lines of each input file must otherwise be sorted.  Return a zero
exit status on success or a nonzero status otherwise.

Options:

--help       Print this message to standard output and exit.

END_USAGE
}

input="$1"
output="$2"

if [ $# -gt 2 -o $# -lt 1 ]; then
    >&2 echo "too many or too few arguments"
    >&2 echo
    >&2 usage
    exit 1
fi

# if there's exactly one argument, then either it's a help flag or an error
if [ $# -eq 1 ]; then
    if [ "$1" = "-h" -o "$1" = "--help" ]; then
        usage
        exit 0
    fi
    # otherwise, too few arguments
    >&2 echo "too few arguments"
    >&2 echo
    >&2 usage
    exit 1
fi

if ! [ -d "$input" ]; then
    >&2 echo "The specified input directory \"$input\" either does not exist "
    >&2 echo "or is not a directory."
    >&2 echo
    >&2 usage
    exit 1
fi

scripts=$(mktemp -d)  # where we'll put the makefile that does the merge
work=$(mktemp -d)  # where the merge will store its intermediate results

# Copy the makefile-containing suffix of this file to a temporary file.
# The trick here is to match an "ending" comment, but not to match this pattern
# itself, so /[Ex]/ is matched instead of just the "E" in "ENDS" (the choice
# of the character "x" is arbitrary).
sed -n '/SCRIPT [Ex]NDS HERE/,$p' "$0" > "$scripts/Makefile"

make -j2 -f "$scripts/Makefile" "WORKDIR=$work" "INDIR=$input" "OUTPUT=$output"

rcode=$?
rm -r $scripts
rm -r $work

exit $rcode

# SCRIPT ENDS HERE.  MAKEFILE FOLLOWS.
