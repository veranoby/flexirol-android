import 'package:flutter/material.dart';
import 'package:flexirol_app/src/bloc/provider.dart';
import 'package:flexirol_app/src/preferencias_usuario/preferencias_usuario.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);
    final prefs = new PreferenciasUsuario();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home')
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Email: ${ bloc.email }'),
            Divider(),
            Text('Password: ${ bloc.password }'),
            Divider(),
            Text('Mi ID: ${ prefs.token }'),
          ],
      ),
    );
  }
}
