part of ice;

class ImportDialog extends Dialog implements MenuAction {

  ImportDialog(Full f): super(f);

  get name => "Import";

  open() => el.click();

  get el =>
    new FileUploadInputElement()
      ..onChange.listen((e) {
          var files = e.target.files;
          if (files.length != 1) return;

          var reader = new FileReader();
          reader.onLoad.listen((e) {
            import(reader.result.toString());
          });
          reader.readAsText(files[0]);
        });

  void import(String json) {
    var projects = JSON.decode(json);
    projects.reversed.forEach((project) {
      store[project['filename']] = project;
    });
    ice.content = projects[0]['code'];
  }
}
