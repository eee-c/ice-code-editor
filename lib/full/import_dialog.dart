part of ice;

class ImportDialog extends Dialog implements MenuAction {

  ImportDialog(Full f): super(f);

  get name => "Import";

  open() {
    print(store);
    el.click();
  }

  get el {
    return new FileUploadInputElement()
      ..onChange.listen((e) {
          var files = e.target.files;
          if (files.length != 1) return;

          var reader = new FileReader();
          reader.onLoad.listen((e) {
            var projects = JSON.parse(reader.result.toString());
            projects.forEach((project) {
              store[project['filename']] = project;
            });
          });
          reader.readAsText(files[0]);
        });
  }
}
