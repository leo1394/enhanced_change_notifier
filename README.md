
## enhanced_change_notifier
[![pub package](https://img.shields.io/pub/v/enhanced_change_notifier.svg)](https://pub.dev/packages/enhanced_change_notifier)
[![pub points](https://img.shields.io/pub/points/enhanced_change_notifier?color=2E8B57&label=pub%20points)](https://pub.dev/packages/enhanced_change_notifier/score)
[![GitHub Issues](https://img.shields.io/github/issues/leo1394/enhanced_change_notifier.svg?branch=master)](https://github.com/leo1394/enhanced_change_notifier/issues)
[![GitHub Forks](https://img.shields.io/github/forks/leo1394/enhanced_change_notifier.svg?branch=master)](https://github.com/leo1394/enhanced_change_notifier/network)
[![GitHub Stars](https://img.shields.io/github/stars/leo1394/enhanced_change_notifier.svg?branch=master)](https://github.com/leo1394/enhanced_change_notifier/stargazers)
[![GitHub License](https://img.shields.io/badge/license-MIT%20-blue.svg)](https://raw.githubusercontent.com/leo1394/enhanced_change_notifier/master/LICENSE)

Support for targeted notifications on object property changes.

Enhanced ChangeNotifiers introduce three new features in addition to all existing ChangeNotifier capabilities in Flutter Core:

- target: notifies listeners at the moment a specified property changes.
- once: notifies listeners only once at the moment of a change.
- immediate: allows notifications to be sent immediately after a listener is registered and upon subsequent changes.

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
```dart
import 'package:enhanced_change_notifier/enhanced_change_notifier.dart';

class AppModel extends EnhancedChangeNotifier {
  String? _token;

  String? get token => _token;
  set token(String? token) {
    _token = token;
    notifyListeners("token");
  }
}

// GlobalFactory helps create a global singleton instance.
final GlobalFactory<AppModel> appStateModel = GlobalFactory(() => AppModel());

function _e_anyChangedListener() {
  print("any property is changed");
}

function _e_tokenChangedListener(String property) {
  print("$property is changed");
}

function _e_onceListener(String property) {
  print("$property is changed, will notify only once.");
}

function _e_immediateListener(String property) {
  print("$property is changed, will send immediately after listener is registered.");
}

appStateModel.getInstance().addListener(_e_anyChangedListener);
appStateModel.getInstance().addListener(_e_tokenChangedListener, target: 'token');
appStateModel.getInstance().addListener(_e_onceListener, target: 'token', once: true);
appStateModel.getInstance().addListener(_e_immediateListener, target: 'token', immediate: true);

```

## Additional information
Feel free to file an issue if you have any problem.
