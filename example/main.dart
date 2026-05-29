import 'package:enhanced_change_notifier/enhanced_change_notifier.dart';
import 'package:enhanced_change_notifier/enhanced_latch_notifier.dart';
import 'package:enhanced_change_notifier/signal.dart';

class AppModel extends EnhancedChangeNotifier {
  AppModel() {
    super.fromMap(
        {"token": "initial-token", "baseUrl": "url", "tasks": "tasks"});
  }

  String? get token => this["token"];
  set token(String? token) {
    this["token"] = token;
  }

  String? get baseUrl => this["baseUrl"];
  set baseUrl(String? baseUrl) {
    super.properties["baseUrl"] = baseUrl;
  }

  Map<String, dynamic> get tasks => this["tasks"];
  set tasks(Map<String, dynamic> tasks) {
    super.fromMap({"tasks": tasks});
    notifyListeners("tasks");
  }
}

class LatchStateEvent {
  String actionId;
  int value;
  LatchStateEvent(this.actionId, this.value);
}

class DelayedLatch extends EnhancedLatchNotifier<LatchStateEvent> {}

void main() {
  // 1. AppModel extends EnhancedChangeNotifier example
  final GlobalFactory<AppModel> appStateModel = GlobalFactory(() => AppModel());
  // Register different types of listeners, support target, once, immediate
  appStateModel
      .getInstance()
      .addListener(() => print('any property changed in AppModel'));
  appStateModel.getInstance().addListener(
      (String property) => print('$property changed in AppModel'),
      target: ['token', 'baseUrl', 'tasks']);
  appStateModel.getInstance().addListener(
      (String property, Object? value) =>
          print('$property changed to $value in AppModel'),
      target: 'token');
  appStateModel.getInstance().addListener(
      (String property) => print(
          '$property changed in AppModel, listener would be triggered only once'),
      target: 'baseUrl',
      once: true);
  appStateModel.getInstance().addListener(
      (String property, Object? value) => print(
          '$property changed to $value in AppModel, listener would be triggered immediately right after setup '),
      target: 'tasks',
      immediate: true);

  // super.properties writes are useful for silent initialization.
  print("initial token: ${appStateModel.getInstance().token}");

  // Setters can trigger listeners with this[property] or explicit notifyListeners(property).
  appStateModel.getInstance().token = "fe3f6b58-684e-4063-ba3b-1b8f14981a8e";
  appStateModel.getInstance().baseUrl = "https://api.company.com";
  appStateModel.getInstance().tasks = {"task-for-example": 45};

  // 2. Boolean Signal Use Example
  Signal isConsumerReady = Signal();
  isConsumerReady.value = false;

  // Register listener consumed immediately or awaited once via Signal(True).
  isConsumerReady.promise(() => print("Task 1 executed"));
  isConsumerReady.promise(() => print("Task 2 executed"));

  // Release delayed signal
  Future.delayed(Duration(seconds: 3), () => isConsumerReady.value = true);

  // 3. DelayedLatch extends EnhancedLatchNotifier example
  final GlobalFactory<DelayedLatch> latchDemo =
      GlobalFactory(() => DelayedLatch());
  latchDemo.getInstance().addListener((event) {
    if (event.actionId == "test") {
      print("triggered ==> ${event.actionId}, ${event.value}");
    }
  });
  // Fire latch and cache state event
  latchDemo.getInstance().fire(LatchStateEvent("test", 99));
  // Listener triggered when unlatch called
  Future.delayed(
      const Duration(seconds: 3), () => latchDemo.getInstance().unlatch());
}
