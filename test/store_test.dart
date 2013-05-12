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
    setUp(()=> it = new Store()..clear());

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

  group("localStorage", (){
    var it;
    setUp(()=> it = new Store()..clear());

    test("records persist", (){
      it['foo'] = {'bar': 42};
      it.refresh();

      expect(it['foo']['bar'], equals(42));
    });
  });

  group("destructive operations", (){
    var it;
    setUp((){
      it = new Store()..clear();
      it['one'] = {'id': 1};
      it['two'] = {'id': 2};
      it['three'] = {'id': 3};
    });

    test("it can remove records by title", (){
      it.remove('two');
      expect(it['two'], isNull);
      expect(it.length, equals(2));
    });

    test("it returns null when removing a non-existent record", (){
      expect(it.remove('four'), isNull);
    });

    test("it persists removes", (){
      it.remove('two');
      it.refresh();
      expect(it['two'], isNull);
      expect(it.length, equals(2));
    });

    test("it can clear all elements", (){
      it.clear();
      expect(it['two'], isNull);
      expect(it.length, isZero);
    });

    test("clearing all elements persists", (){
      it.clear();
      it.refresh();
      expect(it['two'], isNull);
      expect(it.length, isZero);
    });

    test("it can add a new element if absent", (){
      it.putIfAbsent('four', ()=> {'id': 4});
      expect(it['four'], isNotNull);
      expect(it.length, equals(4));
    });
    test("it gets back existing elements from putIfAbsent", (){
      var existing = it.putIfAbsent('three', ()=> {'id': 42});
      expect(existing['id'], equals(3));
      expect(it['three']['id'], equals(3));
      expect(it.length, equals(3));
    });

    group("addAll", (){
      setUp(()=> it.addAll({'three': {'id': 42}, 'four': {'id': 4}}));

      test("it overwrites existing records with same key", (){
        expect(it['three']['id'], equals(42));
      });

      test("it adds new records", (){
        expect(it.length, equals(4));
        expect(it['four'], isNotNull);
      });
    });
  });
}
