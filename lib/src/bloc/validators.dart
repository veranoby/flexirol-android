// @dart=2.9
import 'dart:async';



class Validators {


  final validarEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: ( email, sink ) {
      sink.add(email);
    }
  );


  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: ( password, sink ) {

      if ( password.length >= 2 ) {
        sink.add( password );
      } else {
        sink.addError('Ingrese contraseña valida por favor');
      }

    }
  );
  final validarEmailbien = StreamTransformer<String, String>.fromHandlers(
      handleData: ( email, sink ) {


        Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp   = new RegExp(pattern);

        if ( regExp.hasMatch( email ) ) {
          sink.add( email );
        } else {
          sink.addError('El email no es valido');
        }

      }
  );


}
