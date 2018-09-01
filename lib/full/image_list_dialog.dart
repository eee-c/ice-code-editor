part of ice;

class ImageListDialog extends Dialog implements MenuAction {
  Full full;
  ImageListDialog(Full f): super(f) {
    full = f;
  }

  get name => "List Uploaded Images";

  Element menu;

  open() {
    menu = new Element.html(
      '''
      <div class=ice-menu>
      <h2>3DE Images</h2>
      <p class="instructions">You can use the following<br> images in your code:</p>
      <ul></ul>
      </div>
      '''
    );

    parent.append(menu);
    addImagesToMenu();

    menu.style
      ..maxHeight = '560px'
      ..overflowY = 'auto';
  }

  addImagesToMenu({filter:''}) {
    var menu = query('.ice-menu');

    var uploadedImages = JSON.decode(window.localStorage['uploaded_images']);
    var images = uploadedImages.keys.map((image){
        return new Element.html('<li>/3de/${image}</li>');
      });

    menu.query('ul').children.addAll(images);
  }

}