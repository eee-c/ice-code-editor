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

  get _copiedProjectName {
    if (store.isEmpty) return "Untitled";

    RegExp exp = new RegExp(r"\s+\((\d+)\)$");
    var title = store.projects.first['title'].replaceFirst(exp, "");

    var same_base = store.values.where((p) {
      return new RegExp("^" + title + r"(?:\s+\(\d+\))?$").hasMatch(p['title']);
    });
    var copy_numbers = same_base.map((p) {
        var stringCount = exp.firstMatch(p['title']);
        return stringCount == null ? 0 : int.parse(stringCount[1]);
      })
      .toList()
      ..sort();

    var count = copy_numbers.last;

    return "$title (${count+1})";
  }

  _copyProject() {
    var title = query('.ice-dialog').query('input').value;

    store[title] = {'code': ice.content};

    query('.ice-dialog').remove();
  }
}
