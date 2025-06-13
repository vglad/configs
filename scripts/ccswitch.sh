#!/usr/bin/env bash

# Toggle (pushd) between the equivalent directory beneath the data-extractor
# or pdf-renderer parts of the extractor worktree.

pushd `pwd | sed -n ${1:+-eb$1} -e '
 ! {
  :ren
  s@/data-extractor/@/pdf-renderer/@p; q
 }
 ! {
  :ex
  s@/pdf-renderer/@/data-extractor/@p; q
 }
 s@/data-extractor/@/pdf-renderer/@p; t
 b ex
'`

