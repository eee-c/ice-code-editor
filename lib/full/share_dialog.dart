part of ice;

class ShareDialog {
  String name = 'Share';
  var parent, ice, store, full;

  ShareDialog(Full full): this.fromParts(full.el, full.ice, full.store, full);
  ShareDialog.fromParts(this.parent, this.ice, this.store, this.full);

  open() {
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
