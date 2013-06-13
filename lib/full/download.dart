part of ice;

class DownloadDialog {
  var parent, ice, store;

  DownloadDialog(Full full): this.fromParts(full.el, full.ice, full.store);
  DownloadDialog.fromParts(this.parent, this.ice, this.store);

  Element get el {
  	var blob = new Blob([ice.content], "text/plain");
    var object_url = Url.createObjectUrl(blob);

    return new Element.html('<li><a>Download</a></li>')
    	..query('a').download = store.currentProjectTitle
    	..query('a').href = object_url
    	..query('a').onClick.listen((e)=> _hideMenu());
  }
}