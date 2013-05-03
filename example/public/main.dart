import 'package:ice_code_editor/editor.dart' as ICE;

main() {
  var ice = new ICE.Editor('ace');
  ice.content = '''
main() {
  print("Dart rocks");
}''';

}
