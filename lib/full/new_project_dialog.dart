part of ice;

class NewProjectDialog extends Dialog implements MenuAction {
  NewProjectDialog(Full f): super(f);

  get name => 'New';

  open() {
    var dialog = new Element.html(
      '''
      <div class=ice-dialog>
      <label>Name:<input type="text" size="30"></label>
      <button>Save</button>
      <div>
        <label>
          Template:
          <select>
            ${Templates.list.map((t)=> '<option>$t</option>').join()}
          </select>
        </label>
      </div>
      </div>
      '''
    );

    dialog.query('button')
      ..onClick.listen((e)=> _create());

    dialog.query('input').onKeyDown.
      listen((e) {
        if (e.keyCode != KeyCode.ENTER) return;
        _create();
      });

    parent.append(dialog);
    dialog.query('input').focus();
  }

  _create() {
    var title = _field.value;
    if (!new Validate(title, store, parent).isValid) return;

    var template = _list.value,
        code = Templates.byTitle(template);

    store[title] = {'code': code};
    ice.content = code;
    _hideDialog();
  }

  InputElement get _field => query('.ice-dialog').query('input');
  SelectElement get _list => query('.ice-dialog').query('select');
}
