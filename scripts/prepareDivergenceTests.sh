#!/usr/bin/env bash

# Establish a directory in which to perform divergence (regression) tests
# for specified companies and generate a script to run them.
#
# prepareDivergenceTests.sh -c [COMPANY_ID ... ]
#
# OPTIONS
# -c
#	Write a script to standard out that if executed will clean the temporary
#	and debug files from a regression test folder without removing the test
#	files themselves, and indicates approximately how much space would be
#	saved as a result.
#
# eg prepareDivergenceTests.sh matalan hema newlook
# eg prepareDivergenceTests.sh -c matalan hema newlook
#

set -e

# Check for the -c "clean" option flag.
case "$1" in
-c)	# Work out how much space is used by the subdirectories supplied as args
	# and prepare commands to clean them.
	shift
	case "$*" in
	'')	# If no company name has been supplied, but we can see a divergence
		# directory below our current location, set our args as though a .
		# had been specified.
		test -d ./divergence && set - . ;;
	esac

	# Filenames that we want to get disk usage for and prep a remove script.
	LIST="batch batch-* preproc tmp debug pass fail *.*result*"

	# Take our supplied args as directories to be cleaned.
	for DIR
	do
		# Visit each directory and get the size of files in the list and
		# edit the list into a cleaning script.
		( cd $DIR/divergence 2>/dev/null && du -ch $LIST 2>/dev/null || true ) | sed '
		 # Delete all but the last line (to du total)
		 $!d
		 # Remove the words to leave only the size value.
		 s/\t.*$//
		 # If the size is zero, delete the line.
		 /^0$/d
		 # Generate a command to clean the directory and give the size.
		 s@^.*$@( cd '"$DIR"'/divergence \&\& rm -rf '"$LIST"' ) # &@
		'
	done
	exit
esac

# Prepare test folders for all the supplied company names.
for NAME
do
	echo "preparing $NAME" >&2
	mkdir -p $NAME/divergence
	{ cat <<- .
	#!/usr/bin/env bash

	GET_CMD="aws s3 cp --only-show-errors" \\
	DOC_DIR="s3://com.cognitivecredit.bond-analytics-live.staging.application/documents" \\
	COMPANY_ID=$NAME \\
	\`while :
	do
	    test -x divergenceTestRunner.sh && pwd && break
	    test . -ef .. && break
	    cd ..
	done\`/divergenceTestRunner.sh "\$@"
	.
	} > $NAME/divergence/runDivergenceTests.sh
	chmod 755 $NAME/divergence/runDivergenceTests.sh
done

