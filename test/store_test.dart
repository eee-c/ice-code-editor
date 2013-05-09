import 'package:unittest/unittest.dart';
import 'package:ice_code_editor/store.dart';
import 'dart:html';

main() {
  group("gzipping", () {
    test("it can encode text", (){
      expect(Store.encode("Howdy, Bob!"), equals("88gvT6nUUXDKT1IEAA=="));
    });

    test("it can decode as text", (){
      expect(Store.decode("88gvT6nUUXDKT1IEAA=="), equals("Howdy, Bob!"));
    });
  });
}
