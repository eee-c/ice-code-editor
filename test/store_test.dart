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

  group("store/retrieve", (){
    var it;
    setUp(()=> it = new Store());

    test("it can store data", (){
      it['foo'] = {'bar': 42};
      expect(it['foo']['bar'], equals(42));
    });

    test("it can store multiple records", (){
      it['one'] = {'bar': 1};
      it['two'] = {'bar': 2};
      it['foo'] = {'bar': 42};
      expect(it['foo']['bar'], equals(42));
    });

    test("it can retrive arbitrary records", (){
      it['one'] = {'bar': 1};
      it['two'] = {'bar': 2};
      it['foo'] = {'bar': 42};
      expect(it['one']['bar'], equals(1));
    });

    test("it can overwrite existing records", (){
      it['one'] = {'bar': 1};
      it['two'] = {'bar': 2};
      it['foo'] = {'bar': 42};
      it['two'] = {'bar': 7};
      expect(it['two']['bar'], equals(7));
    });

    test("it does not create new records when overwriting old ones", (){
      it['one'] = {'bar': 1};
      it['two'] = {'bar': 2};
      it['foo'] = {'bar': 42};
      it['two'] = {'bar': 7};
      expect(it.length, equals(3));
    });
  });

  group("store/retrieve", (){
    var it;
    setUp(()=> it = new Store());

    test("records persist", (){
      it['foo'] = {'bar': 42};
      it.refresh();

      expect(it['foo']['bar'], equals(42));
    });
  });

}
