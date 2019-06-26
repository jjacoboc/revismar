import 'dart:convert';
import 'constants.dart';
import 'util.dart';
import 'bookViewList.dart';
import 'sharedPreferencesHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final logo = Image.asset('images/mgp-ereader-logo.png');
  var docTypeList = ['DNI', 'CIP'];
  String docTypeSelected = 'DNI';
  final docNumController = TextEditingController();
  final passController = TextEditingController();

  void login() async {
    Preference.load();
    String docNum = docNumController.text;
    if(docNum != '') {
      var response = await http.get(
          Uri.encodeFull(Constants.url_login +
              Util.parseDocumentType(docTypeSelected) +
              "/" +
              docNumController.text),
          headers: {"Accept": "application/json"});
      if(response.statusCode == 200) {
        Preference.setString('user', response.body);
        Map<String, dynamic> user = jsonDecode(response.body);
        String pass = user['password'];
        if(passController.text != '') {
          if(pass == passController.text) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookListPage(),
                ));
          } else {
            Alert(
              context: context,
              title: "Error",
              desc: "Contraseña incorrecta.",
              type: AlertType.error,
            ).show();
          }
        } else {
          Alert(
            context: context,
            title: "Error",
            desc: "Ingrese su contraseña.",
            type: AlertType.error,
          ).show();
        }
      } else {
        Alert(
          context: context,
          title: "Error",
          desc: "Usuario no registrado.",
          type: AlertType.error,
        ).show();
      }
    } else {
      Alert(
        context: context,
        title: "Error",
        desc: "Debe ingresar su DNI.",
        type: AlertType.error,
      ).show();
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(2, 29, 38, 1.0),
                        Color.fromRGBO(2, 29, 38, 0.9)
                      ],
                    ),
                    borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: logo,
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32, right: 32),
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 62),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 45,
                      margin: EdgeInsets.only(top: 16),
                      padding:
                      EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 5)
                          ]),
                      child: TextField(
                        controller: docNumController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(8),
                          BlacklistingTextInputFormatter(
                              new RegExp('[\\-|\\.|\\,|\\ ]'))
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.perm_identity,
                            color: Colors.grey,
                          ),
                          hintText: 'DNI',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 45,
                      margin: EdgeInsets.only(top: 16),
                      padding:
                      EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 5)
                          ]),
                      child: TextField(
                        controller: passController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.vpn_key,
                            color: Colors.grey,
                          ),
                          hintText: 'Contraseña',
                        ),
                        obscureText: true,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, right: 32),
                        child: Text(
                          '¿Olvidó su contraseña?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                      margin: EdgeInsets.only(top: 20.0),
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Center(
                        child: RaisedButton(
                            textColor: Colors.white,
                            color: Color.fromRGBO(2, 29, 38, 0.8),
                            colorBrightness: Brightness.light,
                            highlightColor: Color.fromRGBO(2, 29, 38, 1.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            child: Text(
                              'Ingresar'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: login),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }
}
