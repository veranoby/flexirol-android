// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'package:flexirol_app/main.dart';
import 'package:flexirol_app/src/pages/login_page.dart';
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
import 'package:connectivity/connectivity.dart';





class Bancaria extends StatefulWidget {
  @override
  _BancariaState createState() => _BancariaState();

}

class _BancariaState extends State<Bancaria> {

  @override
  void dispose() {
    Loader.hide();

    super.dispose();
  }
  @override

  Widget build(BuildContext context) {
    final _prefs = new PreferenciasUsuario();
    List bancoMapa = jsonDecode(_prefs.bancaria);

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
      appBar: new AppBar(
        title: new Text('Configuracion Bancaria', textScaleFactor: 1,),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,

      )
      ,
      body: Column(

    children: <Widget>[

      Stack(
        children: <Widget>[
          fondoModaro,
          Positioned( top: -40.0, right: -30.0, child: circulo ),
          Positioned( bottom: 120.0, right: 20.0, child: circulo ),
          Positioned( bottom: -50.0, left: -20.0, child: circulo ),
          ListTile(
            leading: Icon(Icons.business, size: 40, color: Colors.white,),
            title: Text("Su listado de cuentas", textScaleFactor: 1.05,  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
            subtitle: Text("donde sera depositado su Anticipo solicitado..", textScaleFactor: 1.05, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),),
          ),
        ],
      ),
      Expanded(
       child: datosbanco(context),
      ),
    ],
    ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FormBanco())).then((value) {
            setState(() {
              // refresh state of Page1
            });
          });        // Add your onPressed code here!
        },
        child: Icon(Icons.add),
      ),

    );
  }
  Widget datosbanco (BuildContext context){
    final _prefs = new PreferenciasUsuario();
    List bancoMapa = jsonDecode(_prefs.bancaria);

    if (bancoMapa[0]["mensaje"] == "no hay"){
      return Column(
          children: <Widget>[
            Image(image: AssetImage("assets/images/oops.png")),
            ListTile(
              title: Text("No hay cuentas disponibles, por favor cree una."),
            )
          ]
      );
   } else {
      print(bancoMapa);
      return ListView.builder(
          itemCount: bancoMapa.length,
          itemBuilder: (context, index) {
            return
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                        dense: true,
                        //trailing: Icon(Icons.phonelink_erase, color: Colors.red,),
                       trailing:  IconButton(
                          icon: Icon(Icons.cancel_outlined, color: Colors.red,),
                          onPressed: () async {
                            print( bancoMapa[index]["ID"]);
                            var ID = bancoMapa[index]["ID"];
                            verbancoLogic(context, ID);

                            },
                          ),

                        title: Text("Banco: " + bancoMapa[index]["post_banco"] + "    Cuenta: " + bancoMapa[index]["gearbox"] + " " + bancoMapa[index]["numero_cuenta"] ,
                          textScaleFactor: 1.05,
                          style: TextStyle(fontWeight: FontWeight.normal,
                              color: Colors.black),),
                        subtitle: Text("Nombre: " + bancoMapa[index]["post_excerpt"] + "    Cedula:" + bancoMapa[index]["post_content"],
                          textScaleFactor: 0.95,
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: Colors.black45),),

                    ),
                    widget_status(bancoMapa[index]["post_modified"]),
                  ],


                ),
              );
          }
      );

    }
  }
  Widget verbancoLogic(BuildContext context,  ID){
    @override
    void dispose() {
      Loader.hide();

      super.dispose();
    }
    final usuarioProvider = new UsuarioProvider();
    final _prefs = new PreferenciasUsuario();
    print("contador ID");
    print(ID);
    showDialog(
        context: context,
        builder: ( context ) {
          return AlertDialog(
            // title: Text('Error al modificar la cuenta'),
            content: Text("Desea eliminar esta cuenta bancaria?"),
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
                child: Text('Confirmar',style: TextStyle(
                    color: Colors.white),),
                onPressed: () async {
                  Loader.show(context,progressIndicator:LinearProgressIndicator());
                var connectivityResult = await (Connectivity().checkConnectivity());
                if (connectivityResult == ConnectivityResult.mobile) {
                  Map info = await usuarioProvider.eliminarbanco(ID);
                  print(info);
                  String bancaria = await usuarioProvider.bancaria();
                  print(bancaria);
                  Loader.hide();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyBottomNavigationBar()));
                  await mostrarAlerta(context);
              } else if (connectivityResult == ConnectivityResult.wifi) {

                  Map info = await usuarioProvider.eliminarbanco(ID);
                  print(info);
                  String bancaria = await usuarioProvider.bancaria();
                  print(bancaria);
                  Loader.hide();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyBottomNavigationBar()));
                  await mostrarAlerta(context);
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
                child: Text('Cancelar',style: TextStyle(
                    color: Colors.white),),

                onPressed: ()=> Navigator.of(context).pop(),
              ),
            ],
          );
        }
    );
  }

  _eliminarbanco(BuildContext context,int ID) async {
    final _prefs = new PreferenciasUsuario();
    final usuarioProvider = new UsuarioProvider();
    print("si llego");
    print(ID);
    //Map info = await usuarioProvider.eliminarbanco(ID);

    //String bancaria = await usuarioProvider.bancaria();




    //_onpagechanged(int index) ;
    //Navigator.popUntil(context, ModalRoute.withName("navigationbar"));
  }
  void mostrarAlerta(BuildContext context) {

    showDialog(
        context: context,
        builder: ( context ) {
          return AlertDialog(
            // title: Text('Error al modificar la cuenta'),
            content: Text("Cuenta eliminada con exito"),
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



Widget widget_status(String post_modified) {

  var arr = post_modified.split('/');
  String post_nuevo = arr[2] + "-" + arr[1] + "-" + arr[0] ;
  var parsedDate = DateTime.parse(post_nuevo);
  var temp = DateTime.now() ;
  var dias = ((temp.difference(parsedDate) - Duration(hours: temp.hour) + Duration(hours: parsedDate.hour)).inHours / 24).round();

  print("diferencia fechas en dias");
  print(dias);

  if (dias < 1 ) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 4.0, 0.0),
      //tileColor: Colors.amber ,0
      title: Text("En Proceso de Validacion..", textScaleFactor: 0.9, style: TextStyle(
      background: Paint()
        ..strokeWidth = 15.0
        ..color = Colors.yellow[50]
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
          , fontWeight: FontWeight.bold, color: Colors.yellow[800]),),
    );
  } else {
    return Divider(color:Colors.green, thickness:2, height:2)
    ;
  }
}


class FormBanco extends StatefulWidget {
  @override
  _FormBancoState createState() => new _FormBancoState();
}

class _FormBancoState extends State<FormBanco> {
  List<String> banco = [
    "Seleccione",
    "Pacífico",
    "Guayaquil",
    "Pichincha",
    "Produbanco",
    "Internacional",
    "Bolivariano",
    "Solidario",
    "Austro"
  ];
  String _banco = "Seleccione";

  void choosebanco(String value) {
    setState(() {
      _banco = value;
    });
  }

  List<String> cuenta = [
    "Seleccione",
    "ahorros",
    "corriente",

  ];
  String _cuenta = "Seleccione";

  void choosecuenta(String value) {
    setState(() {
      _cuenta = value;
    });
  }

  final usuarioProvider = new UsuarioProvider();
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: FormBancoLogic(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget FormBancoLogic(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Añadir Cuenta Bancaria', textScaleFactor: 1,),
          textTheme: Theme
              .of(context)
              .textTheme
              .apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: Stack(
          children: <Widget>[
            _bancoForm(context),
          ],
        )
    );
  }

  Widget _bancoForm(BuildContext context) {
    final bloc = Provider.bancoformBloc(context);
    final size = MediaQuery
        .of(context)
        .size;

    return ListView(
      children: <Widget>[
        Container(
          width: size.width * 0.85,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.symmetric(vertical: 25.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: <Widget>[
              //  Text('Ingreso', style: TextStyle(fontSize: 20.0)),
              //   SizedBox( height: 60.0 ),
              _crearName(bloc),
              SizedBox(height: 20.0),
              _crearCedula(bloc),
              SizedBox(height: 20.0),
              _crearEmailbanco(bloc),
              SizedBox(height: 20.0),
              _crearBanco(bloc),
              SizedBox(height: 20.0),
              _crearTipocuenta(bloc),
              SizedBox(height: 20.0),
              _crearAccount(bloc),
              SizedBox(height: 20.0),
              _crearBoton(bloc)
            ],
          ),
        ),
      ],
    );
  }

  Widget _crearName(BancoformBloc bloc) {
   // final _prefs = new PreferenciasUsuario();
  //  Map myInfo = jsonDecode(_prefs.myInfo);
    return StreamBuilder(
      stream: bloc.NameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: 'Propietario de la Cuenta',
                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changeName,
          ),
        );
      },
    );
  }

  Widget _crearCedula(BancoformBloc bloc) {
    final _prefs = new PreferenciasUsuario();
    Map myInfo = jsonDecode(_prefs.myInfo);
    return StreamBuilder(
      stream: bloc.CedulaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: 'Cedula',
                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changeCedula,
          ),
        );
      },
    );
  }

  Widget _crearEmailbanco(BancoformBloc bloc) {
    final _prefs = new PreferenciasUsuario();
    Map myInfo = jsonDecode(_prefs.myInfo);
    return StreamBuilder(
      stream: bloc.EmailbancoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: 'Email',
                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changeEmailbanco,
          ),
        );
      },
    );
  }

  Widget _crearTipocuenta(BancoformBloc bloc) {
    return StreamBuilder(
      stream: bloc.TipocuentaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child:
            new Row(
                children: <Widget>[
                  new Text("Tipo de cuenta:  ", style: new TextStyle(
                      fontSize: 17.0, color: Colors.black54),),
                  new DropdownButton(
                    style: new TextStyle(
                        fontSize: 17.0, color: Colors.black),
                    onChanged: (String value) {
                      choosecuenta(value);
                      bloc.changeTipocuenta(_cuenta);
                      ;
                    },
                    value: _cuenta,
                    items: cuenta.map((String value) {
                      return new DropdownMenuItem(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                  ),

                ]));
      },
    );
  }

  Widget _crearBanco(BancoformBloc bloc) {
    return StreamBuilder(
      stream: bloc.BancoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child:
          new Row(
            children: <Widget>[
              new Text("Banco:   ", style: new TextStyle(
                  fontSize: 17.0, color: Colors.black54),),
              new DropdownButton(
                style: new TextStyle(
                    fontSize: 17.0, color: Colors.black),
                onChanged: (String value) {
                  choosebanco(value);
                  bloc.changeBanco(_banco);
                },
                value: _banco,
                items: banco.map((String value) {
                  return new DropdownMenuItem(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
              ),

            ],
          ),
        );
      },
    );
  }

  Widget _crearAccount(BancoformBloc bloc) {
    final _prefs = new PreferenciasUsuario();
    Map myInfo = jsonDecode(_prefs.myInfo);
    return StreamBuilder(
      stream: bloc.AccountStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: 'Numero de cuenta',
                // counterText: snapshot.data,
                errorText: snapshot.error
            ),
            onChanged: bloc.changeAccount,
          ),
        );
      },
    );
  }

  Widget _crearBoton(BancoformBloc bloc) {
    final _prefs = new PreferenciasUsuario();
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
              child: Text('Guardar Cuenta'),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)
            ),
            elevation: 0.0,
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () async {
              await _formbanco(bloc, context);
            }
        );
      },
    );
  }

  void cedulairregular(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("La cedula no coincide con la registrada"),
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

  void emailirregular(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("El email no coincide con el registrado"),
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

  _formbanco(BancoformBloc bloc, BuildContext context) async {
    final _prefs = new PreferenciasUsuario();

    Map myInfo = jsonDecode(_prefs.myInfo);

    Loader.show(context,progressIndicator:LinearProgressIndicator());
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (bloc.Cedula.toString() != myInfo["cedula"].toString()) {
        Loader.hide();
        cedulairregular(context);
      } else {
        if (bloc.Emailbanco.toString() != myInfo["user_email"].toString()) {
          Loader.hide();
          emailirregular(context);
        } else {
          Map info = await usuarioProvider.formbanco(
            bloc.Name, bloc.Tipocuenta, bloc.Account, bloc.Cedula,
            bloc.Emailbanco, bloc.Banco,);
          print("retorno del presionar banco");
          print(info);
          String bancaria = await usuarioProvider.bancaria();
          Loader.hide();
          Navigator.pop(context);
          mostrarAlerta(context, info['message']);
        }
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (bloc.Cedula.toString() != myInfo["cedula"].toString()) {
        Loader.hide();
        cedulairregular(context);
      } else {
        if (bloc.Emailbanco.toString() != myInfo["user_email"].toString()) {
          Loader.hide();
          emailirregular(context);
        } else {
          Map info = await usuarioProvider.formbanco(
            bloc.Name, bloc.Tipocuenta, bloc.Account, bloc.Cedula,
            bloc.Emailbanco, bloc.Banco,);
          print("retorno del presionar banco");
          print(info);
          String bancaria = await usuarioProvider.bancaria();
          Loader.hide();
          Navigator.pop(context);
          mostrarAlerta(context, info['message']);
        }
      }
    } else {
      Loader.hide();

      mostrarConexion(context, "No tiene conexión a internet");
    }
    }
  }
  void mostrarAlerta(BuildContext context, String mensaje) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
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
                onPressed: () => Navigator.of(context).pop(),
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