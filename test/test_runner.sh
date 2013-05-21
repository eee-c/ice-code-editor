#!/bin/bash -e

# Static type analysis
analysis=$(./tool/js_dart_analyzer lib/ice.dart)
echo -e "$analysis"
if [[ "$results" != "" ]]
  then exit 1
fi

# Run a set of Dart Unit tests
results=$(DumpRenderTree test/index.html)
echo -e "$results"

# check to see if DumpRenderTree tests
# fails, since it always returns 0
if [[ "$results" == *"Some tests failed"* ]]
then
  exit 1
fi
