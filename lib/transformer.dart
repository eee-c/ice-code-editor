library ice_code_editor.transformer;

import 'dart:async';

import 'package:barback/barback.dart';

class ProductionMode extends Transformer {
  List entryPoints;

  ProductionMode(this.entryPoints);

  ProductionMode.asPlugin(BarbackSettings settings)
    : this(_parseSettings(settings));

  Future<bool> isPrimary(Asset input) {
    if (entryPoints.contains(input.id.path)) return new Future.value(true);
    return new Future.value(false);
  }

  Future apply(Transform transform) {
    var input = transform.primaryInput;
    // print("[apply] ${input.id.path}");

    return transform.
      readInputAsString(input.id).
      then((html){
        var fixed = html.replaceAllMapped(
          new RegExp(r'\.debug\.js'),
          (m) => '.min.js'
        );

        transform.addOutput(new Asset.fromString(input.id, fixed));
      });
  }
}

List<String> _parseSettings(BarbackSettings settings) {
  var args = settings.configuration;
  return _readEntrypoints(args['entry_points']);
}

List<String> _readEntrypoints(value) {
  if (value == null) return null;
  return (value is List) ? value : [value];
}
