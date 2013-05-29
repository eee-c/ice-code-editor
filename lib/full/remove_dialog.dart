part of ice;

class RemoveDialog {
  String name = "Remove";
  var parent, ice, store;

  RemoveDialog(Full full): this.fromParts(full.el, full.ice, full.store);
  RemoveDialog.fromParts(this.parent, this.ice, this.store);

  open() {
    var title = store.currentProjectTitle;
    store.remove(title);
  }
}
