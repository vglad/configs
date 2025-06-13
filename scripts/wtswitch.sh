#!/usr/bin/env bash

# Grope up from the current directory until git worktree list returns
# some results (we might be in a symlinked folder) or we reach the root.
# Then modify the current working directory to the equivalent location
# under the specified worktree, and pushd to it.

pushd `GIT_ROOT=\`
	while : ; do
		git worktree list && break
		test . -ef .. && break
		cd ..
	done | sed 's@\(.*/\).*$@\1@;q'\` &&
pwd | sed "s@^$GIT_ROOT[^/]*@$GIT_ROOT${1?Usage: wtswitch <worktree>}@"`

