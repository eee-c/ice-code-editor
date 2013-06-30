part of ice;

// TODO: convert to a singleton to decrease the arity
class Notify {
  // consider making this a full-fledged property
  static get testMode => Editor.disableJavaScriptWorker;

  static alert(message, {parent}) {
    if (parent == null) parent = document.body;

    var el = new Element.html('<div id="alert">$message</div>');
    parent.children.add(el..style.visibility="hidden");
    if (!testMode) window.alert(message);
  }

  static bool confirm(message, {parent}) {
    if (parent == null) parent = document.body;

    var el = new Element.html('<div id="confirmation">$message</div>');
    parent.children.add(el..style.visibility="hidden");
    if (!testMode) return window.confirm(message);
    return true;
  }
}
