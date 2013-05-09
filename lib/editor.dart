library ice;

import 'dart:html';
import 'dart:async';
import 'package:js/js.dart' as js;
import 'package:js/js_wrapping.dart' as jsw;

class Editor {
  bool edit_only, autoupdate;
  String title;

  var _el;
  Element __el, __editor_el, __preview_el;

  var _ace;
  Completer _waitForAce, _waitForPreview;

  Editor(this._el, {this.edit_only:false, this.autoupdate:true, this.title}) {
    this._startAce();
    this._applyStyles();
  }

  // worry about waitForAce?
  set content(String data) {
    if (!_waitForAce.isCompleted) {
      editorReady.then((_) => this.content = data);
      return;
    }

    this._ace.value = data;
    this._ace.focus();
    this.updatePreview();
    _ace.session.onChange.listen((e)=> this.resetUpdateTimer());
  }

  Timer _update_timer;
  void resetUpdateTimer() {
    if (_update_timer != null) _update_timer.cancel();

    var wait = new Duration(seconds: 2);
    _update_timer = new Timer(wait, ()=> this.updatePreview());
  }

  // worry about waitForAce?
  String get content => _ace.value;
  Future get editorReady => _waitForAce.future;


  /// Update the preview layer with the current contents of the editor
  /// layer.
  // worry about waitForAce?
  updatePreview() {
    if (this.edit_only) return;

    this.removePreview();
    var iframe = this.createPreviewIframe();

    var wait = new Duration(milliseconds: 900);
    new Timer(wait, (){
      iframe.contentWindow.postMessage(_ace.value, window.location.href);
    });
  }

  removePreview() {
    while (this._preview_el.children.length > 0) {
      	  this._preview_el.children.first.remove();
    }
  }

  createPreviewIframe() {
    var iframe = new IFrameElement();
    iframe
      ..width = "${this._preview_el.clientWidth}"
      ..height = "${this._preview_el.clientHeight}"
      ..style.border = '0'
      ..src = 'packages/ice_code_editor/html/preview_frame.html';

    this._preview_el.children.add( iframe );

    return iframe;
  }


  /// Show the code layer, calling the ACE resize methods to ensure that
  /// the display is correct.
  // worry about waitForAce?
  showCode() {
    _editor_el.style.display = '';
    _ace.renderer.onResize();
    _ace.focus();
  }

  /// Hide the code layer
  hideCode() {
    _editor_el.style.display = 'none';
    if (this.edit_only) return;

    _preview_el.children[0].focus();
  }

  Element get el {
    if (__el != null) return __el;

    if (this._el.runtimeType == Element) {
      __el = _el;
    }
    else {
      __el = document.query(_el);
    }
    return __el;
  }

  Element get _editor_el {
    if (__editor_el != null) return __editor_el;

    __editor_el = new DivElement()
      ..classes.add('ice-code-editor-editor');
    this.el.children.add(__editor_el);
    return __editor_el;
  }

  Element get _preview_el {
    if (__preview_el != null) return __preview_el;

    __preview_el = new DivElement()
      ..classes.add('ice-code-editor-preview');

    if (!this.edit_only) {
      this.el.children.add(__preview_el);
    }

    return __preview_el;
  }

  _startAce() {
    var scripts = [
      "packages/ice_code_editor/js/deflate/rawdeflate.js",
      "packages/ice_code_editor/js/deflate/rawinflate.js",
      "packages/ice_code_editor/js/ace/ace.js"
    ];

    var script;
    scripts.forEach((src) {
      script = new ScriptElement()
        ..src = src;
      document.head.nodes.add(script);
    });

    // TODO: ask why onKeyDown does not work for arrow keys
    document.onKeyUp.listen((e) {
      if (_update_timer != null) resetUpdateTimer();
    });

    this._waitForAce = new Completer();
    script.onLoad.listen((event) {
      js.context.ace.config.set("workerPath", "packages/ice_code_editor/js/ace");

      _ace = Ace.edit(_editor_el);
      js.retain(_ace);

      _ace
        ..theme = "ace/theme/chrome"
        ..fontSize = '18px'
        ..printMarginColumn = false
        ..displayIndentGuides = false;

      _ace.session
        ..mode = "ace/mode/javascript"
        ..useWrapMode = true
        ..useSoftTabs = true
        ..tabSize = 2;

      _waitForAce.complete();
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

    this._editor_el.style
      ..position = 'absolute'
      ..zIndex = '20';

    this._preview_el.style
      ..position = 'absolute'
      ..zIndex = '10';
  }
}

class Ace extends jsw.TypedProxy {
  static Ace edit(dynamic el) => Ace.cast(js.context['ace'].edit(el));

  static Ace cast(js.Proxy proxy) =>
    proxy == null ? null : new Ace.fromProxy(proxy);

  Ace.fromProxy(js.Proxy proxy) : super.fromProxy(proxy);

  set fontSize(String size) => $unsafe.setFontSize(size);
  set theme(String theme) => $unsafe.setTheme(theme);
  set printMarginColumn(bool b) => $unsafe.setPrintMarginColumn(b);
  set displayIndentGuides(bool b) => $unsafe.setDisplayIndentGuides(b);

  set value(String content) => $unsafe.setValue(content, -1);
  String get value => $unsafe.getValue();
  void focus() => $unsafe.focus();

  AceSession get session => AceSession.cast($unsafe.getSession());
}

class AceSession extends jsw.TypedProxy {
  static AceSession cast(js.Proxy proxy) =>
    proxy == null ? null : new AceSession.fromProxy(proxy);
  AceSession.fromProxy(js.Proxy proxy) : super.fromProxy(proxy);

  set mode(String m) => $unsafe.setMode(m);
  set useWrapMode(bool b) => $unsafe.setUseWrapMode(b);
  set useSoftTabs(bool b) => $unsafe.setUseSoftTabs(b);
  set tabSize(int size) => $unsafe.setTabSize(size);

  StreamController _onChange;
  get onChange {
    if (_onChange != null) return _onChange.stream;

    _onChange = new StreamController();
    $unsafe.on('change', new js.Callback.many((e,a){
      _onChange.add(e);
    }));
    return _onChange.stream;
  }
}
