<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages). 
-->

Support for targeted notifications on object property changes.

Enhanced ChangeNotifiers introduce three new features in addition to all existing ChangeNotifier capabilities in Flutter Core:

- target: notifies listeners at the moment a specified property changes.
- once: notifies listeners only once at the moment of a change.
- immediate: allows notifications to be sent immediately after a listener is registered and upon subsequent changes.

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
