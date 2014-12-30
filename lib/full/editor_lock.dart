part of ice;

class EditorLock {
  Settings settings;
  EditorLock(this.settings) {
    // Last thoughts were to add a check for existing sessions here, and, if
    // they are present, then do not create lock, do not start lock timer, but
    // set some error property that the editor class can read.

    createLock();
  }

  void createLock() {
    this.settings['lock'] = new DateTime.now().millisecondsSinceEpoch;
  }

  void updateLock() {
    this.settings['lock'] = new DateTime.now().millisecondsSinceEpoch;
  }

  static get existing => false;
}
