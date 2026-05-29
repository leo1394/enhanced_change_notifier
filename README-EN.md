
## enhanced_change_notifier
[![pub package](https://img.shields.io/pub/v/enhanced_change_notifier.svg)](https://pub.dev/packages/enhanced_change_notifier)
[![pub points](https://img.shields.io/pub/points/enhanced_change_notifier?color=2E8B57&label=pub%20points)](https://pub.dev/packages/enhanced_change_notifier/score)
[![GitHub Issues](https://img.shields.io/github/issues/leo1394/enhanced_change_notifier.svg?branch=master)](https://github.com/leo1394/enhanced_change_notifier/issues)
[![GitHub Forks](https://img.shields.io/github/forks/leo1394/enhanced_change_notifier.svg?branch=master)](https://github.com/leo1394/enhanced_change_notifier/network)
[![GitHub Stars](https://img.shields.io/github/stars/leo1394/enhanced_change_notifier.svg?branch=master)](https://github.com/leo1394/enhanced_change_notifier/stargazers)
[![GitHub License](https://img.shields.io/badge/license-MIT%20-blue.svg)](https://raw.githubusercontent.com/leo1394/enhanced_change_notifier/master/LICENSE)

Support for targeted notifications on object property changes.

Enhanced ChangeNotifiers introduce three new features in addition to all existing ChangeNotifier capabilities in Flutter Core:

- `target`: notifies listeners at the moment a specified property changes.
- `once`: notifies listeners only once at the moment of a change.
- `immediate`: allows notifications to be sent immediately after a listener is registered and upon subsequent changes.

Language: English | [中文](README.md)
## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: | :-: | :---: | :-----: |
|   ✅    | ✅  |  ✅   | ✅  |  ✅   |   ✅    |

## Requirements

- Flutter >=3.0.0 <4.0.0
- Dart >=2.17.0 

## Getting started
published on pub.dev, run this Flutter command
```shell
flutter pub add enhanced_change_notifier
```
## Usage in Dart

Multiple properties or Mutable data types, extending `EnhancedChangeNotifier` directly to meet flexible requirements like cache or targeted listener.
```dart
import 'package:enhanced_change_notifier/enhanced_change_notifier.dart';

class AppModel extends EnhancedChangeNotifier {
  AppModel() {
    // Silent initialization: updates the stored value without notifying listeners.
    super.fromMap({"token": "initial-token"});
  }

  String? get token => this["token"];
  set token(String? token) {
    // Method 1: Notifying update: stores the value and notifies listeners for `token`.
    this["token"] = token;
    // Method 2: Notifying update: stores the value and notifies listeners for `token`.
    super.properties["token"] = token;
    // Method 3: Manually notify with silent update
    super.fromMap({"token": "new value"});
    notifyListeners("token");
  }
}

// GlobalFactory helps create a global singleton instance.
final GlobalFactory<AppModel> appStateModel = GlobalFactory(() => AppModel());

void anyChangedListener() {
  print("any property is changed");
}

// Register all types of listeners
appStateModel.getInstance().addListener(anyChangedListener);
appStateModel.getInstance().addListener((String property) => print("$property is changed"), target: 'token');
appStateModel.getInstance().addListener((String property) => print("$property is changed, will notify only once."), target: 'token', once: true);
appStateModel.getInstance().addListener((String property) => print("$property is changed, will send immediately after listener is registered."), target: 'token', immediate: true);

// Setter writes notify listeners because it uses `this["token"] = token`.
appStateModel.getInstance().token = "fe3f6b58-684e-4063-ba3b-1b8f14981a8e";

// Remove a specific listener
appStateModel.getInstance().removeListener(anyChangedListener);

```

`Signal` A single implementation buffers pipelined listener pending a release signal.
```dart

import 'package:enhanced_change_notifier/signal.dart';

Signal isConsumerReady = Signal();
isConsumerReady.value = false;

// Register listener consumed immediately or awaited once via Signal(True).
isConsumerReady.promise(() => print("Task 1 executed"));
isConsumerReady.promise(() => print("Task 2 executed"));

// Release delayed signal
Future.delayed(Duration(milliseconds: 300), () => isConsumerReady.value = true);

```


`EnhancedLatchNotifier` supports complex data types for delayed notifications, unlike Signal which is limited to boolean values


```dart
import 'package:enhanced_change_notifier/enhanced_change_notifier.dart';
import 'package:enhanced_change_notifier/enhanced_latch_notifier.dart';

class LatchStateEvent {
  String actionId;
  int value;
  LatchStateEvent(this.actionId, this.value);
}

class DelayedLatch extends EnhancedLatchNotifier<LatchStateEvent> {}

final GlobalFactory<DelayedLatch> latchDemo = GlobalFactory(() => DelayedLatch());
latchDemo.getInstance().addListener((event) {
  if (event.actionId == "test") {
    print("triggered ==> ${event.actionId}, ${event.value}");
  }
});
// Fire latch and cache state event
latchDemo.getInstance().fire(LatchStateEvent("test", 99));
// Listener triggered when unlatch called
Future.delayed(const Duration(seconds: 3), () => latchDemo.getInstance().unlatch());
```

## Additional information
Feel free to file an issue if you have any problem.
