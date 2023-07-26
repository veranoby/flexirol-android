// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flexirol_app/src/bloc/login_bloc.dart';
export 'package:flexirol_app/src/bloc/login_bloc.dart';


class Provider extends InheritedWidget {
  static Provider _instancia;
  factory Provider({ Key key, Widget child }) {
    if ( _instancia == null ) {
      _instancia = new Provider._internal(key: key, child: child );
    }
    return _instancia;
  }
  Provider._internal({ Key key, Widget child })
    : super(key: key, child: child );
  final loginBloc = LoginBloc();
  final _usuarioformBloc = UsuarioformBloc();
  final _formpasswordBloc = FormpasswordBloc();
  final _bancoformBloc = BancoformBloc();
  final _saldoBloc = SaldoBloc();


  // Provider({ Key key, Widget child })
  //   : super(key: key, child: child );
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
  static LoginBloc of ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
  static UsuarioformBloc usuarioformBloc ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._usuarioformBloc;
  }
  static FormpasswordBloc formpasswordBloc ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._formpasswordBloc;
  }
  static BancoformBloc bancoformBloc ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._bancoformBloc;
  }
  static SaldoBloc saldoBloc ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._saldoBloc;
  }
}