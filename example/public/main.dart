import 'package:ice_code_editor/editor.dart' as ICE;

main() {
  var ice = new ICE.Editor('ice');

  ice.content = '''
main() {
  print("Dart rocks");
}''';

}
