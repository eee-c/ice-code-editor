part of ice;

class ImageUploadDialog extends Dialog implements MenuAction {
  Full full;
  ImageUploadDialog(Full f): super(f) {
    full = f;
  }

  get name => "Upload Image";

  open() => el.click();

  get el =>
    new FileUploadInputElement()
      ..onChange.listen((e) {
          var files = e.target.files;
          if (files.length != 1) return;
          var filename = e.target.files[0].name;
          var reader = new FileReader();

          reader.onLoad.listen((e) {
            window.localStorage['uploaded_images'] = JSON.encode({
              filename: reader.result
            });
          });
          reader.readAsDataUrl(files[0]);
        });
}
