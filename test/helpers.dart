library ice_test_helpers;

import 'dart:html';
import 'package:unittest/matcher.dart';


void click(String selector, {text}) {
  if (text == null) return query(selector).click();

  queryAll(selector).
    firstWhere((e)=> e.text==text).
    click();
}

elements_contain(Pattern content) =>
  new ElementListMatcher(contains(matches(content)));

class ElementListMatcher extends CustomMatcher {
  ElementListMatcher(matcher) :
      super("List of elements", "Element list content", matcher);

  featureValueOf(elements) => elements.map((e)=> e.text).toList();
}
