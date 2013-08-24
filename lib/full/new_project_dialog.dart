part of ice;

class NewProjectDialog extends Dialog implements MenuAction {
  Full full;
  NewProjectDialog(Full f): super(f) {
    full = f;
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
            ${_templates.map((t)=> '<option>$t</option>').join()}
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

  get _templates {
    if (full.templates != null){
      return full.templates.keys;
    }
    return Templates.list;
  }

  _templateForTitle(title){
    if (full.templates != null){
      return full.templates[title];
    }
    return Templates.byTitle(title);
  }

  _create() {
    var title = _field.value;
    if (!new Validate(title, store, parent).isValid) return;

    var template = _list.value,
        code = _templateForTitle(template);

    store[title] = {'code': code};
    ice.content = code;
    _hideDialog();
  }

  InputElement get _field => query('.ice-dialog').query('input');
  SelectElement get _list => query('.ice-dialog').query('select');
}
