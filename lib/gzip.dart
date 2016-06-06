part of ice;

class Gzip {
  static String encode(String string) =>
    js.context['RawDeflate'].callMethod('deflateToBase64', [string]);

  static String decode(String string) =>
    js.context['RawDeflate'].callMethod('inflateFromBase64', [string]);

  static Future get _ready {
    var completer = new Completer();

    new Timer.periodic(
      new Duration(milliseconds: 50),
      (timer) {
        if (js.context['RawDeflate'] != null) {
          timer.cancel();
          completer.complete();
        }
      });

    return completer.future;
  }
}
