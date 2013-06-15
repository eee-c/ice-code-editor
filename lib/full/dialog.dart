part of ice;

class Dialog {
  Element parent;
  Editor ice;
  Store store;

  Dialog(Full full): this.fromParts(full.el, full.ice, full.store);
  Dialog.fromParts(this.parent, this.ice, this.store);
}
