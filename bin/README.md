# Build Scripts

Scripts are run in the following order:

```
~/repos/ice-code-editor/bin/ice-de-symlink-packages.sh
~/repos/ice-code-editor/bin/ice-appcache.sh
~/repos/ice-code-editor/bin/ice-compile.sh main.dart
```


To use, the scripts expect the following directory structure (used on code3dgames.com):

```
appcache.js
index.html
main.dart
pubspec.yaml
```

Where appcache.js is the standard Application Cache JavaScript file.

Index.html is:

```html
<!DOCTYPE html>
<html manifest="editor.appcache">
  <head>
    <title>code editor</title>
    <meta charset="utf-8">
    <script src="appcache.js"></script>
    <script src="main.dart" type="application/dart"></script>
  </head>
  <body>
  </body>
</html>
```

main.dart is:

```dart
library main;

import 'package:ice_code_editor/ice.dart' as ICE;

main()=> new ICE.Full();
```

And pubspec.yaml is:

```yaml
name: full_screen_ice
version: 0.0.1
description: Full screen ICE
dependencies:
  ice_code_editor: any
```
