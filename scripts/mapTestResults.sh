#!/usr/bin/env -S bash

# Usage something like this:
# ls *.result_ | mapTestResults.sh | sh

# TLDR:
# Outputs a script to link all the failed test result files and the expected
# results to parallel "pass" and "fail" folders to allow easy diffing with meld.
# eg. meld pass fail

# Longer explanation:
# The testRunner.sh script checks the output of code under test against
# expected result files (usually named with a .result suffix) and if they
# differ leaves a copy of the results received with a .result_ suffix.
# ./
# ├── ATOSTR_1Q18_LocalTest.result
# └── ATOSTR_1Q18_LocalTest.result_
# These can be diff'd in situ
# eg. meld myTest.result myTest.result_
#
# If you have a number of similar test results it is more convenient for
# the failed actual results to have the same name as the expected results
# but for them to be in parallel directories. This script generates
# the shell instructions to arrange the files in that way.
# ./
# ├── fail
# │   ├── ATOSTR_1Q18_LocalTest.result
# │   ├── ATOSTR_1Q19_LocalTest.result
# │   ├── ...
# └── pass
#     ├── ATOSTR_1Q18_LocalTest.result
#     ├── ATOSTR_1Q19_LocalTest.result
#     ├── ...
# Now it's possible to diff the pass and fail folders in one go with meld
# eg. meld pass fail

sed '
 # Output a command before our first line of output to create
 # pass and fail directories
 1i mkdir -p pass fail 
 # Chop the trailing _ off the filename 
 s/_$//
 # Write a fragment of shell script to hard link the pass and fail files
 # to entries in the pass and fail directories.
 s!\(.*/\)*\(.*\)!(cd pass \&\& ln -f ../& .) \&\& (cd fail \&\& ln -f ../&_ \2)!
'
