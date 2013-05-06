library ice;

import 'dart:html';
import 'dart:async';
import 'package:js/js.dart' as js;

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

    this._ace.setValue(data, -1);
    this._ace.focus();
    this.updatePreview();
  }

  // worry about waitForAce?
  String get content => _ace.getValue();
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
      iframe.contentWindow.postMessage(_ace.getValue(), window.location.href);
    });
  }

  removePreview() {
    while (this._preview_el.children.length > 0) {
      this._preview_el.removeChild(this._preview_el.firstChild);
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
    editor_el.style.display = '';
    _ace.renderer.onResize();
    _ace.focus();
  }

  /// Hide the code layer
  hideCode() {
    editor_el.style.display = 'none';
    if (this.edit_only) return;

    preview_el.children[0].focus();
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

    __editor_el = new DivElement();
    __editor_el.classes.add('ice-code-editor');
    this.el.children.add(__editor_el);
    return __editor_el;
  }

  Element get _preview_el {
    if (__preview_el != null) return __preview_el;

    __preview_el = new DivElement();

    if (!this.edit_only) {
      this.el.children.add(__preview_el);
    }

    return __preview_el;
  }

  _startAce() {
    var script = new ScriptElement();
    script.src = "packages/ice_code_editor/js/ace/ace.js";
    document.head.nodes.add(script);

    this._waitForAce = new Completer();
    script.onLoad.listen((event) {
      _ace = js.context.ace.edit(_editor_el);
      js.retain(_ace);

      _ace
        ..setFontSize('18px')
        ..setPrintMarginColumn(false)
        ..setDisplayIndentGuides(false);

      _ace.getSession()
        ..setUseWrapMode(true)
        ..setUseSoftTabs(true)
        ..setTabSize(2);

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
      ..margin = '0'
      ..position = 'absolute'
      ..top = '0'
      ..bottom = '0'
      ..left = '0'
      ..right = '0'
      ..zIndex = '20'
      ..backgroundColor = 'rgba(255,255,255,0.0)';

    this._preview_el.style
      ..margin = '0'
      ..position = 'absolute'
      ..top = '0'
      ..bottom = '0'
      ..left = '0'
      ..right = '0'
      ..zIndex = '10';
  }
}
