part of ice_tests;

store_tests() {
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

    test("records cease to persist if the store is frozen", (){
      it['foo'] = {'bar': 42};
      it.freeze();

      it['foo'] = {'bar': 43};
      it.refresh();

      expect(it['foo']['bar'], equals(42));
    });
  });

  group("Multiple Stores", (){
    test("can be created with optional named construtor params", (){
      var store1 = new Store(storage_key: 'test1')
            ..['one'] = {'id': 'foo'}
            ..refresh();

      var store2 = new Store(storage_key: 'test2')
            ..['one'] = {'id': 'bar'}
            ..refresh();

      expect(store1['one']['id'], 'foo');
      expect(store2['one']['id'], 'bar');

      store1.clear();
      store2.clear();
    });
  });

  group("current project title", (){
    test("is \"Untitled\" when there are no projects", (){
      var it = new Store()..clear();
      expect(
        it.currentProjectTitle,
        equals('Untitled')
      );
    });
    test("is the title of the first project when there are projects", (){
      var it = new Store()..clear();
      it['one'] = {'id': 1};
      it['two'] = {'id': 2};
      expect(
        it.currentProjectTitle,
        equals('two')
      );
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

    test("persist removes", (){
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

    test("clearing deletes the storage_key from localStorage", (){
      it.clear();
      expect(window.localStorage[Store.codeEditor], isNull);
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

  group("onSync", (){
    tearDown(()=> new Store()..clear());

    test("it generates a stream action when a sync operation occurs", (){
      var store = new Store()..clear();

      _test(_)=> expect(store, isNot(isEmpty));

      // Once for clear, once for new Test Project
      store.onSync.listen(expectAsync(_test, count: 2));

      store['Test Project'] = {'code': 'Test Code'};
    });
  });

  group("Next Project Named", (){
    var it;
    setUp((){
      it = new Store()..clear();
      it['one'] = {'code': 1};
      it['two'] = {'code': 2};
    });

    tearDown(()=> new Store()..clear());

    test("does not have trailing parens if name unique", (){
      expect(
        it.nextProjectNamed('Untitled'),
        equals('Untitled')
      );
    });

    test("does have trailing parens if name is not unique", (){
      expect(
        it.nextProjectNamed('one'),
        equals('one (1)')
      );
    });

    test("defaults to current project with parens", (){
      expect(
        it.nextProjectNamed(),
        equals('two (1)')
      );
    });
  });

  solo_group("Store", (){
    var it;
    setUp((){
      it = new Store()
        ..clear()
        ..['one'] = {'code': 1}
        ..['two'] = {'code': 2};
    });

    tearDown(()=> new Store()..clear());

    test("automatically includes creation date", (){
      expect(
        DateTime.parse(it.currentProject['created_at']).millisecondsSinceEpoch,
        closeTo(new DateTime.now().millisecondsSinceEpoch, 100)
      );
    });

    test("creation date does not change on update", (){
      var original = it.currentProject['created_at'];

      Timer.run(expectAsync((){
        it['two'] = {'code': 3};
        expect(
          it.currentProject['created_at'],
          original
        );
      }));
    });

    test("automatically includes update date", (){
      expect(
        DateTime.parse(it.currentProject['updated_at']).millisecondsSinceEpoch,
        closeTo(new DateTime.now().millisecondsSinceEpoch, 100)
      );
    });

    test("update date changes… on update", (){
      var original = it.currentProject['updated_at'];

      Timer.run(expectAsync((){
        it['two'] = {'code': 3};
        expect(
          it.currentProject['updated_at'],
          isNot(original)
        );
      }));
    });

    test("initial order is insertion order", (){
      var titles = it.projects.map((p) => p[Store.title]);
      expect(titles, ['two', 'one']);
    });

    test("order persists after save / reload", (){
      it.refresh();
      var titles = it.projects.map((p) => p[Store.title]);
      expect(titles, ['two', 'one']);
    });

    test("updating a record moves it to the top of the list", (){
      it['one'] = {'code': 'updated code'};

      var titles = it.projects.map((p) => p[Store.title]);
      expect(titles, equals(['one', 'two']));
    });
  });

  solo_group("Snapshots", (){
    var it;
    setUp((){
      it = new Store()
        ..clear()
        ..['one'] = {'code': 1}
        ..['two'] = {'code': 2, 'snapshot': true}
        ..['three'] = {'code': 3};
    });

    tearDown(()=> new Store()..clear());

    test('project list does not inlcude snapshots by default', (){
      expect(it.length, equals(2));
    });

    test("existing snapshots persist", (){
      it.refresh();

      expect(it['two']['code'], equals(2));
      expect(it['two']['snapshot'], isTrue);
    });

    test("new snapshots persist", (){
      it['foo'] = {'code': 42, 'snapshot': true};
      it.refresh();

      expect(it['foo']['code'], equals(42));
      expect(it['foo']['snapshot'], isTrue);
    });

    test("are never first on the project list", (){
      it['new snapshot'] = {'code': 4, 'snapshot': true};
      it.show_snapshots = true;

      it.refresh();

      expect(it.projects.first['snapshot'], null);
    });

    test("when they are the only projects in the list, still persist", (){
      it
        ..clear()
        ..['two'] = {'code': 2, 'snapshot': true}
        ..['four'] = {'code': 4, 'snapshot': true};

      it.refresh();

      expect(it.projects.length, 0);
    });
  });
}
