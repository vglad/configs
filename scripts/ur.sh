#!/bin/bash

# This script accumulates commands needed to overwrite expected test
# results with a current test results. So the next same tests run
# shows no differences

run_folder="/divergence"
current_directory=$(pwd)

# Run the command only if it is executed from a */divergence folder
if [[ "$current_directory" == *"$run_folder" ]]; then
    # Update test results, clean "pass" and "fail" folders
    ls *_ | updateTestResults.sh | sh && rm -rf pass/ fail/
else
    # Not in the specific folder
    echo "Not in the */divergence folder. Command will not be executed."
fi
