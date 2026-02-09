// Copyright (c) 2025, the Dart project authors. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

typedef PropertyCallback = void Function(String property);
typedef PropertyValueCallback = void Function(String property, Object? value);
typedef ValueCallback = void Function(Object? value);
typedef VoidCallback = void Function();

/// A class that can be extended in that provides a change notification
/// API using [VoidCallback] or [PropertyCallback] or [ValueCallback] or [PropertyValueCallback] for notifications of specified or all properties.
class EnhancedChangeNotifier extends ChangeNotifier {
  /// Define a map to hold all property values.
  /// It's protected so only this class and subclasses can access it directly.
  @protected
  final Map<String, dynamic> _properties = {};

  /// Custom listener mechanism
  final Map<String, List<Function>> _propertyListeners = {};
  final Map<String, List<Function>> _onceListeners = {};

  /// Implement getProperty to return the value of a property by its name.
  @protected
  Map<String, dynamic> get properties => Map.unmodifiable(_properties);

  @protected
  dynamic operator [](String target) => _properties[target];

  @protected
  void operator []=(String target, dynamic value) {
    if (_properties[target] == value) return;
    _properties[target] = value;
    notifyListeners(target);
  }

  @protected
  void clear(String target, {dynamic fallback, bool silent = true}) {
    _properties[target] = fallback;
    if (!silent) {
      notifyListeners(target);
    }
  }

  /// Initialize `properties` with map
  @protected
  void fromMap(Map<String, dynamic> props) {
    for (var propertyName in props.keys.toList()) {
      properties[propertyName] = props[propertyName];
    }
  }

  /// Override dispose to discards any resources used by the object. After
  /// this is called, the object is not in a usable state and should be discarded
  /// (calls to [addListener] will throw after the object is disposed).
  ///
  /// This method should only be called by the object's owner.
  ///
  /// This method does not notify listeners, and clears the listener list once
  /// it is called. Consumers of this class must decide on whether to notify
  /// listeners or not immediately before disposal.
  @override
  void dispose() {
    super.dispose();
    // remove all property listener
    _propertyListeners.clear();
    // remove all once property listener
    _onceListeners.clear();
    // remove all properties
    _properties.clear();
  }

  /// Override hasListeners to check if there are any listeners.
  @override
  bool get hasListeners =>
      super.hasListeners ||
      _propertyListeners.isNotEmpty ||
      _onceListeners.isNotEmpty;

  /// Register a listener for a specific property
  /// target can be an element or elements list like &#91; property1, property2 &#93;
  @override
  void addListener(Function listener,
      {Object? target, bool once = false, bool immediate = false}) {
    assert(
        listener is VoidCallback ||
            listener is PropertyCallback ||
            listener is PropertyValueCallback,
        "Listener must be a Function(), Function(String), or Function(String, Object?)");
    assert(target == null || target is String || target is List<String>,
        "Target must be String or List<String>");
    assert(target != null || listener is! PropertyCallback,
        "Subscribe all properties change event, listener can not be Function(String)");
    assert(target != null || listener is! PropertyValueCallback,
        "Subscribe all properties change event, listener can not be Function(String, Object?)");

    List<String?>? targets = _validate(target);
    if (targets == null || targets.isEmpty) {
      return;
    }

    for (String? property in targets) {
      String targetKey = property ?? 'All';
      if (once == true) {
        _onceListeners.putIfAbsent(targetKey, () => []);
        _onceListeners[targetKey]!.contains(listener)
            ? null
            : _onceListeners[targetKey]!.add(listener);
      } else {
        _propertyListeners.putIfAbsent(targetKey, () => []);
        if (targetKey == "All" &&
            !_propertyListeners[targetKey]!.contains(listener)) {
          if (listener is VoidCallback) {
            super.addListener(listener);
          }
        }
        _propertyListeners[targetKey]!.contains(listener)
            ? null
            : _propertyListeners[targetKey]!.add(listener);
      }

      if (immediate == true) {
        notifyListeners(property);
      }
    }
  }

  /// Notify listeners for a specific element
  @override
  void notifyListeners([String? target]) {
    print("notify Listeners for ${target ?? 'All'} ...");
    super.notifyListeners();

    String targetKey = target ?? 'All';
    if (_onceListeners.isNotEmpty &&
        _onceListeners.containsKey(targetKey) &&
        _onceListeners[targetKey]!.isNotEmpty) {
      for (var listener in _onceListeners[targetKey] ?? []) {
        try {
          if (targetKey != 'All') {
            if (listener is PropertyValueCallback) {
              final value = properties[targetKey];
              listener(targetKey, value);
            } else if (listener is ValueCallback) {
              final value = properties[targetKey];
              listener(value);
            } else if (listener is PropertyCallback) {
              listener(targetKey);
            } else {
              listener();
            }
          } else {
            listener();
          }
        } catch (e, stackTrace) {
          print("$target error message $e \n $stackTrace");
        }
      }
      print("Once Listeners for $target removed after trigger ...");
      _onceListeners[targetKey] = [];
    }

    if (target != null && target.isNotEmpty) {
      _propertyListeners[target]?.forEach((listener) {
        try {
          if (targetKey != 'All') {
            if (listener is PropertyValueCallback) {
              final value = properties[targetKey];
              listener(targetKey, value);
            } else if (listener is ValueCallback) {
              final value = properties[targetKey];
              listener(value);
            } else if (listener is PropertyCallback) {
              listener(targetKey);
            } else {
              listener();
            }
          } else {
            listener();
          }
        } catch (e, stackTrace) {
          print("$target error message $e \n $stackTrace");
        }
      });
    }
  }

  /// Remove a listener
  @override
  void removeListener(Function listener) {
    for (var elementName in _propertyListeners.keys) {
      if (_propertyListeners[elementName]!.contains(listener)) {
        _propertyListeners[elementName]!.remove(listener);
      }
    }
    for (var elementName in _onceListeners.keys) {
      if (_onceListeners[elementName]!.contains(listener)) {
        _onceListeners[elementName]!.remove(listener);
      }
    }
    if (listener is VoidCallback) {
      super.removeListener(listener);
    }
  }

  List<String?>? _validate(Object? target) {
    if ((target is! String) && (target is! List<String>) && (target != null)) {
      print("invalid target type $target");
      return null;
    }
    if (target is String) {
      if (target == "All") {
        print("Error: target 'All' is reserved keywords!");
      }
      if (target.isEmpty) {
        print("Error: target can not be empty String!");
      }
      target = [target]
          .where((element) => element.isNotEmpty && element != "All")
          .toList();
    } else if (target is List<String>) {
      if (target.contains("All")) {
        print("Warning: target 'All' is reserved keywords!");
      }
      if (target.contains("") || target.contains(null)) {
        print("Warning: target can not be empty String!");
      }
      target = target
          .where((element) => element.isNotEmpty && element != "All")
          .toList();
    } else {
      target = [null];
    }
    List<String?> targets = (target as List).cast<String?>().toList();
    if (targets.isEmpty) {
      return null;
    }
    print(
        "add listener for ${targets.length == 1 ? (targets[0] ?? 'All') : targets.toString()} ...");
    return targets;
  }
}
