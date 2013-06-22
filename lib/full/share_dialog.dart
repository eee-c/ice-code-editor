part of ice;

class ShareDialog extends Dialog implements MenuAction {
  Full full;
  ShareDialog(Full f): super(f) {
    full = f;
  }

  get name => 'Share';

  open() {
    var content_for_sharing = "http://gamingjs.com/ice/#B/${full.encodedContent}";
    var encoded_url = Uri.encodeComponent(content_for_sharing);
    var dialog = new Element.html(
      '''
      <div class=ice-dialog>
      <h1>Copy this link to share your creation:</h1>
      <input
        value="${content_for_sharing}"
        style="width=400px; padding=5px; border=0px">
      <div>
       <label title="If this is checked, then the share link will start with the code hidden.">
         <input type=checkbox>
         start in game mode
       </label>
      </div>
      <div class='instructions'>
        <span>..or, for easier sharing</span>
        <a
          target="_blank"
          href="http://is.gd/create.php?url=${encoded_url}">
        make a short link</a>
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
