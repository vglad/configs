#!/usr/bin/env -S bash

# Read a renderer trace file and write out an html representation of it, with
# jpgs for the pages going to an image dir created in the current folder.

# If no args are supplied the caller must supply a suitable renderer trace.log
# on standard input and the DOCID (eg acme-d34db33f) as and environment
# variable and the results will be written to standard output.
# eg. DOCID=intrum-2b594a9d < _trace.log formatRendererTrace.sh > trace.html

# If a test file is supplied as an argument it will be read for the DOCID
# and a _trace.log file searched for in the common folder structure used for
# regression or divergence tests, with the results written to a filename
# based on the test name, and the path to that file written to standard output
# so that the results can be viewed directly in a browser
# eg. firefox `formatRendererTrace.sh INTRUM_1Q17_LocalTest`

set -e

# Grope up the tree for the traceUtils.sh.
CCHOME=${CCHOME:-`while : ; do test -f pdf-renderer/scripts/traceUtils.sh && pwd && break; test . -ef .. && break; cd .. ; done`} && \
	CCHOME=`test -d "$CCHOME" && cd "$CCHOME/pdf-renderer/scripts" && pwd` || \
		: ${CCHOME:?"Can't determine utils directory"}

# If we have an command line argument argument, assume it is a test file name
# and that we are in a unit test folder. Otherwise, we'll just read from
# standard input.
case "$1" in
?*) # Try to get a DOCID from the testfile
	TESTFILE=`echo "$1" | sed 's/\.result_*$//'`
	DOCID=`cat ../$TESTFILE`

	# Try looking for a trace in the batch folder (created when we pull
	# an extractor batch).
	if test -f "batch/$TESTFILE/renderer/_trace.log"
	then
		# If successful, print the name of the file which will receive our results
		echo "batch/$TESTFILE/renderer/${TESTFILE}_trace.html"
		# go to the renderer folder that contains a trace log.
		cd batch/$TESTFILE/renderer
		# open the _trace.log as stdin and trace.html as stdout.
		exec < _trace.log
		exec 1> ${TESTFILE}_trace.html

	# If not there, try looking in the current directory (renderer output
	# area)...
	elif test -f "${TESTFILE}_trace.txt.result_"
	then
		# If successful, print the name of the file which will receive our results
		echo "${TESTFILE}_trace.html"
		# open the _trace.log as stdin and trace.html as stdout.
		exec < ${TESTFILE}_trace.txt.result_
		exec 1> ${TESTFILE}_trace.html

	# Otherwise fail.
	else
		echo "Can't find a trace file for $TESTFILE to format" >&2 && exit 1
	fi
	;;
esac

# Assert that we have a DOCID.
: ${DOCID?}
# Source the traceUtils.sh for filters to use.
. $CCHOME/traceUtils.sh

# Verify the JSON and put it in standard format
jq . |
{
	# add a prefix html
	cat $CCHOME/logToHtml_head.html $CCHOME/traceToHtml_menu.html
	# convert the json trace to html
	sed -f $CCHOME/logToHtml.sed -e s/__DOCID__/$DOCID/g
	# and close the html
	echo '</body> </html>'
} | { 
	# If we don't have the original pdf doc in a local file...
	if ! test -f $DOCID.pdf
	then
		# ...grab the pdf and generate the page images
		export PDF=$DOCID.pdf && 
		wget https://resources.staging.cognitivecredit.com/documents/$PDF &&
		eval "$SPLIT_RESULT_JPEG"
	else
		cat
	fi
}

		#wget https://resources.staging.cognitivecredit.com/documents/$PDF &&
		#aws s3 cp "s3://com.cognitivecredit.bond-analytics-live.staging.application/documents/$PDF" &&
