#!/bin/bash -e

# Static type analysis
dartanalyzer lib/ice.dart
if [[ $? != 0 ]]
  then exit 1
fi

# Run different test contexts
for X in index html5
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
done
