#!/bin/sh

# For deployment targets such as GitHub pages, this script replaces
# the symbolic links in Dart's packages directory with the actual
# contents of those libraries.

cd packages
for file in *; do
    if [ ! -L $file ]; then
        echo "Symlinked packages already replaced."
        exit 1
    fi

    link=`readlink $file`
    echo "$file ($link)"
    rm $file
    cp -r $link $file
done
