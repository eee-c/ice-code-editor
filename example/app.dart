import 'dart:io';
import 'dart:json' as JSON;

main() {
  var port = Platform.environment['PORT'] == null ?
    8000 : int.parse(Platform.environment['PORT']);

  HttpServer.bind('127.0.0.1', port).then((app) {

    app.listen((HttpRequest req) {
      if (Public.matcher(req)) {
        return Public.handler(req);
      }

    });

    print('Server started on port: ${port}');
  });
}

class Public {
  static matcher(req) {
    if (req.method != 'GET') return false;

    String path = publicPath(req.uri.path);
    if (path == null) return false;

    req.session['path'] = path;
    return true;
  }

  static handler(req) {
    var file = new File(req.session['path']);
    var stream = file.openRead();
      stream.pipe(req.response);
  }

  static String publicPath(String path) {
    if (pathExists("public$path")) return "public$path";
    if (pathExists("public$path/index.html")) return "public$path/index.html";
  }

  static bool pathExists(String path) => new File(path).existsSync();
}
