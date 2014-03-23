part of ice_test;

settings_tests() {
  group("store/retrieve", (){
      var it;
      setUp(()=> it = new Settings()..clear());

      test("it can store data", (){
        it['foo'] = 42;
        expect(it['foo'], equals(42));
      });

      test("it can store multiple records", (){
        it['one'] = 1;
        it['two'] = 2;
        it['foo'] = 42;
        expect(it['foo'], equals(42));
      });

      test("it can overwrite existing records", (){
        it['one'] = 1;
        it['two'] = 2;
        it['foo'] = 42;
        it['two'] = 7;
        expect(it['two'], equals(7));
      });

      test("it does not create new records when overwriting old ones", (){
        it['one'] = 1;
        it['two'] = 2;
        it['foo'] = 42;
        it['two'] = 7;
        expect(it.length, equals(3));
      });
    });
}