library ice_test_helpers;

import 'dart:html';
import 'package:matcher/matcher.dart';
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
  var e = new KeyEvent('keydown', keyCode: KeyCode.ENTER).wrapped;

  document.
    activeElement.
    dispatchEvent(e);

  // var fake_button = document.query('#fake_enter_key');
  // if (fake_button == null) return;
  // fake_button.click();
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
