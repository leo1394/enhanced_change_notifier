import 'package:enhanced_change_notifier/enhanced_change_notifier.dart';
import 'package:test/test.dart';

class AppModel extends EnhancedChangeNotifier {
  String? _token;

  String? get token => _token;
  set token(String? token) {
    _token = token;
    notifyListeners("token");
  }
}

bool isChanged = false;
void _e_appStateAnyChangedListener() {
  print('any property changed in AppModel');
  isChanged = true;
}

void main() {
  group('A group of tests', () {
    final GlobalFactory<AppModel> appStateModel = GlobalFactory(() => AppModel());
    appStateModel.getInstance().addListener(_e_appStateAnyChangedListener);

    setUp(() {
      appStateModel.getInstance().token = "fe3f6b58-684e-4063-ba3b-1b8f14981a8e";
    });

    test('listener triggered', () {
      expect(isChanged, isTrue);
    });
  });
}
