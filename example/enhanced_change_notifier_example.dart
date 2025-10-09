import 'package:enhanced_change_notifier/enhanced_change_notifier.dart';
import 'package:enhanced_change_notifier/signal.dart';

class AppModel extends EnhancedChangeNotifier {
  String? get token => super.properties["token"];
  set token(String? token) {
    super.properties["token"] = token;
    notifyListeners("token");
  }

  String? get baseUrl => super.properties["baseUrl"];
  set baseUrl(String? baseUrl) {
    super.properties["baseUrl"] = baseUrl;
    notifyListeners("baseUrl");
  }

  Map<String, dynamic> get tasks => super.properties["tasks"];
  set tasks(Map<String, dynamic> tasks) {
    super.properties["tasks"] = tasks;
    notifyListeners("tasks");
  }
}

void main() {
  final GlobalFactory<AppModel> appStateModel = GlobalFactory(() => AppModel());
  Signal isConsumerReady = Signal();

  // add different types of listeners, support target, once, immediate
  appStateModel.getInstance().addListener(_e_appStateAnyChangedListener);
  appStateModel
      .getInstance()
      .addListener(_e_appStateTokenChangedListener, target: 'token');
  appStateModel.getInstance().addListener(_e_appStateSomeChangedListener,
      target: ['token', 'baseUrl', 'tasks']);
  appStateModel.getInstance().addListener(_e_appStateBaseUrlChangedOnceListener,
      target: 'baseUrl', once: true);
  appStateModel.getInstance().addListener(_e_appStateTasksChangedListener,
      target: 'tasks', immediate: true);

  // assignment would trigger listeners
  appStateModel.getInstance().token = "fe3f6b58-684e-4063-ba3b-1b8f14981a8e";
  appStateModel.getInstance().baseUrl = "https://api.company.com";
  appStateModel.getInstance().tasks = {"task-for-example": 45};

  isConsumerReady.value = false;

  // delayed signal release
  Future.delayed(Duration(milliseconds: 300), () {
    isConsumerReady.value = true;
  });

  // register listener consumed immediately or awaited once via Signal(True).
  isConsumerReady.promise(() => print("Task 1 executed"));
  isConsumerReady.promise(() => print("Task 2 executed"));
  isConsumerReady.promise(() => print("Task 3 executed"));
}

void _e_appStateAnyChangedListener() {
  print('any property changed in AppModel');
}

void _e_appStateSomeChangedListener(String property) {
  print('$property changed in AppModel');
}

void _e_appStateTokenChangedListener(String property, Object? value) {
  print('$property changed to $value in AppModel');
}

void _e_appStateTasksChangedListener(String property, Object? value) {
  print(
      '$property changed to $value in AppModel, listener would be triggered immediately right after setup ');
}

void _e_appStateBaseUrlChangedOnceListener(String property) {
  print('$property changed in AppModel, listener would be triggered only once');
}
