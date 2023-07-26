// @dart=2.9
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flexirol_app/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flexirol_app/src/bloc/provider.dart';
import 'package:flexirol_app/src/providers/usuario_provider.dart';
import 'package:flexirol_app/src/bloc/login_bloc.dart';
import 'package:flexirol_app/ProgressHUD.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart' as intl;
import 'package:connectivity/connectivity.dart';


class Usuario extends StatefulWidget {

  @override
  _UsuarioState createState() => _UsuarioState();
}

class _UsuarioState extends State<Usuario> {

  @override
  void dispose() {
    Loader.hide();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final _prefs = new PreferenciasUsuario();
    Map myInfo = jsonDecode(_prefs.myInfo);

    print("myInfo cuenta:");
    print(myInfo);

    final size = MediaQuery.of(context).size;

    final fondoModaro = Container(
      height: size.height * 0.1,
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

    return new Scaffold(
      appBar: AppBar(
        title: new Text('Mi Perfil', textScaleFactor: 1,),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(1),
                child: Text("Salir"),
              ),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: logoutUser,
              ),
            ],
          )
        ],
      ),
    body:

    new ListView(
      //padding: const EdgeInsets.all(2),
      children: <Widget>[

    Stack(
    children: <Widget>[
      fondoModaro,
      Positioned( top: -40.0, right: -30.0, child: circulo ),
      Positioned( bottom: 120.0, right: 20.0, child: circulo ),
      Positioned( bottom: -50.0, left: -20.0, child: circulo ),
      ListTile(
    //tileColor: Colors.cyan,
            leading: Icon(Icons.account_circle, size: 40, color: Colors.white,),
            title: Text("Nombre: " + myInfo["first_name"].toUpperCase() + ' ' + myInfo["last_name"].toUpperCase(), textScaleFactor: 1.05,  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
            subtitle: Text("Cedula " + myInfo["cedula"], textScaleFactor: 1.15, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),),
 ),
  ],
    ),
        Container(
          padding: const EdgeInsets.all(10.0),
          height: 35,
          child: Text('Contacto:', textScaleFactor: 1.10, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan[900]),),
        ),
        Card(
          child: ListTile(
            dense: true,
            title: Text('Correo electronico', textScaleFactor: 1.00, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),),
            subtitle: Text(myInfo["user_email"], textScaleFactor: 1.15, style: TextStyle(fontWeight: FontWeight.bold),),          ),
        ),
        Card(
          child: ListTile(
            dense: true,
            title: Text('Numero de telefono', textScaleFactor: 1.00, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),),
            subtitle: Text(myInfo["phone_number"], textScaleFactor: 1.15, style: TextStyle(fontWeight: FontWeight.bold),),          ),
        ),
    /*    Card(
          child: ListTile(
            dense: true,
            title: Text('Fecha de nacimiento', textScaleFactor: 1.00, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),),
            subtitle: Text(myInfo["birth_date"], textScaleFactor: 1.15, style: TextStyle(fontWeight: FontWeight.bold),),          ),
        ),*/
        Container(
          padding: const EdgeInsets.all(10.0),
          height: 35,
          child: Text('Ubicacion:', textScaleFactor: 1.10, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan[900]),),
        ),
        Card(
          child: ListTile(
            dense: true,
            title: Text('Ciudad', textScaleFactor: 1.00, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),),
            subtitle: Text(myInfo["city"], textScaleFactor: 1.15, style: TextStyle(fontWeight: FontWeight.bold),),          ),
        ),
        Card(
          child: ListTile(
            dense: true,
            title: Text('Direccion', textScaleFactor: 1.00, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),),
            subtitle: Text(myInfo["address"], textScaleFactor: 1.15, style: TextStyle(fontWeight: FontWeight.bold),),
          ),
        ),
        RaisedButton(
          onPressed: () async {

            final bloc = Provider.usuarioformBloc(context);
            final _prefs = new PreferenciasUsuario();
            Map myInfo = jsonDecode(_prefs.myInfo);

    bloc.changeName(myInfo["first_name"]);
    bloc.changeSecondname(myInfo["last_name"]);
    bloc.changeEmailusuario(myInfo["user_email"]);
    bloc.changeTele(myInfo["phone_number"]);
    bloc.changeFecha(myInfo["birth_date"]);
    bloc.changeCiudad(myInfo["city"]);
    bloc.changeCiudad(myInfo["city"]);
    bloc.changeDirec(myInfo["address"]);

    print("bloc.last_name");
    print(bloc.Secondname);

            Navigator.push(context, MaterialPageRoute(builder: (context) => FormUsuario())).then((value) {
              setState(() {
                // refresh state of Page1
              });
            });       // Add your onPressed code here!
          },
          child: const Text('Modificar Cuenta'),
          color: Colors.blueAccent,
          textColor: Colors.white,
        ),
        RaisedButton(
          onPressed: () async {
           await Navigator.push(context, MaterialPageRoute(builder: (context) => Formpassword()),
            );          // Add your onPressed code here!
          },
          child: const Text('Cambiar Contraseña'),
          color: Colors.blueAccent,
          textColor: Colors.white,

        ),

      ],



    ),

    );

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


}

class FormUsuario extends StatefulWidget {
  @override
  _FormUsuarioState createState() => new _FormUsuarioState();
}

class _FormUsuarioState extends State<FormUsuario> {

  final usuarioProvider = new UsuarioProvider();
  bool isApiCallProcess = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: FormUsuarioLogic(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget FormUsuarioLogic(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Modificar datos del usuario', textScaleFactor: 1,),
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: Stack(
          children: <Widget>[
            _usuarioForm(context),
          ],
        )
    );
  }

  Widget _usuarioForm(BuildContext context) {

    final bloc = Provider.usuarioformBloc(context);
    final size = MediaQuery.of(context).size;

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
                //  Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                //   SizedBox( height: 60.0 ),
                _crearName( bloc ),
                SizedBox( height: 10.0 ),
                _crearSecondname( bloc ),
                SizedBox( height: 10.0 ),
                _crearEmail( bloc ),
                SizedBox( height: 10.0 ),
                _crearTele( bloc ),
                SizedBox( height: 20.0 ),
                _crearFecha( bloc ),
                SizedBox( height: 10.0 ),
                _crearCiudad( bloc ),
                SizedBox( height: 10.0 ),
                _crearDirec( bloc ),
                SizedBox( height: 20.0 ),
                _crearBoton( bloc )
              ],
            ),
          ),
        ],
    );
  }

  Widget _crearName(UsuarioformBloc bloc) {
    final _prefs = new PreferenciasUsuario();
    Map myInfo = jsonDecode(_prefs.myInfo);
    return StreamBuilder(
      stream: bloc.NameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            initialValue: myInfo["first_name"],
            decoration: InputDecoration(
                labelText: 'Nombre',
                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changeName,
          ),
        );
      },
    );
  }
  Widget _crearSecondname(UsuarioformBloc bloc) {
    final _prefs = new PreferenciasUsuario();
    Map myInfo = jsonDecode(_prefs.myInfo);
    return StreamBuilder(
      stream: bloc.SecondNameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            initialValue: myInfo["last_name"],
            decoration: InputDecoration(
                labelText: 'Apellido',
                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changeSecondname,
          ),
        );
      },
    );
  }
  Widget _crearEmail(UsuarioformBloc bloc) {
    final _prefs = new PreferenciasUsuario();
    Map myInfo = jsonDecode(_prefs.myInfo);
    return StreamBuilder(
      stream: bloc.EmailusuarioStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            initialValue: myInfo["user_email"],
            decoration: InputDecoration(
                labelText: 'Email',
                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changeEmailusuario,
          ),
        );
      },
    );
  }
  Widget _crearTele(UsuarioformBloc bloc) {
    final _prefs = new PreferenciasUsuario();
    Map myInfo = jsonDecode(_prefs.myInfo);
    return StreamBuilder(
      stream: bloc.TeleStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            initialValue: myInfo["phone_number"],
            decoration: InputDecoration(
                labelText: 'Telefono',
                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changeTele,
          ),
        );
      },
    );
  }
  Widget _crearFecha(UsuarioformBloc bloc) {

      @override
      final _prefs = new PreferenciasUsuario();

      Map myInfo = jsonDecode(_prefs.myInfo);

      var myFormat = intl.DateFormat('yyyy/MM/dd');

      print("birth_date");
      print(myInfo["birth_date"]);
     // print(myFormat.format(myInfo["birth_date"]));

      if (myInfo["birth_date"] == null || myInfo["birth_date"] == "Invalid Date") {
        myInfo["birth_date"] = "2020/08/15";
      }

      var arr = (myInfo["birth_date"]).split('/');
      String post_nuevo = arr[0] + "-" + arr[1] + "-" + arr[2] ;

      DateTime selectedDate = DateTime.parse(post_nuevo);

      print("selectedDate");
      print(myFormat.format(selectedDate));

      Future<void> _selectDate(BuildContext context) async {
        final DateTime picked = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(1970, 1),
            lastDate: DateTime(2101));
        if (picked != null && picked != selectedDate)
          setState(() {
            selectedDate = picked;
            bloc.changeFecha(myFormat.format(picked).toString());
            print("fecha seleccionada");
            print(bloc.Fecha);
          });
      }

      return StreamBuilder(
        stream: bloc.FechaStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Row(
            mainAxisSize: MainAxisSize.max,

            children: <Widget>[
              SizedBox(width: 20.0,),
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: () => _selectDate(context),
                child: Text('Fecha de nacimiento', style: TextStyle(color: Colors.white),),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
              SizedBox(width: 10.0,),
              Text("${bloc.Fecha}".split(' ')[0], textScaleFactor: 1.05,),
            ],
          );
        },
      );
  }
  Widget _crearCiudad(UsuarioformBloc bloc) {
    final _prefs = new PreferenciasUsuario();
    Map myInfo = jsonDecode(_prefs.myInfo);
    return StreamBuilder(
      stream: bloc.CiudadStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            initialValue: myInfo["city"],
            decoration: InputDecoration(
                labelText: 'Ciudad',
                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changeCiudad,
          ),
        );
      },
    );
  }
  Widget _crearDirec(UsuarioformBloc bloc) {
    final _prefs = new PreferenciasUsuario();
    Map myInfo = jsonDecode(_prefs.myInfo);
    return StreamBuilder(
      stream: bloc.DirecStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            initialValue: myInfo["address"],
            decoration: InputDecoration(
                labelText: 'Direccion',
                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changeDirec,
          ),
        );
      },
    );
  }
  Widget _crearBoton( UsuarioformBloc bloc) {

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric( horizontal: 40.0, vertical: 15.0),
            child: Text('Guardar Cambios'),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _formusuario(bloc, context) : null,

        );
      },
    );
  }

  _formusuario(UsuarioformBloc bloc, BuildContext context) async {
    Loader.show(context,progressIndicator:LinearProgressIndicator());
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
    Map info = await usuarioProvider.formusuario(bloc.Name,bloc.Secondname,bloc.Emailusuario,bloc.Tele,bloc.Fecha,bloc.Ciudad, bloc.Direc);
    Map personal = await usuarioProvider.personal();
    String bancaria = await usuarioProvider.bancaria();
    String solicitudes_todas = await usuarioProvider.solicitudes_todas();
    print("retorno del presionar boton gusardar");
    print(info);

    Loader.hide();
    Navigator.pop(context);

    // final prefs = new PreferenciasUsuario();
    mostrarAlerta( context, info['message'] );
    } else if (connectivityResult == ConnectivityResult.wifi) {
      Map info = await usuarioProvider.formusuario(bloc.Name,bloc.Secondname,bloc.Emailusuario,bloc.Tele,bloc.Fecha,bloc.Ciudad, bloc.Direc);
      Map personal = await usuarioProvider.personal();
      String bancaria = await usuarioProvider.bancaria();
      String solicitudes_todas = await usuarioProvider.solicitudes_todas();
      print("retorno del presionar boton gusardar");
      print(info);

      Loader.hide();
      Navigator.pop(context);

      // final prefs = new PreferenciasUsuario();
      mostrarAlerta( context, info['message'] );
    } else {
      Loader.hide();

      mostrarConexion(context, "No tiene conexión a internet");
    }
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
  void mostrarAlerta(BuildContext context, String mensaje ) {

    showDialog(
        context: context,
        builder: ( context ) {
          return AlertDialog(
           // title: Text('Error al modificar la cuenta'),
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


class Formpassword extends StatefulWidget {
  @override
  _FormpasswordState createState() => _FormpasswordState();
}

class _FormpasswordState extends State<Formpassword> {

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
          title: new Text('Modificar Contraseña', textScaleFactor: 1,),
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: Stack(
          children: <Widget>[
            _passwordForm(context),
          ],
        )
    );
  }

  Widget _passwordForm(BuildContext context) {

    final bloc = Provider.formpasswordBloc(context);
    final size = MediaQuery.of(context).size;

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
    //  Text('Ingreso', style: TextStyle(fontSize: 20.0)),
    //   SizedBox( height: 60.0 ),
    _crearPassword( bloc ),
    SizedBox( height: 10.0 ),
    _crearNewPassword( bloc ),
    SizedBox( height: 10.0 ),
    _crearConfirmPassword( bloc ),
    SizedBox( height: 10.0 ),
    _crearBoton( bloc ),
    ],
    ),
        ),
        ],
    );
  }
  Widget _crearPassword(FormpasswordBloc bloc) {
    final _prefs = new PreferenciasUsuario();
    Map myInfo = jsonDecode(_prefs.myInfo);
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
                labelText: 'Contraseña Actual',
                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }
  Widget _crearNewPassword(FormpasswordBloc bloc) {
    final _prefs = new PreferenciasUsuario();
    Map myInfo = jsonDecode(_prefs.myInfo);
    return StreamBuilder(
      stream: bloc.newpasswordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changeNewPassword,
          ),
        );
      },
    );
  }
  Widget _crearConfirmPassword(FormpasswordBloc bloc) {
    final _prefs = new PreferenciasUsuario();
    Map myInfo = jsonDecode(_prefs.myInfo);
    return StreamBuilder(
      stream: bloc.confirmpasswordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
                labelText: 'Confirme su nueva contraseña',
                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changeConfirmPassword,
          ),
        );
      },
    );
  }
  Widget _crearBoton( FormpasswordBloc bloc) {
    final _prefs = new PreferenciasUsuario();

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){

        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric( horizontal: 40.0, vertical: 15.0),
            child: Text('Cambiar Contraseña'),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: () async {
            Loader.show(context,progressIndicator:LinearProgressIndicator());
            var connectivityResult = await (Connectivity().checkConnectivity());
            print(bloc.password);
            if (connectivityResult == ConnectivityResult.mobile) {
            if (bloc.password != _prefs.password) {
              Loader.hide();
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text("La antigua contraseña no coincide"),
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
            } else {
              if (bloc.newpassword == bloc.confirmpassword && bloc.newpassword != "") {
                var llamado = _formpassword(bloc, context);
                _prefs.password = bloc.newpassword;
                print("estoy aqui");
              } else {
                Loader.hide();
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("Las nuevas contraseñas no coinciden"),
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
            };
            } else if (connectivityResult == ConnectivityResult.wifi) {
              if (bloc.password != _prefs.password) {
                Loader.hide();
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("La antigua contraseña no coincide"),
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
              } else {

                if (bloc.newpassword == bloc.confirmpassword && bloc.newpassword != "") {
                  var llamado = _formpassword(bloc, context);
                  _prefs.password = bloc.newpassword;
                  print("estoy aqui");
                } else {
                  Loader.hide();
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          // title: Text('Error al modificar la cuenta'),
                          content: Text("Las nuevas contraseñas no coinciden"),
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
              };
            } else {
              Loader.hide();

              mostrarConexion(context, "No tiene conexión a internet");
            }
          });
      },
    );
  }

  _formpassword(FormpasswordBloc bloc, BuildContext context) async {

    print ("entre flaco");
    Loader.show(context,progressIndicator:LinearProgressIndicator());
    Map info = await usuarioProvider.formpassword(bloc.newpassword,);
    print("retorno del presionar boton guardar");
    print(info);

    Loader.hide();
    Navigator.pop(context);

    // final prefs = new PreferenciasUsuario();
    mostrarAlerta( context);

  }
  void mostrarAlerta(BuildContext context) {

    showDialog(
        context: context,
        builder: ( context ) {
          return AlertDialog(
            content: Text("La contraseña ha sido actualizada con exito"),
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
  }
