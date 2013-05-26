part of ice;

class NewProjectDialog {
  Element parent;
  Store store;

  NewProjectDialog(Full full) {
    parent = full.el;
    store = full.store;
  }

  Element get el  {
    return new Element.html('<li>New</li>')
      ..onClick.listen((e)=> _hideMenu())
      ..onClick.listen((e)=> _openDialog());
  }

  _openDialog() {
    var dialog = new Element.html(
      '''
      <div class=ice-dialog>
      <label>Name:<input type="text" size="30"></label>
      <button>Save</button>
      </div>
      '''
    );

    dialog.query('button')
      ..onClick.listen((e)=> _create());

    parent.children.add(dialog);
    dialog.query('input').focus();
  }

  _create() {
    var title = query('.ice-dialog').query('input').value;
    if(sstore.containsKey(title)) {
      var message = "There is already a project with that name";
      var alert = new Element.html('<div id="alert">$message</div>');

      el.children.add(alert..style.visibility="hidden");
      if(ice.enable_javascript_mode) window.alert(message);
    }
    else {
      store[title] = {};
      _hideDialog();
    }
  }
}
