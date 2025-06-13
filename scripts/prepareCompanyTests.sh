#!/usr/bin/env bash

# Extracts the DEV-XXXX pattern from the current directory path.
branch=$(pwd | grep -o 'DEV-[0-9]\+')

if [ -z "$branch" ]; then
    branch=$(pwd | grep -o 'main')
fi

if [ -z "$branch" ]; then
    echo "E: Git branch name not specified."
    exit 1
fi

mkdir -p "$HOME/dev/document_pipeline-extractor/$branch/pdf-renderer/scripts/test/extractTableValues/regressionTest"
mkdir -p "$HOME/dev/document_pipeline-extractor/$branch/data-extractor/scripts/test/extractTableValues/regressionTest"

# Checks if the first command line argument is provided.
if [ -z "$1" ]; then
    echo "E: Company name not specified."
    exit 1
fi


{

cd "$HOME/dev/document_pipeline-extractor/$branch/pdf-renderer/scripts/test/extractTableValues/regressionTest"
prepareDivergenceTests.sh $1

cd "$HOME/dev/document_pipeline-extractor/$branch/data-extractor/scripts/test/extractTableValues/regressionTest"
prepareDivergenceTests.sh $1

}

