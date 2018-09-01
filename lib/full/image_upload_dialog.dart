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
            String json = window.localStorage.putIfAbsent('uploaded_images', ()=>'{}');
            Map images = JSON.decode(json);
            images[filename] = reader.result;
            window.localStorage['uploaded_images'] = JSON.encode(images);
          });
          reader.readAsDataUrl(files[0]);
        });
}
