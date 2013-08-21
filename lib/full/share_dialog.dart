part of ice;

class ShareDialog extends Dialog implements MenuAction {
  Full full;
  ShareDialog(Full f): super(f) {
    full = f;
  }

  get name => 'Share';

  open() {
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
          href="${short_url}">
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
      ..onChange.listen((e)=> _toggleGameMode(e.target.checked))
      ..onChange.listen((e)=> _updateShortUrl(e.target.checked));
  }

  String get short_url => 'http://is.gd/create.php?url=${encoded_url}';

  String get encoded_url => Uri.encodeComponent(content_for_sharing);

  String get content_for_sharing {
    var query_string = game_mode ? '?g' : '';

    return "http://gamingjs.com/ice/${query_string}#B/${full.encodedContent}";
  }

  InputElement get _field => query('.ice-dialog').query('input');
  InputElement get _checkbox => query('.ice-dialog input[type=checkbox]');
  AnchorElement get _share_link => query('.ice-dialog a');

  bool get game_mode {
    if (_checkbox == null) return false;
    return _checkbox.checked;
  }

  _toggleGameMode(bool enabled) {
    _field.value = enabled ?
      _field.value.replaceFirst('ice/#B', 'ice/?g#B') :
      _field.value.replaceFirst('?g', '');
  }

  _updateShortUrl(bool enabled) {
    _share_link.href = short_url;
  }
}
