#!/bin/bash

# Start the pub web server
pub serve --port=8008 &
pub_serve_pid=$!

# Add ridiculous latency
sudo tc qdisc add dev lo root netem delay 100ms

# Run a set of Dart Unit tests
results=$(content_shell --dump-render-tree http://localhost:8008/test/latency.html)
echo -e "$results"

# Never forget to remove latency!
sudo tc qdisc del dev lo root

# Stop the pub web server
kill $pub_serve_pid

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
