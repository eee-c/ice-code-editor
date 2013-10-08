part of ice;

class Editor {
  bool autoupdate = true;
  bool _edit_only = false;

  var _el;
  Element __el, _editor_el, _preview_el;

  var _ace;
  Completer _waitForAce, _waitForPreview;

  static bool disableJavaScriptWorker = false;

  Editor(this._el, {preview_el}) {
    if (preview_el != null) {
      this._preview_el = preview_el
        ..classes.add('ice-code-editor-preview');
    }
    this._startAce();
    this._applyStyles();
  }

  set content(String data) {
    if (!_waitForAce.isCompleted) {
      editorReady.then((_) => this.content = data);
      return;
    }

    var original_autoupdate = autoupdate;
    autoupdate = false;
    _ace.value = data;
    _ace.focus();
    updatePreview();

    var subscribe;
    subscribe = onPreviewChange.listen((_) {
      this.autoupdate = original_autoupdate;
      subscribe.cancel();
    });
  }

  Timer _update_timer;
  void delayedUpdatePreview() {
    if (!this.autoupdate) return;
    if (_update_timer != null) _update_timer.cancel();

    var wait = new Duration(seconds: 2);
    _update_timer = new Timer(wait, (){
      this.updatePreview();
      _update_timer = null;
    });
  }

  void _extendDelayedUpdatePreview() {
    if (_update_timer == null) return;
    delayedUpdatePreview();
  }

  bool get edit_only => _edit_only;
  void set edit_only(v) {
    _edit_only = v;
    if (v) removePreview();
  }

  // worry about waitForAce?
  String get content => _ace.value;
  Future get editorReady => _waitForAce.future;

  int get lineNumber => _ace.lineNumber;
  set lineNumber(int v) { _ace.lineNumber = v; }
  String get lineContent => _ace.lineContent;

  /// Update the preview layer with the current contents of the editor
  /// layer.
  updatePreview() {
    if (this.edit_only) return;

    this.removePreview();

    var iframe = this.createPreviewIframe();
    iframe.onLoad.first.then((_) {
      if (iframe.contentWindow == null) return;

      iframe
        ..height = "${this.preview_el.clientHeight}";

      var url = new RegExp(r'^file://').hasMatch(window.location.href)
        ? '*': window.location.href;
      iframe.contentWindow.postMessage(_ace.value, url);

      _previewChangeController.add(true);
    });
  }

  removePreview() {
    while (this.preview_el.children.length > 0) {
      this.preview_el.children.first.remove();
    }
  }

  createPreviewIframe() {
    var iframe = new IFrameElement();
    iframe
      ..width = "${this.preview_el.clientWidth}"
      ..height = "${this.preview_el.clientHeight}"
      ..style.border = '0'
      ..src = 'packages/ice_code_editor/html/preview_frame.html';

    this.preview_el.children.add( iframe );

    return iframe;
  }

  Stream get onChange => _ace.session.onChange;
  Stream get onPreviewChange =>
    _previewChangeController.stream.asBroadcastStream();

  StreamController __previewChangeController;
  StreamController get _previewChangeController {
    if (__previewChangeController != null) return  __previewChangeController;
    return __previewChangeController = new StreamController.broadcast();
  }

  /// Show the code layer, calling the ACE resize methods to ensure that
  /// the display is correct.
  // worry about waitForAce?
  showCode() {
    editor_el.style.visibility = 'visible';
    querySelectorAll('.ace_print-margin').forEach((e) { e.style.visibility = 'visible'; });

    _ace.resize();
    focus();
  }

  /// Hide the code layer
  hideCode() {
    editor_el.style.visibility = 'hidden';
    querySelector('.ace_print-margin').style.visibility = 'hidden';

    if (this.edit_only) return;
    focus();
  }

  focus() {
    if (isCodeVisible) {
      _ace.focus();
    }
    else {
      preview_el.children[0].focus();
    }
  }

  bool get isCodeVisible=> editor_el.style.visibility != 'hidden';

  Element get el {
    if (__el != null) return __el;

    if (this._el.runtimeType.toString().contains('Element')) {
      __el = _el;
    }
    else {
      __el = document.querySelector(_el);
    }
    return __el;
  }

  Element get editor_el {
    if (_editor_el != null) return _editor_el;

    _editor_el = new DivElement()
      ..classes.add('ice-code-editor-editor');
    this.el.children.add(_editor_el);
    return _editor_el;
  }

  Element get preview_el {
    if (_preview_el != null) return _preview_el;

    _preview_el = new DivElement()
      ..classes.add('ice-code-editor-preview');

    if (!this.edit_only) {
      this.el.children.add(_preview_el);
    }

    return _preview_el;
  }

  static List _scripts;
  static bool get _isAceJsAttached => (_scripts != null);
  static _attachScripts() {
    if (_scripts != null) return [];

    var script_paths = [
      "packages/ice_code_editor/js/ace/ace.js",
      "packages/ice_code_editor/js/ace/keybinding-emacs.js",
      "packages/ice_code_editor/js/deflate/rawdeflate.js",
      "packages/ice_code_editor/js/deflate/rawinflate.js"
    ];

    var scripts = script_paths.
      map((path) {
        var script = new ScriptElement()
          ..async = false
          ..src = path;
        document.head.nodes.add(script);
        return script;
      }).
      toList();

    return _scripts = scripts;
  }

  static Completer _waitForJS;
  static Future get jsReady {
    if (!_isAceJsAttached) {
      _waitForJS = new Completer();
      _attachScripts().
        first.
        onLoad.
        listen((_)=> _waitForJS.complete());
    }

    print('_waitForJS: ${_waitForJS.isCompleted}');
    return _waitForJS.future;
  }

  _startAce() {
    this._waitForAce = new Completer();
    jsReady.then((_)=> _startJsAce());
    _attachKeyHandlersForAce();
  }

  _startJsAce() {
    js.context.ace.config.set("workerPath", "packages/ice_code_editor/js/ace");

    _ace = Ace.edit(editor_el);

    _ace
      ..theme = "ace/theme/chrome"
      ..fontSize = '18px'
      ..printMarginColumn = false
      ..displayIndentGuides = false;

    if (!disableJavaScriptWorker) {
      _ace.session
        ..mode = "ace/mode/javascript"
        ..useWrapMode = true
        ..useSoftTabs = true
        ..tabSize = 2;
    }

    _ace.session.onChange.listen((e)=> this.delayedUpdatePreview());

    _waitForAce.complete();
  }

  _attachKeyHandlersForAce() {
    // Using keyup b/c ACE swallows keydown events
    document.onKeyUp.listen((e) {
      // only handling arrow keys
      if (e.keyCode < 37) return;
      if (e.keyCode > 40) return;
      _extendDelayedUpdatePreview();
    });

    document.onKeyPress.listen((event) {
      if (event.keyCode == 9829) {
        event.preventDefault();
        _ace.toggleEmacs();
      }
    });
  }

  _applyStyles() {
    var style = new LinkElement()
      ..type = "text/css"
      ..rel = "stylesheet"
      ..href = "packages/ice_code_editor/css/ice.css";
    document.head.nodes.add(style);

    this.el.style
      ..position = 'relative';

    this.editor_el.style
      ..position = 'absolute'
      ..zIndex = '20';

    var offset = this.el.documentOffset;
    this.preview_el.style
      ..position = 'absolute'
      ..width = this.el.style.width
      ..height = this.el.style.height
      ..top = '${offset.y}'
      ..left = '${offset.x}'
      ..zIndex = '10';
  }
}

class Ace {
  static Ace edit(Element el) =>
    new Ace(js.context['ace'].callMethod('edit', [el]));

  var jsAce;

  Ace(this.jsAce) {
    js.context['ace']['config'].
      callMethod('set', ["workerPath", "packages/ice_code_editor/js/ace"]);
  }

  set fontSize(String size) =>
    jsAce.callMethod('setFontSize', [size]);
  set theme(String theme) =>
    jsAce.callMethod('setTheme', [theme]);
  set printMarginColumn(bool b) =>
    jsAce.callMethod('setPrintMarginColumn', [b]);
  set displayIndentGuides(bool b) =>
    jsAce.callMethod('setDisplayIndentGuides', [b]);

  String get value => jsAce.callMethod('getValue');
  set value(String content) =>
    jsAce.callMethod('setValue', [content, -1]);

  void focus() => jsAce.callMethod('focus');

  // This is way crazy, but... getLine() and getCursorPosition() are zero
  // indexed while gotoLine() and scrollToLine() are 1 indexed o_O
  String get lineContent => session.getLine(lineNumber - 1);

  int get lineNumber => jsAce.callMethod('getCursorPosition')['row'] + 1;

  set lineNumber(int row) {
    jsAce.callMethod('gotoLine', [row, 0, false]);
    jsAce.callMethod('scrollToLine', [row-1, false, false]);
  }

  get renderer => jsAce['renderer'];

  void resize() => renderer.callMethod('onResize');

  var _session;
  AceSession get session {
    if (_session != null) return _session;
    return _session = new AceSession(jsAce.callMethod('getSession'));
  }

  void toggleEmacs() {
    if (jsAce.callMethod('getKeyboardHandler') == commandManager) {
      jsAce.callMethod('setKeyboardHandler', [emacsManager]);
    }
    else {
      jsAce.callMethod('setKeyboardHandler', [commandManager]);
    }
  }

  var _commandManager;
  get commandManager {
    if (_commandManager != null) return _commandManager;
    _commandManager = jsAce.callMethod('getKeyboardHandler');
    return _commandManager;
  }

  var _emacsManager;
  get emacsManager {
    if (_emacsManager != null) return _emacsManager;
    _emacsManager = js.context['ace'].callMethod('require', ["ace/keyboard/emacs"])['handler'];
    return _emacsManager;
  }
}

class AceSession {
  var jsSession;
  AceSession(this.jsSession);

  set mode(String m) => jsSession.callMethod('setMode', [m]);
  set useWrapMode(bool b) {
    jsSession.callMethod('setUseWrapMode', [b]);
  }
  set useSoftTabs(bool b) => jsSession.callMethod('setUseSoftTabs', [b]);
  set tabSize(int size) => jsSession.callMethod('setTabSize', [size]);

  String getLine(int row) => jsSession.callMethod('getLine', [row]);

  StreamController _onChange;
  get onChange {
    if (_onChange != null) return _onChange.stream;

    _onChange = new StreamController.broadcast();

    jsSession.callMethod('on', [
      'change',
      (e,a){ _onChange.add(e); }
    ]);

    return _onChange.stream;
  }
}
