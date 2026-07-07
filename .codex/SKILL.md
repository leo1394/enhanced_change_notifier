---
name: enhanced_change_notifier
description: Use when coding with enhanced_change_notifier: targeted property notifications, once/immediate listeners, GlobalFactory singletons, EnhancedValueNotifier, Signal, and EnhancedLatchNotifier delayed release patterns.
---

# enhanced_change_notifier Agent Context

Use this package when Flutter state needs targeted property notifications beyond core `ChangeNotifier`, or when listeners should be one-shot/immediate.

## Imports

```dart
import 'package:enhanced_change_notifier/enhanced_change_notifier.dart';
import 'package:enhanced_change_notifier/enhanced_value_notifier.dart';
import 'package:enhanced_change_notifier/signal.dart';
```

## EnhancedChangeNotifier

```dart
class AppModel extends EnhancedChangeNotifier {
  AppModel() {
    fromMap({"token": "initial-token"}); // silent init
  }

  String? get token => this["token"];
  set token(String? value) {
    this["token"] = value; // stores and notifies target "token"
  }

  void silentToken(String? value) {
    fromMap({"token": value});
    notifyListeners("token");
  }
}

final GlobalFactory<AppModel> appStateModel =
    GlobalFactory(() => AppModel());

void anyChanged() {}

final model = appStateModel.getInstance();
model.addListener(anyChanged);
model.addListener((String property) {}, target: "token");
model.addListener((String property) {}, target: "token", once: true);
model.addListener((String property) {}, target: "token", immediate: true);
model.token = "new-token";
model.removeListener(anyChanged);
```

## Signal

`Signal` caches pending callbacks until released.

```dart
final isConsumerReady = Signal()..value = false;
isConsumerReady.promise(() => print("Task executed"));
Future.delayed(const Duration(milliseconds: 300), () {
  isConsumerReady.value = true;
});
```

## EnhancedLatchNotifier

Use latch notification when a non-bool event should be stored until `unlatch()`.

```dart
class LatchStateEvent {
  final String actionId;
  final int value;
  LatchStateEvent(this.actionId, this.value);
}

class DelayedLatch extends EnhancedLatchNotifier<LatchStateEvent> {}

final latch = GlobalFactory<DelayedLatch>(() => DelayedLatch()).getInstance();
latch.addListener((event) {
  if (event.actionId == "test") print(event.value);
});
latch.fire(LatchStateEvent("test", 99));
latch.unlatch();
```

## Notes for Agents

- Use `this["property"] = value` for notifying property-specific listeners.
- Use `fromMap` for silent bulk updates; call `notifyListeners("property")` manually when needed.
- Use `target` for property-specific listeners, `once` for one-shot listeners, `immediate` for instant initial callbacks.
- Use `GlobalFactory<T>` for app-wide singleton model instances.
