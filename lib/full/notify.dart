part of ice;

// TODO: convert to a singleton to decrease the arity
class Notify {
  static alert(message, {parent, test_mode:false}) {
    if (parent == null) parent = document.body;

    var el = new Element.html('<div id="alert">$message</div>');
    parent.children.add(el..style.visibility="hidden");
    if (!test_mode) window.alert(message);
  }
}
