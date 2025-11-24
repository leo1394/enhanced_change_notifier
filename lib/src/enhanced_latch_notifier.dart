import 'enhanced_value_notifier.dart';
import 'enhanced_change_notifier.dart';

/// A specialized [EnhancedValueNotifier] that acts like a latch.
///
/// This notifier holds back value updates until it is explicitly "unlatched".
/// When [fire] is called, the value is cached. Once [unlatch] is called,
/// the cached value is released and all listeners are notified. This is useful
/// for coordinating asynchronous operations where you want to signal completion
/// with a final result.
class EnhancedLatchNotifier<T> extends EnhancedValueNotifier<T?> {
  bool _latchOpened = false;
  String _property = "latch";
  T? _cached;

  /// Creates an instance of [EnhancedLatchNotifier] with an initial value of null.
  EnhancedLatchNotifier() : super(null);

  /// Adds a listener that will be notified when the latch is unlatched.
  ///
  /// [listener]: The callback to execute. It must be a [ValueCallback].
  /// [target]: The property name to listen to. Defaults to "latch".
  /// [once]: If true, the listener is automatically removed after the first notification.
  /// [immediate]: This parameter is not used by the latch logic but is part of the superclass signature.
  @override
  void addListener(Function listener,
      {Object? target = "latch", bool once = false, bool immediate = false}) {
    assert(listener is ValueCallback, "listener should be ValueCallback!!!");
    assert(target is String?, "target of Latch should be String? ");
    if (target is String) {
      _property = target;
    }

    super.addListener(listener, target: target ?? _property, once: once);
  }

  /// Caches a new value. If the latch is already open, it immediately notifies listeners.
  ///
  /// If the latch is closed, the [value] is stored internally and will be sent
  /// to listeners only when [unlatch] is called.
  ///
  /// [value]: The value to cache and potentially notify listeners with.
  void fire(T value) {
    _cached = value;
    if (_latchOpened) {
      super.properties[this._property] = value;
      notifyListeners(this._property);
    }
  }

  /// Opens the latch, notifying all listeners with the last cached value.
  ///
  /// This method signals that the awaited task is complete. It will throw a
  /// [StateError] if called more than once before a [reset].
  ///
  /// [partialResult]: An optional result to provide at the moment of unlatching.
  /// If provided, it is used. Otherwise, the last value from [fire] is used.
  void unlatch([T? partialResult]) {
    if (_latchOpened) {
      throw StateError('Cannot unlatch() after latch is already complete');
    }

    _latchOpened = true;

    final result = partialResult ?? _cached;
    if (result == null) {
      throw StateError('Latch completed but no result was ever set!');
    }
    super.properties[this._property] = _cached;
    notifyListeners(this._property);
  }

  /// Resets the latch to its initial closed state, allowing it to be reused.
  ///
  /// This clears the previous result and closes the latch.
  void reset() {
    _latchOpened = false;
    _cached = null; // clear previous result
    super.properties[this._property] = null;
  }
}
