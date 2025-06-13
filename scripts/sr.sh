#!/bin/bash

# This script accumulates commands needed to display the difference in
# current and expected test results

run_folder="/divergence"
current_directory=$(pwd)

# Run the command only if it is executed from a */divergence folder
if [[ "$current_directory" == *"$run_folder" ]]; then
    rm -rf pass/ fail/
    
    # Map test results and generate new pass/ and fail/ folders using an external script
    ls *_ | mapTestResults.sh | sh 

    # Apply sed command to each file in the pass folder
    for file in pass/*; do
        if [ -f "$file" ]; then
            # Remove non-main tables
            sed -i '/^[A-Z][A-Z]`0`/,/^$/d' "$file"
        fi
    done
    
    # Apply sed command to each file in the fail folder
    for file in fail/*; do
        if [ -f "$file" ]; then
            # Remove non-main tables
            sed -i '/^[A-Z][A-Z]`0`/,/^$/d' "$file"
        fi  
    done
    
    # Launch meld to display differences between the processed folders
    meld pass/ fail/
else
    # Not in the specific folder
    echo "Not in the */divergence folder. Command will not be executed."
fi 
