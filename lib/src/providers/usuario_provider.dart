// @dart=2.9

import 'dart:convert';
import 'package:flexirol_app/src/bloc/provider.dart';
import 'package:flexirol_app/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {


  final _prefs = new PreferenciasUsuario();

  Future<Map> login( String email, String password) async {

    var url = "http://beta.flexirol.com/wp-json/flexirol/v1/remote-login/2";
    var body = jsonEncode({ 'username': email, 'password': password });
    await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    ).then((http.Response response) {

      print(json.decode( response.body ));
      print( response.statusCode);

      Map<String, dynamic> decodedResp = json.decode( response.body );

      if (response.statusCode == 200 || response.statusCode == 400) {

        _prefs.token = decodedResp['ID'].toString();

        print("token disco:");
        print( decodedResp['ID']);

        return { 'success': true, 'token': decodedResp['ID'] };

      } else {
        _prefs.token = "0";

        print("token disco:");
        print( _prefs.token);

        return { 'success': false, 'message': decodedResp['message'] };

      }
    } );

  }

  Future<Map> personal() async {

    var url = "http://beta.flexirol.com/wp-json/flexirol/v1/info/2";
    var body = jsonEncode({ 'role': "usuario", 'ID': _prefs.token });
    await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    ).then((http.Response response) {


      _prefs.myInfo = response.body;

      print("myInfo");
      print(_prefs.myInfo);

      return json.decode( response.body );


    } );

  }
  Future<String> manejar_plan(estado) async {

    var url = "http://beta.flexirol.com/wp-json/flexirol/v1/suscripcion/2";
    var body = jsonEncode({ 'ID': _prefs.token, 'status': estado });
    await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    ).then((http.Response response) {

      print("respuesta");
      print(response.body);

    } );

  }

  Future<String> solicitudes_todas() async {

    var url = "http://beta.flexirol.com/wp-json/flexirol/v1/banco/2";
    var body = jsonEncode({ 'tipo': "solicitud", 'post_author': _prefs.token , 'por_fecha' : 'si' });
    await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    ).then((http.Response response) {
      print(response.body);

      if (["", null, false, 0].contains(response.body)) {
        _prefs.solicitudes_todas =jsonEncode( [{ 'mensaje': "no hay", 'error': "No existen solicitudes creadas" }]);

        print(_prefs.solicitudes_todas);
        return ( _prefs.solicitudes_todas );
      } else {
        _prefs.solicitudes_todas = response.body;
        print("solicitudes_todas");
        print(_prefs.solicitudes_todas);
        return ( response.body );
        // do sth

      }
    } );

  }

  Future<String> solicitudes_crear(value , user_email) async {

    var url = "http://beta.flexirol.com/wp-json/flexirol/v1/grabar/2";
    Map myInfo = jsonDecode(_prefs.myInfo);

    var res = user_email.split("*");
 //   if ( (int.parse(res[0]) + int.parse(myInfo["dia_reinicio"])) > dd ){
    var porcentaje = "0";

    if (myInfo["flexirol3"] == "1" ){
      porcentaje = (double.parse(value) * double.parse(myInfo["flexirol"]) / 100).toStringAsFixed(2);
    }

    var valor_total = (double.parse(value) + double.parse(porcentaje)).toString() ;

    var		nombre = myInfo["first_name"] + ' ' + myInfo["last_name"] + ' - Cedula:' + myInfo["cedula"] + ' - Monto:\$' + value;

    var			mensaje_completo = nombre + '<br>Costo del Servicio:\$' + porcentaje + ' - Total a Descontarse de su sueldo:\$' + valor_total + '<br>' + res[1];

    var body = jsonEncode({
			        'post_author':  _prefs.token , //id del usuario solicitando - LISTO
			        'post_title': nombre , //titulo para busqueda rapida en filtros admin - lo creo arriba
			        'post_excerpt': value , //monto solicitado - viene de la forma
			        'gearbox': porcentaje , //tax agregado - lo calculo aqui, cuando llegue la forma - lo creo arriba
			        'post_content': mensaje_completo , //TODOS los datos de la solicxitud transferencia cuenta bancaria seleccionada - lo creo arriba

			        'user_email': res[0] , //ID cuenta bancaria seleccionada

			       'post_type': 'solicitud' , //tipo de post - LISTO
			        'tag': 'pendiente' , //ESTADO del post - LISTO
			        'empresa': myInfo["empresa"] ,	//ID mi empresa
    });

    print("body");

    print(body);

    await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    ).then((http.Response response) {
      print(response.body);

      if (["", null, false, 0].contains(response.body)) {

      } else {
        print("solicitudes_todas mapeo:");
        // do sth
      }
    } );

  }

  Future<String> bancaria() async {

    var url = "http://beta.flexirol.com/wp-json/flexirol/v1/banco/2";
    var body = jsonEncode({ 'tipo': "cuenta", 'post_author': _prefs.token });
    await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    ).then((http.Response response) {
      print(response.body);

      if (["", null, false, 0].contains(response.body)) {
        _prefs.bancaria =jsonEncode( [{ 'mensaje': "no hay", 'error': "No existen cuentas creadas" }]);

        print(_prefs.bancaria);
        return ( _prefs.bancaria );
      } else {
        _prefs.bancaria = response.body;
        print("bancaria mapeo:");
        print(_prefs.bancaria);
        return ( response.body );
        // do sth

      }
      } );

  }

  Future<Map> formusuario(String Name,String Secondname, String Emailusuario,String Tele, String Fecha,String Ciudad, String Direc) async {

    var url = "http://beta.flexirol.com/wp-json/flexirol/v1/remoteUpdate/2";
    var body = jsonEncode({ 'address': Direc, 'city': Ciudad, 'birth_date': Fecha, 'phone_number': Tele, 'last_name': Secondname, 'first_name': Name, 'user_email': Emailusuario, 'ID': _prefs.token });

   print("body");
   print(body);

     await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    ).then((http.Response response) {

      Map<String, dynamic> decodedResp = json.decode( response.body );

      if (response.statusCode == 200 || response.statusCode == 400) {
        print("Exito en la actualizacion");
        _prefs.myInfo = jsonEncode(decodedResp['data']);
        print("_prefs.myInfo");
        print(_prefs.myInfo);

        return { 'success': true, 'message': "Actualizacion realizada con exito!" };

      } else {
        print("Error - no pudo actualizarse la informacion");
        return { 'success': false, 'message': 'Error - no pudo actualizarse la informacion' };
      }

    } );

    return { 'success': true, 'message': "Actualizacion realizada con exito!" };


  }
  Future<Map> formbanco(String Name,String Tipocuenta, String Account,String Cedula, String Emailbanco,String Banco) async {
    String bancocuenta = Banco + ':' +  Account ;

    var url = "http://beta.flexirol.com/wp-json/flexirol/v1/grabar/2";
    var body = jsonEncode({ 'post_author': _prefs.token, 'post_type': "cuenta", 'post_excerpt': Name, 'gearbox': Tipocuenta, 'numero_cuenta': Account, 'post_content': Cedula, 'user_email': Emailbanco, 'post_banco': Banco, "post_title": bancocuenta });

    print("body");
    print(body);

  await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    ).then((http.Response response) {

      if (response.statusCode == 200 || response.statusCode == 400) {
        print("Exito en la actualizacion");

        return { 'success': true, 'message': "Actualizacion realizada con exito!" };

      } else {
        print("Error - no pudo actualizarse la informacion");
        return { 'success': false, 'message': 'Error - no pudo actualizarse la informacion' };
      }

    } );

    return { 'success': true, 'message': "Cuenta añadida con exito!" };


  }
  Future<Map> formpassword(String newpassword) async {

    var url = "http://beta.flexirol.com/wp-json/flexirol/v1/remote-password/2";
    var body = jsonEncode({ 'ID': _prefs.token, 'password': newpassword });
    await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    ).then((http.Response response) {

      print(response.body);

      return (response.body );
    } );

  }
  Future<Map> eliminarbanco(int ID) async {

    var url = "http://beta.flexirol.com/wp-json/flexirol/v1/borrar/2";
    var body = jsonEncode({ 'ID_post': ID});
    await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    ).then((http.Response response) {

      print(response.body);
      return { 'success': true, 'message': "borrado bien" };

    } );

  }
}

