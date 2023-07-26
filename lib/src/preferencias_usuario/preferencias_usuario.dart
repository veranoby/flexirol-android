// @dart=2.9

import 'package:flexirol_app/src/pages/bancaria.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:

  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    prefs.initPrefs();

*/

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del token ID
  get token {
    return _prefs.getString('token') ?? '';
  }

  set token( String value ) {
    _prefs.setString('token', value);
  }

  // GET y SET del MAP JSON
  get myInfo {
    return _prefs.getString('myInfo') ?? '';
  }

  set myInfo( String value ) {
    _prefs.setString('myInfo', value);
  }

  get bancaria {
    return _prefs.getString('bancaria') ?? '';
  }

  set bancaria( String value ) {
    _prefs.setString('bancaria', value);
  }


  // GET y SET de la última página
  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina( String value ) {
    _prefs.setString('ultimaPagina', value);
  }

  get id_temp {
    return _prefs.getString('id_temp') ?? '';
  }

  set id_temp( String value ) {
    _prefs.setString('id_temp', value);
  }
  get password {
    return _prefs.getString('password') ?? '';
  }

  set password( String value ) {
    _prefs.setString('password', value);
  }

  get solicitudes_todas {
    return _prefs.getString('solicitudes_todas') ?? '';
  }

  set solicitudes_todas( String value ) {
    _prefs.setString('solicitudes_todas', value);
  }


  get permiso_solicitudes {
    return _prefs.getString('permiso_solicitudes') ?? '';
  }

  set permiso_solicitudes( String value ) {
    _prefs.setString('permiso_solicitudes', value);
  }

  // variables de solicitudes temporales

  get valor_disponible_total {
    return _prefs.getString('valor_disponible_total') ?? '';
  }

  set valor_disponible_total( String value ) {
    _prefs.setString('valor_disponible_total', value);
  }

  get mensaje_bloqueo_1 {
    return _prefs.getString('mensaje_bloqueo_1') ?? '';
  }

  set mensaje_bloqueo_1( String value ) {
    _prefs.setString('mensaje_bloqueo_1', value);
  }
  get mensaje_bloqueo_2 {
    return _prefs.getString('mensaje_bloqueo_2') ?? '';
  }

  set mensaje_bloqueo_2( String value ) {
    _prefs.setString('mensaje_bloqueo_2', value);
  }

}

