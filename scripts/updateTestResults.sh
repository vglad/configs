#!/usr/bin/env -S bash

# Write a script to replace all expected results with 'failed' results
# (presumambly because they are diffs that represent improvements).
#
# See mapTestResults.sh for the background to this command.
sed '
 s/_$//
 s/.*/mv &_ &/
'
