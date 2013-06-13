part of ice;

class DownloadDialog {
  var parent, ice, store;

  DownloadDialog(Full full): this.fromParts(full.el, full.ice, full.store);
  DownloadDialog.fromParts(this.parent, this.ice, this.store);

  Element get el {
    return new LIElement()
    ..children.add(_downloadLink);
  }

  AnchorElement get _downloadLink {
  	var blob = new Blob([ice.content], "text/plain");
    var object_url = Url.createObjectUrl(blob);

    return new AnchorElement(href: object_url)
      ..download = store.currentProjectTitle
      ..onClick.listen((e)=> _hideMenu())
      ..text = 'Download';
  }
}
