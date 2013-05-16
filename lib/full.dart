part of ice;

class Full {
  Element el;
  Editor _ice;

  Full({enable_javascript_mode: true}) {
    el = new Element.html('<div id=ice>');
    document.body.nodes.add(el);

    _fullScreenStyles();
    _ice = new Editor('#ice', enable_javascript_mode: enable_javascript_mode);
    editorReady.then((_)=> _applyStyles());
  }

  Future get editorReady => _ice.editorReady;

  _fullScreenStyles() {
    document.body.style
      ..margin = '0px'
      ..overflow = 'hidden';
  }

  _applyStyles() {

     var editor_el = el.query('.ice-code-editor-editor');

     editor_el.style
       ..top = '0'
       ..bottom = '0'
       ..left = '0'
       ..right = '0'
       ..backgroundColor = 'rgba(255,255,255,0.0)';

     el.style
       ..height = '100%'
       ..width = '100%';
  }
}
