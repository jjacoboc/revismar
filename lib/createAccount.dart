import 'dart:convert';
import 'login.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:email_validator/email_validator.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final docNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  void create() {
    String docNumber = docNumberController.text;
    if(docNumber != '') {
      if(docNumber.length == 8) {
        String firstName = firstNameController.text;
        if(firstName != '') {
          String lastName = lastNameController.text;
          if(lastName != '') {
            String email = emailController.text;
            if(email != '') {
              if(EmailValidator.validate(email)){
                String pass = passController.text;
                if(pass != '') {
                  if(pass.length >= 8) {
                    this.postRequest().then((http.Response response) {
                      if(response.statusCode == 200) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                      } else {
                        Alert(
                          context: context,
                          title: "Error",
                          desc: "Ocurrio un error inesperado.\nContáctese con el proveedor del servicio.",
                          type: AlertType.error,
                        ).show();
                      }
                    });
                  } else {
                    Alert(
                      context: context,
                      title: "Error",
                      desc: "La contraseña debe tener al menos 8 caracteres.",
                      type: AlertType.error,
                    ).show();
                  }
                } else {
                  Alert(
                    context: context,
                    title: "Error",
                    desc: "Campo requerido.\nDebe ingresar una contraseña.",
                    type: AlertType.error,
                  ).show();
                }
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

  Future<http.Response> postRequest () async {

    Map user = {
      'names': firstNameController.text,
      'last_names': lastNameController.text,
      'document_type': 1,
      'document_number': docNumberController.text,
      'email': emailController.text,
      'password': passController.text,
      'created_by': 0,
      'created_date': DateTime.now().millisecond,
      'updated_by': 0,
      'updated_date': null
    };
    //encode Map to JSON
    var body = json.encode(user);

    var response = await http.post(Constants.url_user,
        headers: {"Content-Type": "application/json"},
        body: body
    );
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Nueva Cuenta"),
        backgroundColor: Color.fromRGBO(2, 29, 38, 1.0),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.2  ,
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
                    padding:
                    EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(
                      controller: docNumberController,
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
                    margin: EdgeInsets.only(top: 5),
                    padding:
                    EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(
                      controller: firstNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.account_box,
                          color: Colors.grey,
                        ),
                        hintText: 'Nombres',
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: EdgeInsets.only(top: 5),
                    padding:
                    EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(
                      controller: lastNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.account_box,
                          color: Colors.grey,
                        ),
                        hintText: 'Apellidos',
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: EdgeInsets.only(top: 5),
                    padding:
                    EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        hintText: 'Correo electrónico',
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: EdgeInsets.only(top: 5),
                    padding:
                    EdgeInsets.only(left: 16, right: 16),
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
                        hintText: 'Contraseña (al menos 8 caracteres)',
                      ),
                      obscureText: true,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 18.0),
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Center(
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Color.fromRGBO(2, 29, 38, 0.8),
                        colorBrightness: Brightness.light,
                        highlightColor: Color.fromRGBO(2, 29, 38, 1.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        child: Text(
                          'Crear Cuenta'.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
      ),
    );
  }
}