part of ice;

class ShareDialog {
  Full full;
  Store store;
  Editor ice;
  Element parent;

  ShareDialog(Full this.full) {
    store = full.store;
    ice = full.ice;
    parent = full.el;
  }

  Element get el {
    return new Element.html('<li>Share</li>')
      ..onClick.listen((e)=> _hideMenu())
      ..onClick.listen((e)=> _openDialog());
  }

  _openDialog() {
    var dialog = new Element.html(
      '''
      <div class=ice-dialog>
      <h1>Copy this link to share your creation:</h1>
      <input
        value="http://gamingjs.com/ice/#B/${full.encodedContent}"
        style="width=400px; padding=5px; border=0px">
      </div>
      '''
    );

    parent.children.add(dialog);

    dialog.query('input')
      ..focus()
      ..select()
      ..disabled = true
      ..style.width = '100%';
  }
}
