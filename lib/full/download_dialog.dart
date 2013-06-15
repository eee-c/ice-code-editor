part of ice;

class DownloadDialog extends Dialog implements MenuAction {
  DownloadDialog(Full f): super(f);

  get name => "Download";

  open()=> el.click();

  get el {
  	var blob = new Blob([ice.content], "text/plain");
    var object_url = Url.createObjectUrl(blob);

    return new AnchorElement(href: object_url)
      ..download = store.currentProjectTitle;
  }
}
