part of ice;

class NewProjectDialog {
  String name = 'New';
  var parent, ice, store;

  NewProjectDialog(Full full): this.fromParts(full.el, full.ice, full.store);
  NewProjectDialog.fromParts(this.parent, this.ice, this.store);

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

    dialog.query('input')
      ..onKeyUp.listen((e){if (_isEnterKey(e)) _create();});

    parent.children.add(dialog);
    dialog.query('input').focus();
  }

  _create() {
    var title = _field.value;
    if (store.containsKey(title)) {
      var message = "There is already a project with that name";
      Notify.alert(message, parent: parent, test_mode: !ice.enable_javascript_mode);
      return;
    }

    var template = _list.value,
        code = Templates.byTitle(template);

    store[title] = {'code': code};
    ice.content = code;
    _hideDialog();
  }

  InputElement get _field => query('.ice-dialog').query('input');
  SelectElement get _list => query('.ice-dialog').query('select');
}
