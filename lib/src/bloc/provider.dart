import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/login_bloc.dart';
import 'package:form_validation/src/bloc/productos_bloc.dart';
export 'package:form_validation/src/bloc/productos_bloc.dart';
export 'package:form_validation/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget {
  static Provider _instance;
  final loginBlock = LoginBloc();
  final _productosBloc = ProductosBloc();

  factory Provider({Key key, Widget child}) {
    if (_instance == null) {
      _instance = Provider._internal(key: key, child: child);
    }
    return _instance;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  // Provider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>()).loginBlock;
  }

  static ProductosBloc productosBloc(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>())
        ._productosBloc;
  }
}
