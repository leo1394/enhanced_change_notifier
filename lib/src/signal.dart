import 'package:flutter/foundation.dart';
import './enhanced_value_notifier.dart';

/// A [EnhancedValueNotifier] that holds a boolean value for signal.
/// Useful implementation buffers pipelined listener pending a release signal.
class Signal extends EnhancedValueNotifier<bool> {
  /// Creates a [EnhancedValueNotifier] that wraps boolean value, True in default.
  Signal() : super(true);

  /// register a listener in promise's prototype
  /// consumed immediately or awaited once via Signal(True).
  void promise(VoidCallback listener) {
    if (value) {
      listener();
      return;
    }
    super.addListener(listener, once: true);
  }
}
