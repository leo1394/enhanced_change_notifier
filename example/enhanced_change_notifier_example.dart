import 'package:enhanced_change_notifier/enhanced_change_notifier.dart';

class AppModel extends EnhancedChangeNotifier {
  Map<String, dynamic> _tasks = {};
  String? _token;
  String? _baseUrl;

  String? get token => _token;
  set token(String? token) {
    _token = token;
    notifyListeners("token");
  }

  String? get baseUrl => _baseUrl;
  set baseUrl(String? baseUrl) {
    _baseUrl = baseUrl;
    notifyListeners("baseUrl");
  }

  Map<String, dynamic> get tasks => _tasks;
  set tasks(Map<String, dynamic> tasks) {
    _tasks = tasks;
    notifyListeners("tasks");
  }
}

void main() {
  final GlobalFactory<AppModel> appStateModel = GlobalFactory(() => AppModel());
  // add different types of listeners, support target, once, immediate
  appStateModel.getInstance().addListener(_e_appStateAnyChangedListener);
  appStateModel.getInstance().addListener(_e_appStateTokenChangedListener, target: 'token');
  appStateModel.getInstance().addListener(_e_appStateBaseUrlChangedOnceListener, target: 'baseUrl', once: true);
  appStateModel.getInstance().addListener(_e_appStateTasksChangedListener, target: 'tasks', immediate: true);

  // assignment would trigger listeners
  appStateModel.getInstance().token = "fe3f6b58-684e-4063-ba3b-1b8f14981a8e";
  appStateModel.getInstance().baseUrl = "https://api.company.com";
  appStateModel.getInstance().tasks = {"task-for-example": 45};
}

void _e_appStateAnyChangedListener() {
  print('any property changed in AppModel');
}

void _e_appStateTokenChangedListener(String property) {
  print('$property changed in AppModel');
}

void _e_appStateTasksChangedListener(String property) {
  print('$property changed in AppModel, listener would be triggered immediately right after setup ');
}

void _e_appStateBaseUrlChangedOnceListener(String property) {
  print('$property changed in AppModel, listener would be triggered only once');
}
