part of ice;

class ImportDialog extends Dialog implements MenuAction {
  Full full;
  ImportDialog(Full f): super(f) {
    full = f;
  }

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
    try {
      full._importFromJson(json);
    } on FormatException {
      var message = "This does not look like a ICE project file. Unable to import.";
      Notify.alert(message, parent: parent);
    }
  }
}
