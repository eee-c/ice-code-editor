#!/bin/bash

# Static type analysis
results=$(dartanalyzer lib/ice.dart 2>&1)
results_ignoring_ok_deprecations=$(
  echo "$results" | \
    grep -v "'CryptoUtils' is deprecated" | \
    grep -v "'query' is deprecated" | \
    grep -v "'queryAll' is deprecated" | \
    grep -v "hints found.$"
)
echo "$results_ignoring_ok_deprecations"
count=$(echo "$results_ignoring_ok_deprecations" | wc -l)
if [[ "$count" != "1" ]]
then
  exit 1
fi
echo "Looks good!"
echo

which content_shell >/dev/null
if [[ $? -ne 0 ]]; then
  $DART_SDK/../chromium/download_contentshell.sh
  unzip content_shell-linux-x64-release.zip

  cs_path=$(ls -d drt-*)
  PATH=$cs_path:$PATH
fi

# Run different test contexts
for X in ice_test
do

  pwd

  # Run a set of Dart Unit tests
  results=$(pub run test -p 'content-shell' -r expanded test/$X.dart)

  # Can hit the debugger in Dartium with:
  # pub run test -p 'dartium' --pub-serve=8081 --pause-after-load -r expanded test/ice_test.dart

  # check to see if DumpRenderTree tests
  # fails, since it always returns 0
  if [[ $? -ne 0 ]]
  then
      echo -e "$results"
      exit 1
  fi

  echo -e "$results"

  if [[ "$results" != *"tests passed"* ]]
  then
      exit 1
  fi
done
