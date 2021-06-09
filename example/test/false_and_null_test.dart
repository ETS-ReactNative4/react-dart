// @dart=2.7
// ^ Do not remove until migrated to null safety. More info at https://wiki.atl.workiva.net/pages/viewpage.action?pageId=189370832
// ignore_for_file: deprecated_member_use_from_same_package
import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;

class _Component extends react.Component {
  render() {
    if (props['hardCodedNullReturn'] == true) {
      return null;
    }

    return props['returnValue'];
  }
}

var component = react.registerComponent(() => new _Component());

void main() {
  var content = react.div({}, [
    react.p({}, 'Testing a dynamic return value of "null"...'),
    component({'returnValue': null, 'key': 0}),
    react.p({}, 'Testing a hard-coded return value of "null"...'),
    component({'hardCodedNullReturn': true, 'key': 1}),
    react.p({}, 'Testing a return value of "false"...'),
    component({'returnValue': false, 'key': 2}),
  ]);

  react_dom.render(content, querySelector('#content'));
}
