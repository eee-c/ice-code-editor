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
count=$(echo "$results_ignoring_ok_deprecations" | wc -l | tr -d " ")
if [[ "$count" != "1" ]]
then
  exit 1
fi
echo "Looks good!"
echo

# Run different test contexts
for X in ice_test
do
  # Run a set of Dart Unit tests
  pub run test -p content-shell -r expanded test/$X.dart

  # Can hit the debugger in Dartium with:
  # pub run test -p 'dartium' --pub-serve=8081 --pause-after-load -r expanded test/ice_test.dart

  if [[ $? -ne 0 ]]
  then
      exit 1
  fi
done
