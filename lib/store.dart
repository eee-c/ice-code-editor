library ice;

import 'dart:crypto';
import 'package:js/js.dart' as js;

class Store {
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
