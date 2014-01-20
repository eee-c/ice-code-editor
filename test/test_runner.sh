#!/bin/bash

# Static type analysis
results=$(dartanalyzer --no-hints lib/ice.dart 2>&1)
non_js_results=$(
  echo "$results" | \
    grep -v "is not defined for the class 'Proxy'" | \
    grep -v "There is no such getter '.*' in 'Proxy'"
)
echo "$non_js_results"
non_js_count=$(echo "$non_js_results" | grep -vF '[hint]' | wc -l)
if [[ "$non_js_count" != "2" ]]
then
  echo "$non_js_count"
  exit 1
fi
if [[ "$non_js_results" == *"warnings found."* ]]
then
  echo "Ignoring js-interop warnings..."
fi
echo

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

  if [[ "$results" == *"Exception: "* ]]
  then
      exit 1
  fi
done
