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
