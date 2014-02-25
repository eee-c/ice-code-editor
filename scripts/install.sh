#!/bin/sh

#pub install
bower install
cp -r bower_components/ace-builds/src-noconflict lib/js/ace

# modify js worker to ignore HTML

# sed script to modify code to be:

# 	        var value = this.doc.getValue();
# 	        value = value.replace(/^#!.*\n/, "\n").
# 	          replace(/^<(\w+).*?>\s*<\/\1>/gm, "").
# 	          replace(/^<!--.*?-->/gm, "").
# 	          replace(/<\/?script>/g, "");
