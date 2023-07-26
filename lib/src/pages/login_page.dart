// @dart=2.9

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flexirol_app/src/bloc/provider.dart';
import 'package:flexirol_app/src/providers/usuario_provider.dart';
import 'package:flexirol_app/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flexirol_app/ProgressHUD.dart';
import 'package:async/async.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity/connectivity.dart';




class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

  final usuarioProvider = new UsuarioProvider();
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
   }
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: mainlogin(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget mainlogin(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            _crearFondo( context ),
            _loginForm( context ),
          ],
        )
    );
  }

  Widget _loginForm(BuildContext context) {

    final bloc = Provider.of(context);
    final _prefs = new PreferenciasUsuario();

    if (_prefs.token == "porborrar") {
      _prefs.token = "0";
      //     bloc.dispose() ;
      print("bloc en login");

      bloc.changeEmail("");
      bloc.changePassword("..");

      print(bloc.email);
      print(bloc.password);

      print("token final login");
      print(_prefs.token);
    }

    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(

        children: <Widget>[


          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),

          Container(

            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 80.0),
            padding: EdgeInsets.symmetric( vertical: 50.0 ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0
                  )
                ]
            ),
            child: Column(
              children: <Widget>[
                //  Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                //   SizedBox( height: 60.0 ),
                _crearEmail( bloc ),
                SizedBox( height: 30.0 ),
                _crearPassword( bloc ),
                SizedBox( height: 30.0 ),
                _crearBoton( bloc )
              ],
            ),
          ),

          RaisedButton(
            onPressed: () async {
              const url = 'http://beta.flexirol.com/password-reset/';

              if (await canLaunch(url)) {
                await launch(url, forceSafariVC: false);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text('Olvido la contraseña?', style: TextStyle(color: Colors.white),),
            color: Colors.grey,
          ),
          SizedBox( height: 100.0 )
        ],
      ),
    );
  }

  _launchURL() async {
    const url = 'http://beta.flexirol.com/password-reset/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }
  Widget _crearEmail(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),

          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            // initialValue: 'Ingrese su Usuario',
            decoration: InputDecoration(
                icon: Icon( Icons.alternate_email, color: Colors.cyan ),
                labelText: 'Nombre de usuario',
                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changeEmail,
          ),

        );


      },
    );


  }

  Widget _crearPassword(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),

          child: TextFormField(
            //    initialValue: '',
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon( Icons.lock_outline, color: Colors.cyan ),
                labelText: 'Contraseña',

                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changePassword,
          ),

        );

      },
    );


  }

  Widget _crearBoton( LoginBloc bloc) {

    // formValidStream
    // snapshot.hasData
    //  true ? algo si true : algo si false

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
              child: Text('Ingresar'),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)
            ),
            elevation: 0.0,
            color: Colors.cyan,
            textColor: Colors.white,
            onPressed: snapshot.hasData ? () => _login(bloc, context) : null,

        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    Loader.show(context, progressIndicator: LinearProgressIndicator());
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult == ConnectivityResult.mobile) || (connectivityResult == ConnectivityResult.wifi)){
      Map info = await usuarioProvider.login(bloc.email, bloc.password);
      print("info:");
      print(info);

      final prefs = new PreferenciasUsuario();
      print("token en el login:");
      print(prefs.token);

      prefs.password = bloc.password;

      if (prefs.token != "0") {
        Map personal = await usuarioProvider.personal();
        String bancaria = await usuarioProvider.bancaria();
        String solicitudes_todas = await usuarioProvider.solicitudes_todas();


        Loader.hide();
        Navigator.pushReplacementNamed(context, 'navigationbar');
        print(personal);
        print(bancaria);
        print(solicitudes_todas);
      } else {
        Loader.hide();

        mostrarAlerta(context, "Usuario no valido / Contraseña equivocada");
      }
    } else {
      Loader.hide();

      mostrarConexion(context, "No tiene conexión a internet");
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
                onPressed: ()=> Navigator.of(context).pop(),
              )
            ],
          );
        }
    );
  }
  void mostrarConexion(BuildContext context, String mensaje ) {

    showDialog(
        context: context,
        builder: ( context ) {
          return AlertDialog(
            title: Text('Error en la connexion'),
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
                child: Text('Ok',
                  style: TextStyle(color: Colors.white),),
                onPressed: ()=> Navigator.of(context).pop(),
              )
            ],

          );
        }
    );
  }


  Widget _crearFondo(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final fondoModaro = Container(
      height: size.height * 0.5,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: <Color> [
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


    return Stack(
      children: <Widget>[
        fondoModaro,
        Positioned( top: 90.0, left: 30.0, child: circulo ),
        Positioned( top: -40.0, right: -30.0, child: circulo ),
        Positioned( bottom: -50.0, right: -10.0, child: circulo ),
        Positioned( bottom: 120.0, right: 20.0, child: circulo ),
        Positioned( bottom: -50.0, left: -20.0, child: circulo ),

        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              SizedBox( height: 20.0, width: double.infinity ),
              Image(image: AssetImage("assets/images/logo.png")),
//              Icon( Icons.person_pin_circle, color: Colors.white, size: 100.0 ),
              SizedBox( height: 20.0, width: double.infinity ),
              Text('Bienvenido', style: TextStyle( color: Colors.white, fontSize: 25.0 ))
            ],
          ),
        )

      ],
    );

  }

}