library ice_test_helpers;

import 'dart:html';
import 'dart:js' as js;
import 'package:unittest/matcher.dart';
import 'package:ctrl_alt_foo/keys.dart';
import 'package:ctrl_alt_foo/helpers.dart';
export 'package:ctrl_alt_foo/helpers.dart';

createProject(String title, {content, editor}) {
  click('button', text: '☰');
  click('li', text: 'New');
  typeIn(title);
  click('button', text: 'Save');

  if (content != null) {
    if (editor == null) throw new Exception("Need an editor instance");
    editor.content = content;
    click('button', text: '☰');
    click('li', text: 'Save');
  }
}

class FakeCompleter {
  then(cb) => cb();
}

click(String selector, {text}) {
  if (text == null) {
    query(selector).click();
  }
  else {
    queryWithContent(selector, text).click();
  }

  return new FakeCompleter();
}

typeIn(String text) {
  document.activeElement.value = text;

  var last_char = new String.fromCharCode(text.runes.last);
  document.activeElement.dispatchEvent(
    new KeyboardEvent(
      'keyup'
    )
  );
}

arrowDown([times=1]) {
  // var e = new KeyEvent('keydown', keyCode: KeyCode.DOWN).wrapped;
  var fake_button = document.query('#fake_down_key');
  if (fake_button == null) return;

  new Iterable.generate(times, (i) {
    // document.activeElement.dispatchEvent(e);
    fake_button.click();
  }).toList();
}

arrowUp([times=1]) {
  // var e = new KeyEvent('keydown', keyCode: KeyCode.UP).wrapped;
  var fake_button = document.query('#fake_up_key');
  if (fake_button == null) return;

  new Iterable.generate(times, (i) {
    // document.activeElement.dispatchEvent(e);
    fake_button.click();
  }).toList();
}

hitEnter() {
  var event = createJSKeyEventObject('keydown', KeyCode.ENTER);
  var activeElement = new js.JsObject.fromBrowserObject(
      document.activeElement
  );

  activeElement.callMethod('dispatchEvent', [event]);
  //document.activeElement.dispatchEvent(new KeyEvent('keyup', keyCode: 13));
}


//http://jsbin.com/awenaq/3
createJSKeyEventObject(type, keycode) {
  var jsDocument = new js.JsObject.fromBrowserObject(document);
  var event = new js.JsObject.fromBrowserObject(
    jsDocument.callMethod('createEvent', ["KeyboardEvent"])
  );

  // event.callMethod(
  //   'initKeyboardEvent', [ type, true, true, null, keycode ]);

  // TODO:
  //  1. change ctrl_alt_foo to ignore plain event
  //  2. switch this back to create plain events
  //  3. change all keyboard event code to JS hack that is currently
  //     in test/index.html


  event.callMethod(
    'initKeyboardEvent', [
    "keydown",        //  in DOMString typeArg,
    true,             //  in boolean canBubbleArg,
    true,             //  in boolean cancelableArg,
    null,             //  in nsIDOMAbstractView viewArg,  Specifiew. This vale may be null.
    false,            //  in boolean ctrlKeyArg,
    false,            //  in boolean altKeyArg,
    false,            //  in boolean shiftKeyArg,
    false,            //  in boolean metaKeyArg,
    KeyCode.ENTER,    //  in unsigned long keyCodeArg,
    0                 //  in unsigned long charCodeArg);
  ]);

  event['keyCode'] = KeyCode.ENTER;
  event['which'] = KeyCode.ENTER;

  // var e = new KeyEvent('keydown', keyCode: KeyCode.ENTER).wrapped;

  /*event.callMethod('initKeyboardEvent', [type, true, true, null,
         false, false, false, false,
             keycode, 0]);
  */
  event['keyCode'] = keycode;
  event['which'] = keycode;


  return event;
}


queryWithContent(selector, text) {
  var re = new RegExp(r"^\s*" + text + r"\s*$");

  return queryAll(selector).
    firstWhere((e)=> re.hasMatch(e.text));
}

get elementsAreEmpty =>
  new ElementListMatcher(isEmpty);

get elementsArePresent =>
  new ElementListMatcher(isNot(isEmpty));

elementsContain(Pattern content) =>
  new ElementListMatcher(contains(matches(content)));

elementsDoNotContain(Pattern content) =>
  new ElementListMatcher(isNot(contains(matches(content))));

class ElementListMatcher extends CustomMatcher {
  ElementListMatcher(matcher) :
      super("List of elements", "Element list content", matcher);

  featureValueOf(elements) => elements.map((e)=> e.text).toList();
}
