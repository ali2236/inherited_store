import 'dart:convert';
import 'package:flutter/material.dart';

typedef ChangeCallback = void Function(String key, dynamic value);

abstract class DataStore {
  T get<T>([T onNullValue]);
  void set(value);
}

class Store extends StatefulWidget {
  final Widget child;
  final Map<String, dynamic> settings;
  final ChangeCallback onValueModified;

  const Store(
      {Key key, this.child, this.settings = const {}, this.onValueModified})
      : super(key: key);

  @override
  _StoreState createState() => _StoreState();

  static DataStore of(BuildContext context, String key) =>
      InheritedModel.inheritFrom<InheritedStore>(context, aspect: key)
        ..setKey(key);
}

class _StoreState extends State<Store> {
  Map<String, dynamic> settings;
  String change;
  ChangeCallback changeCallback;

  @override
  void initState() {
    super.initState();
    settings = widget.settings;
    changeCallback = widget.onValueModified ?? (a, b) {};
  }

  @override
  Widget build(BuildContext context) {
    return InheritedStore(
      child: widget.child,
      settings: settings,
      change: change,
      setFunction: (String key, value) {
        setState(() {
          change = key;
          settings[key] = value;
          changeCallback(key, value);
        });
      },
    );
  }
}

// ignore: must_be_immutable
class InheritedStore extends InheritedModel<String> implements DataStore {
  final Map<String, dynamic> settings;
  final String change;
  final void Function(String key, dynamic value) setFunction;
  String activeKey = '';

  InheritedStore({
    Key key,
    @required this.settings,
    @required this.setFunction,
    @required this.change,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static InheritedStore of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedStore>();
  }

  T get<T>([T onNullValue]) => settings[activeKey] as T ?? onNullValue;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => change != null;

  @override
  bool updateShouldNotifyDependent(
          InheritedModel oldWidget, Set<String> dependencies) =>
      dependencies.contains(change);

  @override
  void set(value) => setFunction(activeKey, value);

  void setKey(String key) => activeKey = key;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) => jsonEncode(settings);
}
