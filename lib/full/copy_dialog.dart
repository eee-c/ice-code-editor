part of ice;

class CopyDialog {
  String name = 'Make a Copy';
  var parent, ice, store;

  CopyDialog(Full full): this.fromParts(full.el, full.ice, full.store);
  CopyDialog.fromParts(this.parent, this.ice, this.store);

  open() {
    var dialog = new Element.html(
      '''
      <div class=ice-dialog>
      <label>Name:<input type="text" size="30" value="$_copiedProjectName"></label>
      <button>Save</button>
      </div>
      '''
    );

    dialog.query('button').onClick
      ..listen((_)=> _copyProject());

    parent.children.add(dialog);

    dialog.query('input')
      ..focus();
  }

  get _copiedProjectName => store.nextProjectNamed();

  _copyProject() {
    var title = _field.value;

    store[title] = {'code': ice.content};

    query('.ice-dialog').remove();
  }

  InputElement get _field => query('.ice-dialog').query('input');
}
