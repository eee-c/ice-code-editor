part of ice_test;

notification_tests(){
  group("Notification System", (){
    tearDown((){ queryAll('#alert').forEach((e)=> e.remove());});

    test("can create alerts", (){
      Notify.alert('Something went wrong');

      expect(
        query('#alert').text,
        equals('Something went wrong')
      );
    });
  });
}
