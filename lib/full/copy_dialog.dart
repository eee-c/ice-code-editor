part of ice;

class CopyDialog {
  Full full;
  Store store;
  Editor ice;
  Element parent;

  CopyDialog(Full this.full) {
    store = full.store;
    ice = full.ice;
    parent = full.el;
  }

  Element get el {
    return new Element.html('<li>Make a Copy</li>')
      ..onClick.listen((e)=> _hideMenu())
      ..onClick.listen((e)=> _openDialog());
  }

  _openDialog() {
    var dialog = new Element.html(
      '''
      <div class=ice-dialog>
      <label>Name:<input type="text" size="30" value="$_copiedProjectName"></label>
      <button>Save</button>
      </div>
      '''
    );

    dialog.query('button')
      ..onClick.listen((_)=> _copyProject())
      ..onClick.listen((e)=> _hideDialog());

    parent.children.add(dialog);

    dialog.query('input')
      ..focus();
  }

  get _copiedProjectName {
    if (store.isEmpty) return "Untitled";

    RegExp exp = new RegExp(r"\s\((\d+)\)$");
    var stringCount = exp.firstMatch(store.projects.first['title']);
    var count = stringCount == null ? 1 : int.parse(stringCount[1]) + 1;

    var title = store.projects.first['title'].replaceFirst(exp, "");

    return "$title ($count)";
  }

  _copyProject() {
    var title = query('.ice-dialog').query('input').value;

    store[title] = {'code': ice.content};
  }
}
