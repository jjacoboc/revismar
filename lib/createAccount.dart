import 'dart:convert';
import 'util.dart';
import 'login.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  bool creatingAccount = false;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final docNumberController = TextEditingController();
  final emailController = TextEditingController();
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  void create() {
    String docNumber = docNumberController.text;
    if (docNumber != '') {
      if (docNumber.length == 8) {
        String firstName = firstNameController.text;
        if (firstName != '') {
          String lastName = lastNameController.text;
          if (lastName != '') {
            String email = emailController.text;
            if (email != '') {
              if (EmailValidator.validate(email)) {
                this.getUserByDNI().then((http.Response response) {
                  if (response.statusCode == 200) {
                    Alert(
                      context: context,
                      title: "Error",
                      desc:
                      "Ya existe un Usuario con el DNI ingresado.",
                      type: AlertType.error,
                    ).show();
                  } else {
                    this.getUserByEmail().then((http.Response response) {
                      if (response.statusCode == 200) {
                        Alert(
                          context: context,
                          title: "Error",
                          desc:
                          "Ya existe un Usuario con el Correo Electrónico ingresado.",
                          type: AlertType.error,
                        ).show();
                      } else {
                        this.postRequest().then((http.Response response) {
                          setState(() {
                            creatingAccount = false;
                          });
                          if (response.statusCode == 200) {
                            Alert(
                              context: context,
                              title: "Exito",
                              desc: "Su nueva cuenta ha sido registrada!.\nSu contraseña ha sido enviada al correo " + Util.obscureEmail(emailController.text),
                              type: AlertType.success,
                              style: AlertStyle(isOverlayTapDismiss: false),
                              closeFunction: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  )
                                );
                              }
                            ).show();
                          } else {
                            Alert(
                              context: context,
                              title: "Error",
                              desc:
                              "Ocurrio un error inesperado.\nContáctese con el proveedor del servicio.",
                              type: AlertType.error,
                            ).show();
                          }
                        });
                      }
                    });
                  }
                });
              } else {
                Alert(
                  context: context,
                  title: "Error",
                  desc: "Formato de correo electrónico incorrecto.",
                  type: AlertType.error,
                ).show();
              }
            } else {
              Alert(
                context: context,
                title: "Error",
                desc: "Campo requerido.\nDebe ingresar su email.",
                type: AlertType.error,
              ).show();
            }
          } else {
            Alert(
              context: context,
              title: "Error",
              desc: "Campo requerido.\nDebe ingresar su(s) apellido(s).",
              type: AlertType.error,
            ).show();
          }
        } else {
          Alert(
            context: context,
            title: "Error",
            desc: "Campo requerido.\nDebe ingresar su(s) nombre(s).",
            type: AlertType.error,
          ).show();
        }
      } else {
        Alert(
          context: context,
          title: "Error",
          desc: "Formato de DNI incorrecto.",
          type: AlertType.error,
        ).show();
      }
    } else {
      Alert(
        context: context,
        title: "Error",
        desc: "Campo requerido.\nDebe ingresar su DNI.",
        type: AlertType.error,
      ).show();
    }
  }

  Future<http.Response> getUserByEmail() async {
    String email = emailController.text;
    List<String> list = email.split("@");
    String _email = list[0] + "@" + list[1].replaceAll(new RegExp(r'.'), ':');
    return await http.get(
        Uri.encodeFull(
            Constants.url_userByEmail + _email + Constants.separator),
        headers: {"Accept": "application/json"});
  }

  Future<http.Response> getUserByDNI() async {
    String type = '1';
    String number = docNumberController.text;
    return await http.get(
      //Uri.encodeFull('http://10.0.2.2:8084/login/' +
        Uri.encodeFull(Constants.url_login + type + Constants.separator + number),
        headers: {"Accept": "application/json"});
  }

  Future<http.Response> postRequest() async {
    Map user = {
      'names': firstNameController.text,
      'last_names': lastNameController.text,
      'document_type': 1,
      'document_number': docNumberController.text,
      'email': emailController.text,
      'changePassword': 1,
      'password': '',
      'created_by': 0,
      'created_date': DateTime.now().millisecond,
      'updated_by': 0,
      'updated_date': null
    };
    //encode Map to JSON
    var body = json.encode(user);

    setState(() {
      creatingAccount = true;
    });

    var response = await http.post(Uri.encodeFull(Constants.url_createUser),
    //var response = await http.post(Uri.encodeFull('http://10.0.2.2:8084/create/suser/'),
        headers: {"Content-Type": "application/json"}, body: body);
    return response;
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: _buildBottomNavigationBar(),
      appBar: AppBar(
        title: Text("Nueva Cuenta"),
        backgroundColor: Color.fromRGBO(2, 29, 38, 1.0),
        centerTitle: true,
      ),
      body: creatingAccount ? _buildLoadingIndicator() : _buildBody()
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        )
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: EdgeInsets.only(right: 16, left: 16),
      height: 45.0,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Al crear una cuenta aceptas nuestros '),
              InkWell(
                  child: Text('Términos de Servicio',
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline
                      )
                  ),
                  onTap: () => launch(
                      'https://agenciatrooper.com/mgp-aviso-de-privacidad/'))
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('y '),
              InkWell(
                  child: Text('Políticas de Privacidad',
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline)),
                  onTap: () => launch(
                      'https://agenciatrooper.com/mgp-aviso-de-privacidad/')),
              Text('.')
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.2,
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
                Container(
                  child: Image.asset('images/mgp-ereader-logo.png'),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 40),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: TextField(
                    controller: docNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(8),
                      BlacklistingTextInputFormatter(
                          new RegExp('[\\-|\\.|\\,|\\ ]'))
                    ],
                    decoration: InputDecoration(
                        isDense: true,
                        icon: Icon(
                          Icons.chrome_reader_mode,
                          color: Color.fromRGBO(2, 29, 38, 1.0),
                        ),
                        hintText: 'DNI',
                        hintStyle: TextStyle(fontSize: 14)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: TextField(
                    controller: firstNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        isDense: true,
                        icon: Icon(
                          Icons.account_box,
                          color: Color.fromRGBO(2, 29, 38, 1.0),
                        ),
                        hintText: 'Nombres',
                        hintStyle: TextStyle(fontSize: 14)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: TextField(
                    controller: lastNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        isDense: true,
                        icon: Icon(
                          Icons.account_box,
                          color: Color.fromRGBO(2, 29, 38, 1.0),
                        ),
                        hintText: 'Apellidos',
                        hintStyle: TextStyle(fontSize: 14)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        isDense: true,
                        icon: Icon(
                          Icons.email,
                          color: Color.fromRGBO(2, 29, 38, 1.0),
                        ),
                        hintStyle: TextStyle(fontSize: 14),
                        hintText: 'Correo electrónico'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 28.0),
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Center(
                    child: RaisedButton(
                        textColor: Colors.white,
                        color: Color.fromRGBO(2, 29, 38, 0.8),
                        colorBrightness: Brightness.light,
                        highlightColor: Color.fromRGBO(2, 29, 38, 1.0),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0))),
                        child: Text(
                          'Crear Cuenta'.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        onPressed: () => create()
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
