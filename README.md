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

Support for detecting and being notified when an object is mutated.

There are two kinds of change notifiers:

AsyncChangeNotifier: be notified of a continuous stream of events over time.
ChangeNotifier: be notified at the moment of a change. This is a direct extraction of ChangeNotifier in Flutter Core.
Some suggested uses for this library:

Observe objects for changes, and log when a change occurs
Optimize for observable collections in your own APIs and libraries instead of diffing
Implement simple data-binding by listening to streams
Usage
There are two general ways to detect changes:

Listen to ChangeNotifier.changes and be notified when an object changes
Use Differ.diff to determine changes between two objects

## enhanced_change_notifier

```dart
const like = 'sample';
```

## global_factory

would create a global singleton instance of AppModel Class
```dart
final GlobalFactory<AppModel> appStateModel = GlobalFactory(() => AppModel());
```

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
