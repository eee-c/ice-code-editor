library ice_test_helpers;

import 'dart:html';

void click(String selector, {text}) {
  if (text == null) return query(selector).click();

  queryAll(selector).
    firstWhere((e)=> e.text==text).
    click();
}

// class NotContainMatchigstngElement extends BaseMatcher {
//   description()=> new "Does not contain"
// }
