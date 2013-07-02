part of ice;

class Validate {
  String title;

  Element parent;
  Editor ice;
  Store store;

  // TODO: generalize so that these are not passed directly to Validate
  Validate(this.title, this.store, this.parent);

  bool get isValid {
    if (store.containsKey(title)) {
      var message = "There is already a project with that name";
      Notify.alert(message, parent: parent);
      return false;
    }

    if (title.trim().isEmpty) {
      var message = "The project name cannot be blank";
      Notify.alert(message, parent: parent);
      return false;
    }

    return true;
  }
}
