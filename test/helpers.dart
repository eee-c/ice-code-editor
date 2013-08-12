library ice_test_helpers;

import 'dart:html';
import 'package:unittest/matcher.dart';

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

queryWithContent(selector, text) {
  var re = new RegExp(r"^\s*" + text + r"\s*$");

  return queryAll(selector).
    firstWhere((e)=> re.hasMatch(e.text));
}

typeIn(String text) {
  document.activeElement.value = text;

  document.activeElement.dispatchEvent(
    new KeyboardEvent('keyup')
  );

}

hitEnter()=> type(KeyName.ENTER);
hitEscape()=> type(KeyName.ESC);

arrowDown([times=1]) {
  new Iterable.generate(times, (i) {
    type(KeyName.DOWN);
  }).toList();
}

arrowUp([times=1]) {
  new Iterable.generate(times, (i) {
    type(KeyName.UP);
  }).toList();
}

type(String key) {
  document.activeElement.dispatchEvent(
    new KeyboardEvent(
      'keyup',
      keyIdentifier: key
    )
  );
}

typeCtrl(char) {
  document.activeElement.dispatchEvent(
    new KeyboardEvent(
      'keydown',
      keyIdentifier: keyIdentifierFor(char),
      ctrlKey: true
    )
  );
}

typeCtrlShift(char) {
  document.activeElement.dispatchEvent(
    new KeyboardEvent(
      'keydown',
      keyIdentifier: keyIdentifierFor(char),
      ctrlKey: true,
      shiftKey: true
    )
  );
}

String keyIdentifierFor(char) {
  if (char.codeUnits.length != 1) fail("Don't know how to type “$char”");

  // Keys are uppercase (see Event.keyCode)
  var key = char.toUpperCase();

  return 'U+00' + key.codeUnits.first.toRadixString(16).toUpperCase();
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
