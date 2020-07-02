import 'dart:convert';

import 'package:form_validation/src/preferencias/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider{

  final String _firebaseToken = 'AIzaSyBC11H4y0qwzK030kiYAoKpfwpHJwBX_Zs';
  final _pref = PreferenciasUsuario();

  Future<Map<String,dynamic>> nuevoUsuario(String email,String password) async{
    final authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final response = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String,dynamic> decodeResponse = json.decode(response.body);
    print(decodeResponse);
    if(decodeResponse.containsKey('idToken')){
      _pref.token = decodeResponse['idToken'];
      return {'ok' : true, 'token' : decodeResponse['idToken']};
    }else{
      return {'ok' : false, 'mensaje' : decodeResponse['error']['message']};
    }

  }

  Future<Map<String,dynamic>> login(String email, String password) async{
    final authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final response = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String,dynamic> decodeResponse = json.decode(response.body);
    print(decodeResponse);
    if(decodeResponse.containsKey('idToken')){
      _pref.token = decodeResponse['idToken'];
      return {'ok' : true, 'token' : decodeResponse['idToken']};
    }else{
      return {'ok' : false, 'mensaje' : decodeResponse['error']['message']};
    }
  }

}