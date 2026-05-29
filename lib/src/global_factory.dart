// Copyright (c) 2025, the Dart project authors. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

/// A lightweight global singleton factory for a specific type [T].
///
/// Each generic type gets one lazily-created instance shared by every
/// [GlobalFactory] created for that type.
class GlobalFactory<T> {
  /// Creates the instance when [getInstance] is called for the first time.
  final T Function() constructor;
  static final Map<Type, dynamic> _instances = {};

  /// Creates a factory that uses [constructor] to build the singleton instance.
  GlobalFactory(this.constructor);

  /// Returns the singleton instance for [T], creating it when necessary.
  T getInstance() {
    final type = T;
    if (!_instances.containsKey(type)) {
      _instances[type] = constructor();
    }
    return _instances[type];
  }
}
