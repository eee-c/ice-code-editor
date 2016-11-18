#!/bin/bash

# Generates an application cache manifest file suitable for
# deployment. The EXTERNAL_LIBS shown are specific to the gamingjs.com
# site, but can be tweaked for deployments to other sites.

# TODO: investigate excluding main.dart.precompiled.js from manifest

# Name of the manifest file:
APPCACHE=editor.appcache

# Change this list to suit different deployment needs:
read -d '' EXTERNAL_LIBS <<EOF
/favicon.ico
/Three.js
/Tween.js
/Detector.js
/physi.js
/Mouse.js
/Scoreboard.js
/ChromeFixes.js
/ammo.js
/physijs_worker.js
EOF

########

# Have to list these first or risk script load order problems
# TODO: investigate if this is still a problem.
read -d '' LIST_FIRST <<EOF
packages/ice_code_editor/js/deflate/rawdeflate.js
packages/ice_code_editor/js/deflate/rawinflate.js
EOF

##
# Manifest
echo 'CACHE MANIFEST' > $APPCACHE
date +'# %Y-%m-%d %H:%M:%S' >> $APPCACHE
echo >> $APPCACHE

##
# Cache

echo 'CACHE:' >> $APPCACHE

# Fixed files used within the editor for creating Three.js worlds:
echo "$LIST_FIRST" >> $APPCACHE
echo >> $APPCACHE
echo "$EXTERNAL_LIBS" >> $APPCACHE
echo >> $APPCACHE

# Dart and JS code used to make the editor:
find | \
  grep -e \\.js$ -e \\.map$ -e \\.html$ -e \\.css$ | \
  grep -v -e unittest -e /lib/ -e polymer -e web_components -e js/deflate | \
  grep -v packages/ace/src | \
  sed 's/^\.\///' \
  >> $APPCACHE

find packages/ace/src | \
  grep -f ~/repos/ice-code-editor/bin/ace_src_files.txt | \
  sed 's/^\.\///' \
  >> $APPCACHE


##
# Network
cat <<EOF >> $APPCACHE

NETWORK:
*
EOF
