part of ice_tests;

gzip_tests() {
  group("gzipping", () {
    test("it can encode text", (){
      expect(Gzip.encode("Howdy, Bob!"), equals("88gvT6nUUXDKT1IEAA=="));
    });

    test("it can decode as text", (){
      expect(Gzip.decode("88gvT6nUUXDKT1IEAA=="), equals("Howdy, Bob!"));
    });
  });
}
