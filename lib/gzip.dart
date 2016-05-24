part of ice;

class Gzip {
  static String encode(String string) =>
    js.context['RawDeflate'].callMethod('deflateToBase64', [string]);

  static String decode(String string) =>
    js.context['RawDeflate'].callMethod('inflateFromBase64', [string]);
}
