// Copyright (c) 2025, the Dart project authors. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

typedef PropertyCallback = void Function(String property);
typedef VoidCallback = void Function();

class EnhancedChangeNotifier extends ChangeNotifier {
  // Custom listener mechanism
  final Map<String, List<Function>> _elementListeners = {};
  final Map<String, List<Function>> _onceListeners = {};

  // Register a listener for a specific element
  @override
  void addListener(Function listener, {Object? target, bool once = false, bool immediate = false} ) {
    assert(listener is VoidCallback || listener is PropertyCallback, "Listener must be a Function() or Function(String)");
    assert(target == null || target is String || target is List<String>, "Target must be String or List<String>");
    assert(target != null || listener is! PropertyCallback, "Subscribe all properties change event, listener can not be Function(String)");

    List<String?>? targets = this._validate(target);
    if(targets == null || targets.isEmpty) { return ; }

    for(String? property in targets) {
      String targetKey = property ?? 'All';
      if (once == true) {
        _onceListeners.putIfAbsent(targetKey, () => []);
        _onceListeners[targetKey]!.contains(listener) ? null : _onceListeners[targetKey]!.add(listener);
      } else {
        _elementListeners.putIfAbsent(targetKey, () => []);
        if (targetKey == "All" && ! _elementListeners[targetKey]!.contains(listener)) {
          if(listener is VoidCallback) {
            super.addListener(listener);
          }
        }
        _elementListeners[targetKey]!.contains(listener) ? null : _elementListeners[targetKey]!.add(listener);
      }

      if(immediate == true) {
        this.notifyListeners(property);
      }
    }
  }

  // Notify listeners for a specific element
  @override
  void notifyListeners([String? target]) {
    print("notify Listeners for ${target ?? 'All'} ...");
    super.notifyListeners();

    String targetKey = target ?? 'All';
    if (_onceListeners.isNotEmpty && _onceListeners.containsKey(targetKey) && _onceListeners[targetKey]!.isNotEmpty) {
      for(var listener in _onceListeners[targetKey] ?? []) {
        try{
          if(targetKey != 'All') {
            listener is PropertyCallback ? listener(targetKey) : listener();
          }else {
            listener();
          }
        } catch(e, stackTrace) {
          print("$target error message $e \n $stackTrace");
        }
      }
      print("Once Listeners for $target removed after trigger ...");
      _onceListeners[targetKey] = [];
    }

    if (target != null && target.isNotEmpty) {
      _elementListeners[target]?.forEach((listener) {
        try{
          if(targetKey != 'All') {
            listener is PropertyCallback ? listener(targetKey) : listener();
          }else {
            listener();
          }
        } catch(e, stackTrace) {
          print("$target error message $e \n $stackTrace");
        }
      });
    }
  }

  // Remove a listener
  @override
  void removeListener(Function listener) {
    for(var elementName in _elementListeners.keys) {
      if (_elementListeners[elementName]!.contains(listener)) {
        _elementListeners[elementName]!.remove(listener);
      }
    }
    for(var elementName in _onceListeners.keys) {
      if (_onceListeners[elementName]!.contains(listener)) {
        _onceListeners[elementName]!.remove(listener);
      }
    }
    if(listener is VoidCallback) {
      super.removeListener(listener);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<String?>? _validate(Object? target) {
    if((target is! String) && (target is! List<String>) && (target != null)) {
      print("invalid target type $target");
      return null;
    }
    if(target is String) {
      if(target == "All") {
        print("Error: target 'All' is reserved keywords!");
      }
      if(target.isEmpty) {
        print("Error: target can not be empty String!");
      }
      target = [target].where((element) => element.isNotEmpty && element != "All").toList();
    } else if(target is List<String>) {
      if(target.contains("All")) {
        print("Warning: target 'All' is reserved keywords!");
      }
      if(target.contains("") || target.contains(null)) {
        print("Warning: target can not be empty String!");
      }
      target = target.where((element) => element.isNotEmpty && element != "All").toList();
    } else {
      target = [null];
    }
    List<String?> targets = (target as List).cast<String?>().toList();
    if(targets.isEmpty) { return null; }
    print("add listener for ${targets.length == 1 ? (targets[0] ?? 'All') : targets.toString()} ...");
    return targets;
  }
}