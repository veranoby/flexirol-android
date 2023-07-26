// @dart=2.9

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flexirol_app/src/bloc/provider.dart';
import 'package:flexirol_app/src/providers/usuario_provider.dart';
import 'package:flexirol_app/src/bloc/login_bloc.dart';
import 'package:flexirol_app/ProgressHUD.dart';
import 'package:flexirol_app/main.dart';

import 'package:flexirol_app/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:intl/intl.dart';
import "dart:async";
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:connectivity/connectivity.dart';





class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final usuarioProvider = new UsuarioProvider();

  @override
  void dispose() {
    Loader.hide();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _prefs = new PreferenciasUsuario();
    Map myInfo = jsonDecode(_prefs.myInfo);
    //   var contador = int.parse(_prefs.id_temp);

    if (myInfo["gearbox"] == "false"){

      gearboxalerta(context, "Su cuenta se encuentra bloqueada");

    } else {

    final size = MediaQuery
        .of(context)
        .size;
    final fondoModaro = Container(
      height: size.height * 0.1,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[
                Color.fromRGBO(63, 120, 156, 0.6),
                Color.fromRGBO(60, 60, 128, 0.8)
              ]
          )
      ),
    );
    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.1)
      ),
    );
    return new Scaffold(
        extendBody: true,
        appBar: new AppBar(
          title: new Text('Bienvenido', textScaleFactor: 0.9,),
          textTheme: Theme
              .of(context)
              .textTheme
              .apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,

        )
        ,
        body: RefreshIndicator(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      fondoModaro,
                      Positioned(top: -40.0, right: -30.0, child: circulo),
                      Positioned(bottom: 120.0, right: 20.0, child: circulo),
                      Positioned(bottom: -50.0, left: -20.0, child: circulo),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Image(
                                image: AssetImage("assets/images/logo.png")),
                          ),
                          Expanded(
                            flex: 6,
                            child: ListTile(
                              title: Text(
                                " " + myInfo["first_name"].toUpperCase() + ' ' +
                                    myInfo["last_name"].toUpperCase(),
                                textScaleFactor: 1.15,
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    color: Colors.white),),
                              subtitle: Text(
                                myInfo["empresa_nombre"], textScaleFactor: 1.0,
                                style: TextStyle(fontWeight: FontWeight.normal,
                                    color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  new Expanded (
                    flex: 2,
                    child: mensage_plan(context),
                  ),
                  new Expanded (
                    flex: 4,
                    child: mensaje_saldo(context),
                  ),
                  ListTile(
                    title: Text('Solicitudes del Mes', textScaleFactor: 1.1,
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.cyan[900]),),
                    trailing: Icon(Icons.history, color: Colors.cyan[900],),
                  ),
                  new Expanded(
                    flex: 4,
                    child: saldodisponnible(context),
                  ),
                ]
            ),
            onRefresh: _refresh
        )
    );
  }
}
  Future<Null> _refresh() async {
    await usuarioProvider.personal();
    await usuarioProvider.bancaria();
    await usuarioProvider.solicitudes_todas();
    setState(() {});
  }
  logoutUser() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs?.clear();
    print("token limpio");

    final _prefs = new PreferenciasUsuario();
    _prefs.token = "porborrar";

    print(_prefs.token);

    Navigator.pushReplacementNamed(context, 'login');

  }
  void gearboxalerta(BuildContext context, String mensaje ) {

    showDialog(
        context: context,
        builder: ( context ) {
          return AlertDialog(
            title: Text('Su cuenta se encuentra bloqueada'),
            content: Text(mensaje),
            actions: <Widget>[
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  side: BorderSide(
                    width: 5.0,
                    color: Colors.cyan,
                    style: BorderStyle.solid,
                  ),
                ),
                //style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                //),
                child: Text('Ok',
                  style: TextStyle(color: Colors.white),),
                onPressed: logoutUser,
              )
            ],
          );
        }
    );
  }

  void mostrarAlerta(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Aun no esta disponible el servicio de solicitudes de Anticipos"),
            actions: <Widget>[
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  side: BorderSide(
                    width: 5.0,
                    color: Colors.blueAccent,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Text('Ok',
                  style: TextStyle(color: Colors.white),),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        }
    );
  }

  Widget mensaje_saldo(BuildContext context) {

    final _prefs = new PreferenciasUsuario();
    List solicitudesMapa = jsonDecode(_prefs.solicitudes_todas);
    Map myInfo = jsonDecode(_prefs.myInfo);

    final currDt = DateTime.now();
    final dd = (currDt.day); // 2
    final mm = (currDt.month); // 2
    final yy = (currDt.year); // 2

    print("year");
    print(yy);

    final dd_final = int.parse(myInfo["dia_cierre"]) - int.parse(myInfo["dia_bloqueo"]) ;
    final dd_inicio = int.parse(myInfo["dia_inicio"]) + int.parse(myInfo["dia_bloqueo"]) ;

    _prefs.permiso_solicitudes = "si";

    print("largosolicitudes");
print(solicitudesMapa[0]["post_date"]);

//CHEQUEO SI SUPERO NUMERO MAXIUMO DE SOLICXITUDES
    if (_prefs.permiso_solicitudes == "si") {
      if (solicitudesMapa.length >= int.parse(myInfo["frecuencia"])) {
        _prefs.mensaje_bloqueo_1 = 'Ha alcanzado el limite de solicitudes';
        _prefs.mensaje_bloqueo_2 = '(solicitudes permitidas:' + myInfo["frecuencia"] + ')';
        _prefs.permiso_solicitudes = "no";
      }
    }

//CHEQUEO SI AUN PUEDE SOLICITAR ANTICIPOS
    if (_prefs.permiso_solicitudes == "si") {
      if (dd > dd_final) {
        _prefs.mensaje_bloqueo_1 = 'Ha superado el ultimo dia disponible para solicitar Anticipos';
        _prefs.mensaje_bloqueo_2 = '(fecha limite de solicitud: ' + dd_final.toString() + ' de este mes)';
        _prefs.permiso_solicitudes = "no";
      }
      if (dd < dd_inicio) {
        _prefs.mensaje_bloqueo_1 = 'Aun no esta disponible el servicio de solicitudes de Anticipos ';
        _prefs.mensaje_bloqueo_2 = '(fecha de inicio: ' + dd_inicio.toString() + ' de este mes)';
        _prefs.permiso_solicitudes = "no";
      }
    }

//CHEQUEO FECHA EXCEL
    if (_prefs.permiso_solicitudes == "si"){
      if ((myInfo["frecuencia"] ==null || myInfo["frecuencia"] =='No creado')) {
        _prefs.mensaje_bloqueo_1 = 'Usuario Bloqueado! Su Empresa no ha cargado sus Datos actualizados de Anticipos' ;
        _prefs.mensaje_bloqueo_2 = ' - Por favor comuniquese con su empresa para normalizar su estado..' ;
        _prefs.permiso_solicitudes = "no";
      }
    }

    //CHEQUEO SI HAY ANTICIPOS ACTIVOS
    if (_prefs.permiso_solicitudes == "si" && solicitudesMapa[0]["post_date"]!= null){
      for (var i = 0; i < solicitudesMapa.length; i++) {
        var str = solicitudesMapa[i]["post_date"];
        var res = str.split("/");

        if ( (int.parse(res[0]) + int.parse(myInfo["dia_reinicio"])) > dd ){
          var dia_reinicio = (int.parse(res[0]) + int.parse(myInfo["dia_reinicio"]));
          _prefs.mensaje_bloqueo_1 = 'Solicitud en proceso.' ;
          _prefs.mensaje_bloqueo_2 = 'Se esta trabajando en su solicitud, pronto podra volver a solicitar un nuevo anticipo\n(dias restantes: ' + ( dia_reinicio - dd ).toString() + ')' ;
          _prefs.permiso_solicitudes = "no";
        }
      }
    }

//CHEQUEO FECHA EXCEL
    if (_prefs.permiso_solicitudes == "si" ){


      var arr = myInfo["fecha_excel"].split('/');

      final post_nuevo = arr[2] + "-" + arr[1].toString().padLeft(2, '0') + "-" + arr[0].toString().padLeft(2, '0') ;

      var parsedDate = DateTime.parse(post_nuevo);
      print("diferencia fechas en dias1");
      print(parsedDate);

      var temp = new DateTime(yy, mm - 1, int.parse(myInfo["dia_cierre"]));
      print(temp);

      var dias = ((temp.difference(parsedDate) - Duration(hours: temp.hour) + Duration(hours: parsedDate.hour)).inHours / 24).round();
      print("diferencia fechas en dias2");
      print(dias);

      if (dias > 0) {
        _prefs.mensaje_bloqueo_1 = 'Su Empresa no ha cargado sus Datos actualizados de Anticipos! ' ;
        _prefs.mensaje_bloqueo_2 = '(ultima actualizacion:'+myInfo["fecha_excel"]+') - Ha sido bloqueado. Por favor comuniquese con su empresa para normalizar su estado..' ;
        _prefs.permiso_solicitudes = "no";
      }
    }


      //CALCULO DE SALDO DISPONIBLE
    if (      _prefs.permiso_solicitudes == "si" ) {
      final dd_final = int.parse(myInfo["dia_cierre"]) -
          int.parse(myInfo["dia_inicio"]);
      final valor_diario = ((int.parse(myInfo["disponible"]) *
          int.parse(myInfo["porcentaje"]) / 100) / dd_final);

      String solicitudes_previas = "0";

if (solicitudesMapa[0]["post_date"]!= null) {
  for (var i = 0; i < solicitudesMapa.length; i++) {
    solicitudes_previas =
        (double.parse(solicitudesMapa[i]["post_excerpt"]) +
            double.parse(solicitudesMapa[i]["gearbox"]) +
            double.parse(solicitudes_previas)).toString();
  }
}
      final valor_disponible_total = (((valor_diario) * (dd)) -
          double.parse(solicitudes_previas)).toStringAsFixed(2);

      print("dias valor_disponible_total");
      print(valor_disponible_total);
      _prefs.valor_disponible_total = valor_disponible_total;
      _prefs.mensaje_bloqueo_1 = "Saldo Disponible " + _prefs.valor_disponible_total + "dolares" ;
      _prefs.mensaje_bloqueo_2 = "Disponible actualmente para Usted!";

    }
//FIN CALCULO DISPONIBLE TOTAL


//RETORNO DE WIDGET DEPENDIENDO SI _prefs.permiso_solicitudes = "no";

if ( _prefs.permiso_solicitudes == "si") {
  var mensaje_bloqueo_1 = "Saldo Disponible: \$" + _prefs.valor_disponible_total + " dolares" ;
  var mensaje_bloqueo_2 = "Disponible actualmente para solicitar Anticipos!";
  ScrollController _controller = new ScrollController();

  return ListView(
    physics: const AlwaysScrollableScrollPhysics(), // new
    controller: _controller,
      children: <Widget>[
        Container(
        child:
          ListTile(
          trailing: Icon(Icons.monetization_on_outlined, color: Colors.green, size: 40,),
          dense: true,
          title: Text(mensaje_bloqueo_1,
            textScaleFactor: 1.45,
            style: TextStyle(fontWeight: FontWeight.bold,
                color: Colors.green),),
          subtitle: Text(mensaje_bloqueo_2,
            textScaleFactor: 1.20,
            style: TextStyle(fontWeight: FontWeight.normal,
                color: Colors.green),),
        ),
       ),
        SizedBox(height: 5,),
        FloatingActionButton(
          onPressed: () async {
    if ((myInfo["flexirol4"] == "si" && myInfo["flexirol3"] == "2") || (myInfo["flexirol3"] == "1") ){
            Navigator.push(context, MaterialPageRoute(builder: (context) => FormSaldoDisponible())).then((value) {
              setState(() {
                // refresh state of Page1
              });
            });        // Add your onPressed code here!
          } else {
      plan_no_activo(context);
          }},
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ],

    );

}   else {
 // var mensaje_bloqueo_1 = 'Aun no esta disponible el servicio de solicitudes de Anticipos ';
 // var mensaje_bloqueo_2 = '';
  ScrollController _controller = new ScrollController();

  return ListView(
    physics: const AlwaysScrollableScrollPhysics(), // new
    controller: _controller,
    children: <Widget>[
      Container(
        color: Colors.amber[50],
        child:
        ListTile(
          trailing: Icon(Icons.warning, color: Colors.yellow[800],),
          dense: true,
          title: Text(_prefs.mensaje_bloqueo_1,
            textScaleFactor: 1.45,
            style: TextStyle(fontWeight: FontWeight.bold,
                color: Colors.yellow[800]),),
          subtitle: Text(_prefs.mensaje_bloqueo_2,
            textScaleFactor: 1.20,
            style: TextStyle(fontWeight: FontWeight.normal,
                color: Colors.yellow[800]),),
        ),
      ),
      SizedBox(height: 5,),
    ],

  );
}



          }


  }

  Widget saldodisponnible(BuildContext context) {
    final _prefs = new PreferenciasUsuario();
    List solicitudesMapa = jsonDecode(_prefs.solicitudes_todas);

    if (solicitudesMapa[0]["mensaje"] == "no hay"){
      return Column(
          children: <Widget>[
            Image(image: AssetImage("assets/images/oops.png")),
            ListTile(
              title: Text("No hay Solicitudes registradas, por favor cree una."),
            )
          ]
      );
    } else {
      print(solicitudesMapa);
      return ListView.builder(
          itemCount: solicitudesMapa.length,
          itemBuilder: (context, index) {
            return
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                        trailing: Icon(Icons.keyboard_arrow_right),
                        dense: true,
                        title: Text("Fecha: " + solicitudesMapa[index]["post_date"],
                          textScaleFactor: 1.05,
                          style: TextStyle(fontWeight: FontWeight.normal,
                              color: Colors.black),),
                        subtitle: Text(solicitudesMapa[index]["post_title"],
                          textScaleFactor: 1.05,
                          style: TextStyle(fontWeight: FontWeight.normal,
                              color: Colors.black),),
                        onTap: () async {
                          _prefs.id_temp = index.toString();
                          print("id temporal");
                          print(_prefs.id_temp);
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => ver_solicitud2()),
                          );
                        }
                    ),
                    widget_status(solicitudesMapa[index]["tag"]),
                  ],


                ),
              );
          }
      );

    }
  }

  Widget mensage_plan(BuildContext context){
    final _prefs = new PreferenciasUsuario();
    List solicitudesMapa = jsonDecode(_prefs.solicitudes_todas);
    Map myInfo = jsonDecode(_prefs.myInfo);
    print(myInfo["flexirol3"]);
    print("mensage_plan" + myInfo["flexirol3"]);

    if (myInfo["flexirol3"] == "1"){
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.cyan[50],
          ),
          child:
            ListTile(
              dense: true,
              title: Text("Plan seleccionado actual: Porcentaje sobre la transaccion" + " " + myInfo["flexirol"] + "% (+IVA)" ,
                textScaleFactor: 1.2,
                style: TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.grey[600]),
            ),
          ));

    }  else {
      if (myInfo["flexirol4"] == "no"){
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.red[50],
          ),
          child:
          ListTile(
            dense: true,
            title: Text("Plan seleccionado actual: Valor fijo mensual" + " " + "\$" + myInfo["flexirol2"]  + "(+IVA)",
              textScaleFactor: 1.1,
              style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),),
            subtitle: Row(
                children: <Widget>[
                  Text("Su plan no esta activo ",
                   textScaleFactor: 1.2,
                   style: TextStyle(fontWeight: FontWeight.bold,
                   color: Colors.red),),
                  RaisedButton(
                    color: Colors.white,
                      child: Text('Activar plan', style: TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),),
                      onPressed: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => alertaactivar())
                        );}                  ),
                ])
          ),
        );
      } else {
        if (solicitudesMapa[0]["mensaje"] == "no hay") {
          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.cyan[50],
              ),
              child:
              ListTile(
                  dense: true,
                  title: Text("Plan seleccionado actual: Valor fijo mensual " + " " + "\$" + myInfo["flexirol2"]  + "(+IVA)",
                    textScaleFactor: 1.1,
                    style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),
                  subtitle: Row(
                      children: <Widget>[
                        Text("Su plan esta activo ",
                          textScaleFactor: 1.2,
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: Colors.lightGreen),),
                        RaisedButton(
                            color: Colors.white,
                            child: Text('Cancelar plan', style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.grey[600]),),
                            onPressed: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => alertacancelar()),
                              );}
                        ),
                      ])

              ));
        } else {
          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.cyan[50],
              ),
              child:
              ListTile(
                  dense: true,
                  title: Text("Plan seleccionado actual: Valor fijo mensual " + " " + "\$" + myInfo["flexirol2"] + "(+IVA)",
                    textScaleFactor: 1.1,
                    style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),
                  subtitle: Row(
                      children: <Widget>[
                        Text("Su plan esta activo ",
                          textScaleFactor: 1.2,
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: Colors.lightGreen),),
                      ])

              ));
        }

      }
    }

  }
  class alertaactivar extends StatefulWidget {
    @override
    _alertaactivarState createState() => _alertaactivarState();
  }

  class _alertaactivarState extends State<alertaactivar> {

    final usuarioProvider = new UsuarioProvider();
    bool isApiCallProcess = false;
    @override
    void initState() {
      super.initState();
    }
    @override
    Widget build(BuildContext context) {
      return ProgressHUD(
        child: FormPasswordLogic(context),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      );
    }

    Widget FormPasswordLogic(BuildContext context) {
      return Scaffold(
          appBar: new AppBar(
            title: new Text('Confimar la activacion de su plan?', textScaleFactor: 1,),
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
            centerTitle: true,
            backgroundColor: Colors.green,
          ),
          body: Stack(
            children: <Widget>[
              _saldoForm(context),
            ],
          )
      );
    }

    Widget _saldoForm(BuildContext context) {
      final usuarioProvider = new UsuarioProvider();
      final _prefs = new PreferenciasUsuario();
      Map myInfo = jsonDecode(_prefs.myInfo);

      return ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            padding: EdgeInsets.symmetric( vertical: 10.0, horizontal: 10.0 ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              children: <Widget>[
                Text("Se cobrara el valor al final del ciclo de pago.\nNo podra cancelar la suscripcion hasta el inicio del siguiente ciclo de pago.\nValor mensual del plan:"  + " " + "\$" + myInfo["flexirol2"] + ".\n \n",textScaleFactor: 0.95,),

                  FlatButton(
                      color: Colors.green,
                      child: Text('Confirmar',style: TextStyle(
                          color: Colors.white),),
                      onPressed: () async {
                        Loader.show(context,progressIndicator:LinearProgressIndicator());
                        var connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile) {

                        await usuarioProvider.manejar_plan("on");
                        await usuarioProvider.personal();
                        await usuarioProvider.bancaria();
                        await usuarioProvider.solicitudes_todas();
                        Loader.hide();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyBottomNavigationBar()),
                              (Route<dynamic> route) => false,
                        );
                        activar_mensaje(context);

                        } else if (connectivityResult == ConnectivityResult.wifi) {

                          await usuarioProvider.manejar_plan("on");
                          await usuarioProvider.personal();
                          await usuarioProvider.bancaria();
                          await usuarioProvider.solicitudes_todas();
                          Loader.hide();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyBottomNavigationBar()),
                                (Route<dynamic> route) => false,
                          );
                          activar_mensaje(context);
                        } else {
                          Loader.hide();
                          mostrarConexion(context, "No tiene conexión a internet");
                        }
                      }
                  ),
                ],
            ),
          ),
        ],
      );
    }
  }
void mostrarConexion(BuildContext context, String mensaje ) {

  showDialog(
      context: context,
      builder: ( context ) {
        return AlertDialog(
          title: Text('Error en la conexion'),
          content: Text(mensaje),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                side: BorderSide(
                  width: 5.0,
                  color: Colors.blueAccent,
                  style: BorderStyle.solid,
                ),
              ),
              child: Text('Ok',
                style: TextStyle(color: Colors.white),),
              onPressed: ()=> Navigator.of(context).pop(),
            )
          ],

        );
      }
  );
}
  class alertacancelar extends StatefulWidget {
    @override
    _alertacancelarState createState() => _alertacancelarState();
  }

  class _alertacancelarState extends State<alertacancelar> {

    final usuarioProvider = new UsuarioProvider();
    bool isApiCallProcess = false;
    @override
    void initState() {
      super.initState();
    }
    @override
    Widget build(BuildContext context) {
      return ProgressHUD(
        child: FormPasswordLogic(context),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      );
    }

    Widget FormPasswordLogic(BuildContext context) {
      return Scaffold(
          appBar: new AppBar(
            title: new Text('Confimar la cancelacion de su plan?', textScaleFactor: 1,),
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
            centerTitle: true,
            backgroundColor: Colors.redAccent,
          ),
          body: Stack(
            children: <Widget>[
              _saldoForm(context),
            ],
          )
      );
    }

    Widget _saldoForm(BuildContext context) {
      final usuarioProvider = new UsuarioProvider();
      final _prefs = new PreferenciasUsuario();
      Map myInfo = jsonDecode(_prefs.myInfo);

      return ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            padding: EdgeInsets.symmetric( vertical: 10.0, horizontal: 10.0 ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              children: <Widget>[
                Text("Esta seguro de que quiere cancelar su plan?\nNo podra volver a solicitar anticipos hasta activar su plan. \n"),
                FlatButton(
                    color: Colors.redAccent,
                    child: Text('Cancelar suscripcion',style: TextStyle(
                        color: Colors.white),),
                    onPressed: () async {
                      Loader.show(context,progressIndicator:LinearProgressIndicator());
                      var connectivityResult = await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile) {
                      await usuarioProvider.manejar_plan("off");
                      await usuarioProvider.personal();
                      await usuarioProvider.bancaria();
                      await usuarioProvider.solicitudes_todas();
                      Loader.hide();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyBottomNavigationBar()),
                            (Route<dynamic> route) => false,
                      );
                      cancelar_mensaje(context);
      } else if (connectivityResult == ConnectivityResult.wifi) {
                        await usuarioProvider.manejar_plan("off");
                        await usuarioProvider.personal();
                        await usuarioProvider.bancaria();
                        await usuarioProvider.solicitudes_todas();
                        Loader.hide();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyBottomNavigationBar()),
                              (Route<dynamic> route) => false,
                        );
                        cancelar_mensaje(context);
                      } else {
                        Loader.hide();

                        mostrarConexion(context, "No tiene conexión a internet");
                      }
      }
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
void mostrarAlerta(BuildContext context, String mensaje ) {

  showDialog(
      context: context,
      builder: ( context ) {
        return AlertDialog(
          title: Text('Información incorrecta'),
          content: Text(mensaje),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                side: BorderSide(
                  width: 5.0,
                  color: Colors.blueAccent,
                  style: BorderStyle.solid,
                ),
              ),
              //style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
              //),
              child: Text('Ok',
                style: TextStyle(color: Colors.white),),
              onPressed: ()=> Navigator.of(context).pop(),
            )
          ],
        );
      }
  );
}
void activar_mensaje(BuildContext context) {

  showDialog(
      context: context,
      builder: ( context ) {
        return AlertDialog(
          content: Text("Su plan se ha activado con exito"),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                side: BorderSide(
                  width: 5.0,
                  color: Colors.blueAccent,
                  style: BorderStyle.solid,
                ),
              ),
              //style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
              //),
              child: Text('Ok',
                style: TextStyle(color: Colors.white),),
              onPressed: ()=> Navigator.of(context).pop(),
            )
          ],
        );
      }
  );
}
void cancelar_mensaje(BuildContext context) {

  showDialog(
      context: context,
      builder: ( context ) {
        return AlertDialog(
          content: Text("Su plan se ha cancelado con exito"),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                side: BorderSide(
                  width: 5.0,
                  color: Colors.blueAccent,
                  style: BorderStyle.solid,
                ),
              ),
              //style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
              //),
              child: Text('Ok',
                style: TextStyle(color: Colors.white),),
              onPressed: ()=> Navigator.of(context).pop(),
            )
          ],
        );
      }
  );
}

void alerta_cancelar_no (BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("No puede cancelar su plan despues de realizar un anticipo." ),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                side: BorderSide(
                  width: 5.0,
                  color: Colors.blueAccent,
                  style: BorderStyle.solid,
                ),
              ),
              //style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
              //),
              child: Text('Aceptar',
                style: TextStyle(color: Colors.white),),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      }
  );
}
void plan_no_activo (BuildContext context) {
  final _prefs = new PreferenciasUsuario();
  Map myInfo = jsonDecode(_prefs.myInfo);
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Alerta"),
          content: Text("Su plan necesita estar activo para poder solicitar anticipos."),
          actions: <Widget>[
            FlatButton(
              child: Text('Aceptar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      }
  );
}

class ver_solicitud2 extends StatefulWidget {
  @override
  _ver_solicitud2State createState() => _ver_solicitud2State();
}

class _ver_solicitud2State extends State<ver_solicitud2> {
  final usuarioProvider = new UsuarioProvider();
  bool isApiCallProcess = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: versolicitudLogic(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );

  }
  Widget versolicitudLogic(BuildContext context){

    final _prefs = new PreferenciasUsuario();
    var contador = int.parse(_prefs.id_temp);

    List solicitudMapa1 = jsonDecode(_prefs.solicitudes_todas);
    Map solicitudMapa2 = solicitudMapa1[contador];

    var arr = (solicitudMapa2["post_content"]).split('<br>');
 //   String post_nuevo = arr[0] + "-" + arr[1] + "-" + arr[2] ;



    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Datos de la solicitud', textScaleFactor: 1,),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(2),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.account_circle, size: 35,),
            title: Text(arr[0], textScaleFactor: 1.00, style: TextStyle(fontWeight: FontWeight.normal),),
            subtitle: Text(arr[1], textScaleFactor: 1.00, style: TextStyle(fontWeight: FontWeight.normal , color: Colors.grey),),
          ),
          ListTile(
            leading: Icon(Icons.business, size: 35,),
            title: Text("Banco " + arr[2], textScaleFactor: 1.00, style: TextStyle(fontWeight: FontWeight.normal),),
            subtitle: Text(arr[3], textScaleFactor: 1.00, style: TextStyle(fontWeight: FontWeight.normal , color: Colors.grey),),
          ),
          widget_status(solicitudMapa2["tag"]),
        ],
      ),
    );
  }

  void mostrarAlerta(BuildContext context, String mensaje ) {

    showDialog(
        context: context,
        builder: ( context ) {
          return AlertDialog(
            // title: Text('Error al modificar la cuenta'),
            content: Text(mensaje),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: ()=> Navigator.of(context).pop(),
              )
            ],
          );
        }
    );
  }

}

Widget widget_status(String post_modified) {

  if (post_modified == "procesado"){
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 4.0, 0.0),
      title: Text("Estado: " + post_modified + "!", textScaleFactor: 0.9, style: TextStyle(
          background: Paint()
            ..strokeWidth = 15.0
            ..color = Colors.teal[50]
            ..style = PaintingStyle.stroke
            ..strokeJoin = StrokeJoin.round
          , fontWeight: FontWeight.bold, color: Colors.green[800]),),
    );  }

  if (post_modified == "pendiente"){
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 4.0, 0.0),
      title: Text("Estado: " + post_modified, textScaleFactor: 0.9, style: TextStyle(
          background: Paint()
            ..strokeWidth = 15.0
            ..color = Colors.amber[50]
            ..style = PaintingStyle.stroke
            ..strokeJoin = StrokeJoin.round
          , fontWeight: FontWeight.bold, color: Colors.yellow[800]),),
    );  }

  if (post_modified == "procesando"){
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 4.0, 0.0),
      title: Text("Estado: " + post_modified, textScaleFactor: 0.9, style: TextStyle(
          background: Paint()
            ..strokeWidth = 15.0
            ..color = Colors.blue[50]
            ..style = PaintingStyle.stroke
            ..strokeJoin = StrokeJoin.round
          , fontWeight: FontWeight.bold, color: Colors.blue[400]),),
    );  }


}

class FormSaldoDisponible extends StatefulWidget {
  @override
  _FormSaldoDisponibleState createState() => _FormSaldoDisponibleState();
}

class _FormSaldoDisponibleState extends State<FormSaldoDisponible> {

  final usuarioProvider = new UsuarioProvider();
  bool isApiCallProcess = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: FormPasswordLogic(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget FormPasswordLogic(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Solicitar Anticipo', textScaleFactor: 1,),
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: Stack(
          children: <Widget>[
            _saldoForm(context),
          ],
        )
    );
  }

  Widget _saldoForm(BuildContext context) {

    final bloc = Provider.saldoBloc(context);
    final size = MediaQuery.of(context).size;
    final _prefs = new PreferenciasUsuario();


    return ListView(
      children: <Widget>[
        Container(
          width: size.width * 0.85,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.symmetric( vertical: 25.0 ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: <Widget>[
                Text('Saldo Disponible: \$' + _prefs.valor_disponible_total + " dolares", style: TextStyle(fontSize: 18.0 , color: Colors.lightGreen)),
                 SizedBox( height: 20.0 ),
              _crearsaldodisponible( bloc ),
              SizedBox( height: 20.0 ),
              _crearbanco( bloc ),
              SizedBox( height: 20.0 ),
              _crearBoton( bloc ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _crearsaldodisponible(SaldoBloc bloc) {

    return StreamBuilder(
      stream: bloc.DisponibleStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            obscureText: false,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.monetization_on),
                labelText: 'Cantidad a Anticiparse',
                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changeDisponible,
          ),
        );
      },
    );
  }



  Widget _crearbanco(SaldoBloc bloc) {

    final _prefs = new PreferenciasUsuario();
    List bancoMapa1 = jsonDecode(_prefs.bancaria);

    print(bancoMapa1);

    return StreamBuilder(
      stream: bloc.BancoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child:
          new DropdownButtonFormField<String>(
              onChanged: (valor) {
                bloc.changeBanco(valor) ;
                print(bloc.Banco);
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.business),
                hintText: 'Seleccione Cuenta',
                filled: true,
                fillColor: Colors.white,
                errorStyle: TextStyle(color: Colors.yellow),
              ),
              items: bancoMapa1.map((map) {
                return DropdownMenuItem(
                  child: Text(map['post_banco'].toString() + " - " + map['gearbox'].toString() + " " + map['numero_cuenta'].toString()),
                  value: map['ID'].toString() + '*' + map['post_banco'].toString() + ' - Cuenta ' + map['gearbox'].toString() + ': ' + map['numero_cuenta'].toString()  + '<br>Nombre: ' + map['post_excerpt'].toString() + ' - Cedula: ' + map['post_content'].toString() + ' - ' + map['user_email'].toString(),
                );
              }).toList()),
        );
      },
    );
  }



    Widget _crearBoton( SaldoBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
            child: Text('Solicitar adelanto'),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: () {
            alertadashboard(bloc, context);
          }
        );
      },
    );
  }
  Widget alertadashboard(SaldoBloc bloc, BuildContext context) {
    final usuarioProvider = new UsuarioProvider();
    final _prefs = new PreferenciasUsuario();
    Map myInfo = jsonDecode(_prefs.myInfo);

    var disponible = bloc.Disponible;
    double total = 0;
    var porcentaje = "0";

   if (myInfo["flexirol3"] == "1" ){
      porcentaje = (double.parse(disponible) * double.parse(myInfo["flexirol"]) / 100).toStringAsFixed(2);
      total = double.parse(disponible) + double.parse(porcentaje) ;
   } else {
      total = double.parse(disponible) + double.parse(porcentaje) ;
   }


    if (total > double.parse(_prefs.valor_disponible_total) ) {

      if (myInfo["flexirol3"] == "1" ){
        porcentaje = (double.parse(_prefs.valor_disponible_total) * double.parse(myInfo["flexirol"]) / 100).toStringAsFixed(2);
      }

       total =  double.parse(_prefs.valor_disponible_total) ;
       disponible = (total - double.parse(porcentaje)).toString();

       bloc.changeDisponible(disponible);

       print("disponible");
       print(disponible);
       print(bloc.Disponible);

    }

    showDialog(
        context: context,
        builder: ( context ) {
          if(myInfo["flexirol3"] == "1"){

            return AlertDialog(
              title: Text('Confirmar Anticipo de \$$disponible !'),
              content:
              new Row(
                children: [
                  new Expanded(
                    child: new  Text("Costo del servicio: \$$porcentaje\nTotal a descontarse de su salario: \$$total"),
                  ) ,
                ],
              ),

              actions: <Widget>[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    side: BorderSide(
                      width: 5.0,
                      color: Colors.blueAccent,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Text('Si',
                    style: TextStyle(color: Colors.white),),
                  onPressed: () async {
                  var connectivityResult = await (Connectivity().checkConnectivity());
                  Loader.show(context,progressIndicator:LinearProgressIndicator());
                  if (connectivityResult == ConnectivityResult.mobile) {


                    await usuarioProvider.solicitudes_crear(bloc.Disponible , bloc.Banco);
                    await usuarioProvider.solicitudes_todas();
                    Loader.hide();

                    Navigator.pop(context);
                    Navigator.pop(context);
                    mostrarAlerta(context);

          } else if (connectivityResult == ConnectivityResult.wifi) {
                    await usuarioProvider.solicitudes_crear(bloc.Disponible , bloc.Banco);
                    await usuarioProvider.solicitudes_todas();
                    Loader.hide();

                    Navigator.pop(context);
                    Navigator.pop(context);
                    mostrarAlerta(context);
          } else {
            Loader.hide();

            mostrarConexion(context, "No tiene conexión a internet");
          }
                  },
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    side: BorderSide(
                      width: 5.0,
                      color: Colors.blueAccent,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Text('No',
                    style: TextStyle(color: Colors.white),),

                  onPressed: ()=> Navigator.of(context).pop(),
                ),
              ],
            );
          } else {

            return AlertDialog(
             title: Text('Confirmar Anticipo de \$$disponible !'),
            content:
            new Row(
              children: [
                  new Expanded(
                    child: new  Text("Total a descontarse de su salario: \$$total \n(El plan mensual se descontara al final del mes)", style: TextStyle(fontSize: 12.0 , color: Colors.redAccent)),
                  ) ,
              ],
            ),

            actions: <Widget>[
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  side: BorderSide(
                    width: 5.0,
                    color: Colors.blueAccent,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Text('Si', style: TextStyle(color: Colors.white),),
                onPressed: () async {
                  var connectivityResult = await (Connectivity()
                      .checkConnectivity());
                  Loader.show(
                      context, progressIndicator: LinearProgressIndicator());
                  if (connectivityResult == ConnectivityResult.mobile) {
                    await usuarioProvider.solicitudes_crear(
                        bloc.Disponible, bloc.Banco);
                    await usuarioProvider.solicitudes_todas();
                    Loader.hide();
                    Navigator.pop(context);
                    Navigator.pop(context);
                    mostrarAlerta(context);
                  } else if (connectivityResult == ConnectivityResult.wifi) {
                    await usuarioProvider.solicitudes_crear(
                        bloc.Disponible, bloc.Banco);
                    await usuarioProvider.solicitudes_todas();
                    Loader.hide();
                    Navigator.pop(context);
                    Navigator.pop(context);
                    mostrarAlerta(context);
                  } else {
                    Loader.hide();

                    mostrarConexion(context, "No tiene conexión a internet");
                  }
                }),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  side: BorderSide(
                    width: 5.0,
                    color: Colors.blueAccent,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Text('No',
                  style: TextStyle(color: Colors.white),),

                onPressed: ()=> Navigator.of(context).pop(),
              ),
            ],
          );}
        }
    );
  }
  void mostrarConexion(BuildContext context, String mensaje ) {

    showDialog(
        context: context,
        builder: ( context ) {
          return AlertDialog(
            title: Text('Error en la conexion'),
            content: Text(mensaje),
            actions: <Widget>[
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  side: BorderSide(
                    width: 5.0,
                    color: Colors.blueAccent,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Text('Ok',
                  style: TextStyle(color: Colors.white),),
                onPressed: ()=> Navigator.of(context).pop(),
              )
            ],

          );
        }
    );
  }
  void mostrarAlerta(BuildContext context) {

    showDialog(
        context: context,
        builder: ( context ) {
          return AlertDialog(
            // title: Text('Error al modificar la cuenta'),
            content: Text("Anticipo realizado con exito"),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: ()=> Navigator.of(context).pop(),
              )
            ],
          );
        }
    );
  }
}
