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
      <div>
       <label title="If this is checked, then the share link will start with the code hidden.">
         <input type=checkbox>
         start in game mode
       </label>
      </div>
      </div>
      '''
    );

    parent.children.add(dialog);

    _field
      ..focus()
      ..select()
      ..disabled = true
      ..style.width = '100%';

    _checkbox
      ..onChange.listen((e)=> _toggleGameMode(e.target.checked));
  }

  InputElement get _field => query('.ice-dialog').query('input');
  InputElement get _checkbox => query('.ice-dialog input[type=checkbox]');

  _toggleGameMode(bool enabled) {
    _field.value = enabled ?
      _field.value.replaceFirst('ice/#B', 'ice/?g#B') :
      _field.value.replaceFirst('?g', '');
  }
}
