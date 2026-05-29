import 'package:enhanced_change_notifier/enhanced_change_notifier.dart';
import 'package:enhanced_change_notifier/enhanced_latch_notifier.dart';
import 'package:test/test.dart';

class AppModel extends EnhancedChangeNotifier {
  AppModel({String? token}) {
    super.properties["token"] = token;
  }

  String? get token => this["token"];
  set token(String? token) {
    this["token"] = token;
  }
}

class LatchStateEvent {
  String actionId;
  int value;
  LatchStateEvent(this.actionId, this.value);
}

class DelayedLatch extends EnhancedLatchNotifier<LatchStateEvent> {}

void main() {
  group('EnhancedChangeNotifier', () {
    test('notifies all listeners when property setter uses notifying storage',
        () {
      final appModel = AppModel();
      var changes = 0;

      appModel.addListener(() {
        changes++;
      });

      appModel.token = "fe3f6b58-684e-4063-ba3b-1b8f14981a8e";

      expect(appModel.token, "fe3f6b58-684e-4063-ba3b-1b8f14981a8e");
      expect(changes, 1);
    });

    test('notifies targeted listeners with property and value', () {
      final appModel = AppModel();
      String? changedProperty;
      Object? changedValue;

      appModel.addListener((String property, Object? value) {
        changedProperty = property;
        changedValue = value;
      }, target: "token");

      appModel.token = "target-token";

      expect(changedProperty, "token");
      expect(changedValue, "target-token");
    });

    test('properties setter stores values without notifying listeners', () {
      final appModel = AppModel(token: "silent-token");
      var changes = 0;

      appModel.addListener(() {
        changes++;
      });

      expect(appModel.token, "silent-token");
      expect(changes, 0);
    });
  });

  group('EnhancedLatchNotifier', () {
    test('notifies listener when unlatched with cached value', () {
      final latch = DelayedLatch();
      LatchStateEvent? triggeredEvent;

      latch.addListener((value) {
        triggeredEvent = value;
      });

      latch.fire(LatchStateEvent("test", 99));

      expect(triggeredEvent, isNull);

      latch.unlatch();

      expect(triggeredEvent?.actionId, "test");
      expect(triggeredEvent?.value, 99);
    });
  });
}
