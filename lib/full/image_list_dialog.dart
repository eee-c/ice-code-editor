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
      <p class="instructions">You can use the following images in your code:</p>
      <ul></ul>
      <p class="instructions">Click an image path to copy to your clipboard.<br>Then paste it into your code.</p>
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
        return new Element.html('<li>/3de/${image} <img src="packages/ice_code_editor/images/clipboard.png" class="clipboard"/></li>')
          ..tabIndex = 0
          ..onClick.listen((e) => _copyToClipboard('/3de/${image}'))
          ..onClick.listen((e) => _hideMenu())
          ..onClick.listen((e) => _notifyClipboardReady());
      });

    menu.query('ul').children.addAll(images);
  }

  _copyToClipboard(String path) {
    var clipboard = js.context['navigator']['clipboard'];
    clipboard.callMethod('writeText', [path]);
  }

  _notifyClipboardReady() {
    Notify.info('Copied path to clipboard. Now paste it into your code!');
  }
}