part of ice;

class Gzip {
  static String encode(String string) {
    var gzip = js.context.RawDeflate.deflate(string);
    return CryptoUtils.bytesToBase64(gzip.codeUnits);
  }

  static String decode(String string) {
    var bytes = CryptoUtils.base64StringToBytes(string);
    var gzip = new String.fromCharCodes(bytes);
    return js.context.RawDeflate.inflate(gzip);
  }
}
