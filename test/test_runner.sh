#!/bin/bash -e

# Static type analysis
dartanalyzer lib/ice.dart
if [[ $? != 0 ]]
  then exit 1
fi

# Run a set of Dart Unit tests
results=$(content_shell --dump-render-tree test/index.html)
echo -e "$results"

# check to see if DumpRenderTree tests
# fails, since it always returns 0
if [[ "$results" == *"Some tests failed"* ]]
then
  exit 1
fi
