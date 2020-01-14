import 'dart:html';

import 'package:react/hooks.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart';

var hookTestFunctionComponent = react.registerFunctionComponent(HookTestComponent, displayName: 'useStateTest');

HookTestComponent(Map props) {
  final count = useState(1);
  final evenOdd = useState('even');

  useEffect(() {
    if (count.value % 2 == 0) {
      print('count changed to ' + count.value.toString());
      evenOdd.set('even');
    } else {
      print('count changed to ' + count.value.toString());
      evenOdd.set('odd');
    }
    return () {
      print('count is changing... do some cleanup if you need to');
    };

    /// This dependency prevents the effect from running every time [evenOdd.value] changes.
  }, [count.value]);

  return react.div({}, [
    react.button({'onClick': (_) => count.set(1), 'key': 'ust1'}, ['Reset']),
    react.button({'onClick': (_) => count.setWithUpdater((prev) => prev + 1), 'key': 'ust2'}, ['+']),
    react.br({'key': 'ust3'}),
    react.p({'key': 'ust4'}, ['${count.value} is ${evenOdd.value}']),
  ]);
}

var useCallbackTestFunctionComponent =
    react.registerFunctionComponent(UseCallbackTestComponent, displayName: 'useCallbackTest');

UseCallbackTestComponent(Map props) {
  final count = useState(0);
  final delta = useState(1);

  var increment = useCallback((_) {
    count.setWithUpdater((prev) => prev + delta.value);
  }, [delta.value]);

  var incrementDelta = useCallback((_) {
    delta.setWithUpdater((prev) => prev + 1);
  }, []);

  return react.div({}, [
    react.div({'key': 'ucbt1'}, ['Delta is ${delta.value}']),
    react.div({'key': 'ucbt2'}, ['Count is ${count.value}']),
    react.button({'onClick': increment, 'key': 'ucbt3'}, ['Increment count']),
    react.button({'onClick': incrementDelta, 'key': 'ucbt4'}, ['Increment delta']),
  ]);
}

var useContextTestFunctionComponent =
    react.registerFunctionComponent(UseContextTestComponent, displayName: 'useContextTest');

UseContextTestComponent(Map props) {
  final context = useContext(TestNewContext);
  return react.div({
    'key': 'uct1'
  }, [
    react.div({'key': 'uct2'}, ['useContext counter value is ${context['renderCount']}']),
  ]);
}

int calculateChangedBits(currentValue, nextValue) {
  int result = 1 << 1;
  if (nextValue['renderCount'] % 2 == 0) {
    result |= 1 << 2;
  }
  return result;
}

var TestNewContext = react.createContext<Map>({'renderCount': 0}, calculateChangedBits);

var newContextProviderComponent = react.registerComponent(() => _NewContextProviderComponent());

class _NewContextProviderComponent extends react.Component2 {
  get initialState => {'renderCount': 0, 'complexMap': false};

  render() {
    final provideMap = {'renderCount': this.state['renderCount']};

    return react.div({
      'key': 'ulasda',
      'style': {
        'marginTop': 20,
      }
    }, [
      react.button({
        'type': 'button',
        'key': 'button',
        'className': 'btn btn-primary',
        'onClick': _onButtonClick,
      }, 'Redraw'),
      react.br({'key': 'break1'}),
      'TestContext.Provider props.value: ${provideMap}',
      react.br({'key': 'break2'}),
      react.br({'key': 'break3'}),
      TestNewContext.Provider(
        {'key': 'tcp', 'value': provideMap},
        props['children'],
      ),
    ]);
  }

  _onButtonClick(event) {
    this.setState({'renderCount': this.state['renderCount'] + 1, 'complexMap': false});
  }
}

var useRefTestFunctionComponent = react.registerFunctionComponent(UseRefTestComponent, displayName: 'useRefTest');

UseRefTestComponent(Map props) {
  final input = useState('');
  final inputRef = useRef();
  final prevInputRef = useRef();
  final prevInput = prevInputRef.current;

  useEffect(() {
    prevInputRef.current = input.value;
  });

  return react.Fragment({}, [
    react.p({'key': 'urtKey1'}, ['Current Input: ${input.value}, Previous Input: ${prevInput}']),
    react.input({'key': 'urtKey2', 'ref': inputRef}),
    react.button({'key': 'urtKey3', 'onClick': (_) => input.set(inputRef.current.value)}, ['Update']),
  ]);
}

var FancyInput = react.forwardRef((props, ref) {
  var inputRef = useRef();

  useImperativeHandle(
    ref,
    () => ({
      'focus': () {
        inputRef.current.focus();
      }
    }),
  );

  return react.input({
    'ref': inputRef,
    'value': props['value'],
    'onChange': (e) => props['update'](e.target.value),
    'placeholder': props['placeholder'],
    'style': {'borderColor': props['hasError'] ? 'crimson' : '#999'},
  });
});

var useImperativeHandleTestFunctionComponent =
    react.registerFunctionComponent(UseImperativeHandleTestComponent, displayName: 'useImperativeHandleTest');

UseImperativeHandleTestComponent(Map props) {
  var city = useState('');
  var state = useState('');
  var error = useState('');
  var message = useState('');
  var cityEl = useRef();
  var stateEl = useRef();

  validate(_) {
    final alphanumeric = RegExp(r'^[a-zA-Z]+$');
    if (!alphanumeric.hasMatch(city.value)) {
      message.set('Invalid form!');
      error.set('city');
      cityEl.current['focus']();
      return;
    }

    if (!alphanumeric.hasMatch(state.value)) {
      message.set('Invalid form!');
      error.set('state');
      stateEl.current['focus']();
      return;
    }

    error.set('');
    message.set('Valid form!');
  }

  return react.Fragment({}, [
    react.h1({}, ['useImperitiveHandle Example']),
    FancyInput({
      'hasError': error.value == 'city',
      'placeholder': 'City',
      'value': city.value,
      'update': city.set,
      'ref': cityEl,
    }, []),
    FancyInput({
      'hasError': error.value == 'state',
      'placeholder': 'State',
      'value': state.value,
      'update': state.set,
      'ref': stateEl,
    }, []),
    react.button({'onClick': validate}, ['Validate Form']),
    react.p({}, [message.value]),
  ]);
}

void main() {
  setClientConfiguration();

  render() {
    react_dom.render(
        react.Fragment({}, [
          react.h1({'key': 'functionComponentTestLabel'}, ['Function Component Tests']),
          react.h2({'key': 'useStateTestLabel'}, ['useState & useEffect Hook Test']),
          hookTestFunctionComponent({
            'key': 'useStateTest',
          }, []),
          react.br({'key': 'br1'}),
          react.h2({'key': 'useCallbackTestLabel'}, ['useCallback Hook Test']),
          useCallbackTestFunctionComponent({
            'key': 'useCallbackTest',
          }, []),
          newContextProviderComponent({
            'key': 'provider',
          }, [
            useContextTestFunctionComponent({
              'key': 'useContextTest',
            }, []),
          ]),
          react.h2({'key': 'useRefTestLabel'}, ['useRef Hook Test']),
          useRefTestFunctionComponent({
            'key': 'useRefTest',
          }, []),
          react.h2({'key': 'useImperativeHandleTestLabel'}, ['useImperativeHandle Hook Test']),
          useImperativeHandleTestFunctionComponent({
            'key': 'useImperativeHandleTest',
          }, []),
        ]),
        querySelector('#content'));
  }

  render();
}
