part of ice;

class NewProjectDialog extends Dialog implements MenuAction {
  Full full;
  Templates templates;

  NewProjectDialog(Full f): super(f) {
    full = f;
    templates = new Templates(full.templates);
  }

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
            ${_template_options}
          </select>
        </label>
      </div>
      </div>
      '''
    );

    dialog.query('button')
      ..onClick.listen((e)=> _create());

    Keys.onEnter(dialog.query('input'), _create);

    parent.children.add(dialog);
    dialog.query('input').focus();
  }

  get _template_options {
    return templates.titles.map((t)=> '<option>$t</option>').join();
  }

  _create() {
    var title = _field.value;
    if (!new Validate(title, store, parent).isValid) return;

    var template_title = _list.value,
        code = templates[template_title];

    store[title] = {'code': code};
    ice.content = code;
    _hideDialog();
  }

  InputElement get _field => query('.ice-dialog').query('input');
  SelectElement get _list => query('.ice-dialog').query('select');
}
