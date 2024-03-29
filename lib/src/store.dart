import 'package:flutter/material.dart';

typedef ChangeCallback = void Function(dynamic key, dynamic value);

abstract class DataStore {
  T get<T>([T? onNullValue]);

  void set(value);
}

class Store extends StatefulWidget {
  final Widget child;
  final Map data;
  final ChangeCallback? onValueModified;

  const Store({
    Key? key,
    required this.child,
    this.data = const {},
    this.onValueModified,
  }) : super(key: key);

  @override
  _StoreState createState() => _StoreState();

  static DataStore of(BuildContext context, key) {
    final store =
        InheritedModel.inheritFrom<InheritedStore>(context, aspect: key)!;
    store.setKey(key);
    return store;
  }

  static T get<T>(BuildContext context, key, [defaultValue]) {
    final store =
        InheritedModel.inheritFrom<InheritedStore>(context, aspect: key)!;
    store.setKey(key);
    return store.get(defaultValue);
  }

  static void set(BuildContext context, key, value) {
    final store =
        InheritedModel.inheritFrom<InheritedStore>(context, aspect: key)!;
    store.setKey(key);
    store.set(value);
  }
}

class _StoreState extends State<Store> {
  late Map data;
  var change;
  ChangeCallback? changeCallback;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    changeCallback = widget.onValueModified ?? (a, b) {};
  }

  @override
  Widget build(BuildContext context) {
    return InheritedStore(
      child: widget.child,
      data: data,
      change: change,
      setFunction: (key, value) {
        setState(() {
          change = key;
          data[key] = value;
          if (changeCallback != null) {
            changeCallback!(key, value);
          }
        });
      },
    );
  }
}

// ignore: must_be_immutable
class InheritedStore extends InheritedModel<Object> implements DataStore {
  final Map data;
  final change;
  final ChangeCallback setFunction;
  var activeKey;

  InheritedStore({
    Key? key,
    required this.data,
    required this.setFunction,
    required this.change,
    required Widget child,
  }) : super(key: key, child: child);

  static InheritedStore of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedStore>()!;
  }

  T get<T>([T? onNullValue]) => data[activeKey] ?? onNullValue;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => change != null;

  @override
  bool updateShouldNotifyDependent(
          InheritedModel oldWidget, Set dependencies) =>
      dependencies.contains(change);

  @override
  void set(value) => setFunction(activeKey, value);

  void setKey(key) => activeKey = key;
}
