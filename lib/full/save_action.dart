part of ice;

class SaveAction extends Dialog implements MenuAction {
  SaveAction(Full f): super(f);

  get name => 'Save';

  void open() {
    var title = store.isEmpty ? 'Untitled' : store.currentProjectTitle;

    store[title] = {
      'code': ice.content,
      'lineNumber': ice.lineNumber
    };
  }
}
