# enhanced_change_notifier

Use `EnhancedChangeNotifier` for property-targeted listeners. Store notifying values with `this["key"] = value`; use `fromMap` for silent updates. Register listeners with `target`, `once`, and `immediate`. Use `GlobalFactory<T>` for singleton state. Use `Signal` for bool-like readiness gates and `EnhancedLatchNotifier<T>` for delayed non-bool events.
