part of ice;

class CopyDialog extends Dialog implements MenuAction {
  CopyDialog(Full f): super(f);

  get name => 'Make a Copy';

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

    KeyboardEventStreamX.onKeyUp(dialog.query('input'))
      .listen((e) { if (e.isEnter) _copyProject(); });

    parent.children.add(dialog);

    dialog.query('input')
      ..focus();
  }

  get _copiedProjectName => store.nextProjectNamed();

  _copyProject() {
    var title = _field.value;
    if (!new Validate(title, store, parent).isValid) return;

    store[title] = {'code': ice.content};

    query('.ice-dialog').remove();
  }

  InputElement get _field => query('.ice-dialog').query('input');
}
