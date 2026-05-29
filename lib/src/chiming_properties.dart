import 'dart:collection';

/// A map wrapper that notifies when a property value changes.
///
/// Reads are delegated directly to the source map. Writes, removals, and
/// clears update the source map and call the notify callback with each changed
/// property key.
class ChimingProperties extends MapBase<String, dynamic> {
  /// Creates a notifying view over [_source].
  ChimingProperties(this._source, this._notify);

  final Map<String, dynamic> _source;
  final void Function(String key) _notify;

  /// Returns the value for [key] from the source map.
  @override
  dynamic operator [](Object? key) => _source[key];

  /// Stores [value] for [key] and notifies listeners for [key] when it changes.
  @override
  void operator []=(String key, dynamic value) {
    if (_source[key] == value) return;
    _source[key] = value;
    _notify(key);
  }

  /// Removes all entries and notifies once for each removed key.
  @override
  void clear() {
    final keys = _source.keys.toList();
    _source.clear();
    for (final key in keys) {
      _notify(key);
    }
  }

  /// The keys currently present in the source map.
  @override
  Iterable<String> get keys => _source.keys;

  /// Removes [key] and notifies listeners for it when an entry existed.
  @override
  dynamic remove(Object? key) {
    final existed = _source.containsKey(key);
    final value = _source.remove(key);
    if (existed && key is String) {
      _notify(key);
    }
    return value;
  }
}
