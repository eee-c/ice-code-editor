#!/bin/bash

# Static type analysis
results=$(dartanalyzer lib/ice.dart 2>&1)
results_ignoring_ok_deprecations=$(
  echo "$results" | \
    grep -v "'query' is deprecated" | \
    grep -v "'queryAll' is deprecated" | \
    grep -v "hints found.$"
)
echo "$results_ignoring_ok_deprecations"
count=$(echo "$results_ignoring_ok_deprecations" | wc -l)
if [[ "$count" != "2" ]]
then
  exit 1
fi
echo "Looks good!"
echo

which content_shell
if [[ $? -ne 0 ]]; then
  $DART_SDK/../chromium/download_contentshell.sh
  unzip content_shell-linux-x64-release.zip

  cs_path=$(ls -d drt-*)
  PATH=$cs_path:$PATH
fi

# Run different test contexts
for X in polymer/index html5 index
do
  # Run a set of Dart Unit tests
  results=$(content_shell --dump-render-tree test/$X.html)
  echo -e "$results"

  # check to see if DumpRenderTree tests
  # fails, since it always returns 0
  if [[ "$results" == *"Some tests failed"* ]]
  then
      exit 1
  fi

  if [[ "$results" == *"Exception: "* ]]
  then
      exit 1
  fi
done
