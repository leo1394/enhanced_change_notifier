// Copyright (c) 2025, the Dart project authors. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

class GlobalFactory<T> {
  final T Function() constructor;
  static final Map<Type, dynamic> _instances = {};

  GlobalFactory(this.constructor);

  T getInstance() {
    final type = T;
    if (!_instances.containsKey(type)) {
      _instances[type] = constructor();
    }
    return _instances[type];
  }
}
