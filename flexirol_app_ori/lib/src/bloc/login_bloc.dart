import 'dart:async';
import 'package:flexirol_app/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {

  final _emailController    = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Recuperar los datos del Stream

  Stream<String> get emailStream    => _emailController.stream.transform( validarEmail );
  Stream<String> get passwordStream => _passwordController.stream.transform( validarPassword );

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  // Insertar valores al Stream

  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Obtener el último valor ingresado a los streams
  String get email    => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();

  }

}

class UsuarioformBloc with Validators {

  final _controllerName = BehaviorSubject<String>();
  final _controllerSecondname    = BehaviorSubject<String>();
  final _controllerEmailusuario = BehaviorSubject<String>();
  final _controllerTele    = BehaviorSubject<String>();
  final _controllerFecha = BehaviorSubject<String>();
  final _controllerCiudad    = BehaviorSubject<String>();
  final _controllerDirec = BehaviorSubject<String>();

  Stream<String> get NameStream => _controllerName.stream.transform( validarEmail );
  Stream<String> get SecondNameStream    => _controllerSecondname.stream.transform( validarEmail );
  Stream<String> get EmailusuarioStream => _controllerEmailusuario.stream.transform( validarEmailbien );
  Stream<String> get TeleStream    => _controllerTele.stream.transform( validarEmail );
  Stream<String> get FechaStream => _controllerFecha.stream.transform( validarEmail );
  Stream<String> get CiudadStream    => _controllerCiudad.stream.transform( validarEmail );
  Stream<String> get DirecStream => _controllerDirec.stream.transform( validarEmail );

  Stream<bool> get formValidStream =>
      Rx.combineLatest7(NameStream,SecondNameStream,EmailusuarioStream,TeleStream,
          FechaStream,CiudadStream,DirecStream, (N,S,E,T,F,C,D) => true);

  // Insertar valores al Stream

  Function(String) get changeName => _controllerName.sink.add;
  Function(String) get changeSecondname    => _controllerSecondname.sink.add;
  Function(String) get changeEmailusuario => _controllerEmailusuario.sink.add;
  Function(String) get changeTele    => _controllerTele.sink.add;
  Function(String) get changeFecha => _controllerFecha.sink.add;
  Function(String) get changeCiudad    => _controllerCiudad.sink.add;
  Function(String) get changeDirec => _controllerDirec.sink.add;

  // Obtener el último valor ingresado a los streams
  String get Name => _controllerName.value;
  String get Secondname    => _controllerSecondname.value;
  String get Emailusuario => _controllerEmailusuario.value;
  String get Tele    => _controllerTele.value;
  String get Fecha => _controllerFecha.value;
  String get Ciudad    => _controllerCiudad.value;
  String get Direc => _controllerDirec.value;

  dispose() {
    _controllerName?.close();
    _controllerSecondname?.close();
    _controllerEmailusuario?.close();
    _controllerTele?.close();
    _controllerFecha?.close();
    _controllerCiudad?.close();
    _controllerDirec?.close();
  }

}

class FormpasswordBloc with Validators {

  final _passwordController = BehaviorSubject<String>();
  final _newpasswordController = BehaviorSubject<String>();
  final _confirmpasswordController = BehaviorSubject<String>();


  // Recuperar los datos del Stream

  Stream<String> get passwordStream => _passwordController.stream.transform( validarPassword );
  Stream<String> get newpasswordStream => _newpasswordController.stream.transform( validarPassword );
  Stream<String> get confirmpasswordStream => _confirmpasswordController.stream.transform( validarPassword );


  Stream<bool> get formValidStream =>
      Rx.combineLatest3(passwordStream,newpasswordStream,confirmpasswordStream, (p,n,c) => true);

  // Insertar valores al Stream
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeNewPassword => _newpasswordController.sink.add;
  Function(String) get changeConfirmPassword => _confirmpasswordController.sink.add;


  // Obtener el último valor ingresado a los streams
  String get password => _passwordController.value;
  String get newpassword => _newpasswordController.value;
  String get confirmpassword => _confirmpasswordController.value;


  dispose() {
    _passwordController?.close();
    _newpasswordController?.close();
    _confirmpasswordController?.close();

  }

}

class BancoformBloc with Validators {

  final _controllerName = BehaviorSubject<String>();
  final _controllerCedula    = BehaviorSubject<String>();
  final _controllerEmailbanco = BehaviorSubject<String>();
  final _controllerTipocuenta    = BehaviorSubject<String>();
  final _controllerBanco = BehaviorSubject<String>();
  final _controllerAccount    = BehaviorSubject<String>();

  Stream<String> get NameStream => _controllerName.stream.transform( validarEmail );
  Stream<String> get CedulaStream    => _controllerCedula.stream.transform( validarEmail );
  Stream<String> get EmailbancoStream => _controllerEmailbanco.stream.transform( validarEmailbien );
  Stream<String> get TipocuentaStream    => _controllerTipocuenta.stream.transform( validarEmail );
  Stream<String> get BancoStream => _controllerBanco.stream.transform( validarEmail );
  Stream<String> get AccountStream    => _controllerAccount.stream.transform( validarEmail );

  Stream<bool> get formValidStream =>
      Rx.combineLatest6(NameStream,CedulaStream,EmailbancoStream,TipocuentaStream,
          BancoStream,AccountStream, (N,C,E,T,B,A,) => true);

  // Insertar valores al Stream

  Function(String) get changeName => _controllerName.sink.add;
  Function(String) get changeCedula    => _controllerCedula.sink.add;
  Function(String) get changeEmailbanco => _controllerEmailbanco.sink.add;
  Function(String) get changeTipocuenta    => _controllerTipocuenta.sink.add;
  Function(String) get changeBanco => _controllerBanco.sink.add;
  Function(String) get changeAccount    => _controllerAccount.sink.add;


  // Obtener el último valor ingresado a los streams
  String get Name => _controllerName.value;
  String get Cedula    => _controllerCedula.value;
  String get Emailbanco => _controllerEmailbanco.value;
  String get Tipocuenta    => _controllerTipocuenta.value;
  String get Banco => _controllerBanco.value;
  String get Account    => _controllerAccount.value;

  dispose() {
    _controllerName?.close();
    _controllerCedula?.close();
    _controllerEmailbanco?.close();
    _controllerTipocuenta?.close();
    _controllerBanco?.close();
    _controllerAccount?.close();
  }

}

class SaldoBloc with Validators {

  final _DisponibleController    = BehaviorSubject<String>();
  final _BancoController = BehaviorSubject<String>();

  // Recuperar los datos del Stream

  Stream<String> get DisponibleStream    => _DisponibleController.stream.transform( validarEmail );
  Stream<String> get BancoStream => _BancoController.stream.transform( validarEmail );

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(DisponibleStream, BancoStream, (D, B) => true);

  // Insertar valores al Stream

  Function(String) get changeDisponible    => _DisponibleController.sink.add;
  Function(String) get changeBanco => _BancoController.sink.add;

  // Obtener el último valor ingresado a los streams
  String get Disponible    => _DisponibleController.value;
  String get Banco => _BancoController.value;

  dispose() {
    _DisponibleController?.close();
    _BancoController?.close();

  }

}
