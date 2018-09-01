part of ice;

class ExportDialog extends Dialog implements MenuAction {

  ExportDialog(Full f): super(f);

  get name => "Export All Projects";

  open()=> el.click();

  get el {
    var blob = new Blob([JSON.encode(store.projects)], "text/plain");
    var object_url = Url.createObjectUrl(blob);

    return new AnchorElement(href: object_url)
      ..download = 'Export';
  }
}
