import 'dart:convert';
import 'bookViewList.dart';
import 'suscription.dart';
import 'constants.dart';
import 'profile.dart';
import 'dart:io';
import 'sharedPreferencesHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  Map<String, dynamic> user;
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var validators = new List(4);
  bool btnEnable = false;
  bool drawerEnable = false;
  bool _hasEmail = false;
  String errorText = '';

  @override
  initState() {
    super.initState();
    Preference.load();
    user = jsonDecode(Preference.getString('user'));
    if(user['changePassword'] == 1) {
      setState(() {
        drawerEnable = false;
      });
    } else {
      setState(() {
        drawerEnable = true;
      });
    }
    if(user['email'] != null && user['email'] != '') {
      setState(() {
        this._hasEmail = true;
      });
    } else {
      setState(() {
        this._hasEmail = false;
      });
    }
    for(int i=0;i<validators.length;i++) {
      setState(() {
        validators[i] = 0;
      });
    }
    setState(() {
      btnEnable = false;
    });
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(2, 29, 38, 1.0),
                      Color.fromRGBO(2, 29, 38, 0.8)
                    ],
                  )
              ),
              accountName: Row(
                children: <Widget>[
                  Icon(Icons.account_circle, color: Colors.white, size: 18),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(this.user['names'] + ' ' + this.user['last_names']),
                  ),
                ],
              ),
              accountEmail: Row(
                children: <Widget>[
                  Icon(Icons.email, color: Colors.white, size: 18),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(this.user['email']),
                  ),
                ],
              ),
              currentAccountPicture: Container(
                //child: Image.asset('images/avatar/avatar01.jpg'),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(242, 240, 242, 1),
                    border: Border.all(style: BorderStyle.solid, color: Colors.white, width: 5),
                    image: DecorationImage(image: AssetImage('images/avatar/avatar' + user['avatar'] + '.jpg'))
                ),
                width: 110,
                height: 110,
              )
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.bookOpen, color: Color.fromRGBO(2, 29, 38, 1.0), size: 18,),
            title: Text('Biblioteca'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookListPage(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.key, color: Color.fromRGBO(2, 29, 38, 1.0), size: 18,),
            title: Text('Cambiar Contraseña'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.solidAddressCard, color: Color.fromRGBO(2, 29, 38, 1.0), size: 18,),
            title: Text('Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.signOutAlt, color: Colors.red, size: 18,),
            title: Text('Salir', style: TextStyle(color: Colors.red),),
            onTap: () {
              exit(0);
            },
          ),
          Divider(color: Color.fromRGBO(2, 29, 38, 1.0),),
          ListTile(
            title: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.subscriptions, color: Colors.white),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text('Suscribirse', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color: Colors.white),),
                    ),
                  ],
                ),
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuscriptionPage(),
                      ));
                }
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void changePassword() async {
    String password = passwordController.text;
    if(password != ''){
      String newPassword = newPasswordController.text;
      if(newPassword != ''){
        String confirmPassword = confirmPasswordController.text;
        if(confirmPassword != ''){
          if(newPassword == confirmPassword) {
            user['changePassword'] = 0;
            user['password'] = newPassword;
            user['updated_date'] = DateTime.now().millisecond;
            user['updated_by'] = user['idt_user'];
            await http.put(
                //Uri.encodeFull('http://10.0.2.2:8084/user/' + user['idt_user'].toString()),
                Uri.encodeFull(Constants.url_user + user['idt_user'].toString()),
                headers: {"Content-Type": "application/json"}, body: json.encode(user)
            ).then((http.Response response) {
              if(response.statusCode == 200) {
                Alert(
                    context: context,
                    title: "Éxito!",
                    desc: "Su nueva contraseña ah sido registrada!",
                    type: AlertType.success,
                    closeFunction: () {
                      if(_hasEmail) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookListPage(),
                            ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ));
                      }
                    }
                ).show();
              } else {
                Alert(
                    context: context,
                    title: "Error!",
                    desc: "Ocurrió un error inesperado!\nPor favor, comuníquese con el proveedor del servicio.",
                    type: AlertType.error
                ).show();
              }
            });
          } else {
            setState(() {
              this.errorText = Constants.changePass_error_confirmPassEquals;
            });
            this.cleanErrorMsg();
          }
        } else {
          setState(() {
            this.errorText = Constants.changePass_error_confirmPassRequired;
          });
          this.cleanErrorMsg();
        }
      } else {
        setState(() {
          this.errorText = Constants.changePass_error_newPassRequired;
        });
        this.cleanErrorMsg();
      }
    } else {
      setState(() {
        this.errorText = Constants.changePass_error_passRequired;
      });
      this.cleanErrorMsg();
    }
  }

  void cleanErrorMsg() {
    Future.delayed(
      Duration(seconds: 5), () {
        setState(() {
          this.errorText = '';
        });
      },
    );
  }

  void validate() {
    String value = newPasswordController.text;
    if(value.length >= 8) {
      setState(() {
        validators[0] = 1;
      });
    } else {
      setState(() {
        validators[0] = 0;
      });
    }
    bool lowerCase = false;
    for(int i=0;i<value.length;i++) {
      int code = value.codeUnitAt(i).toInt();
      if(code > 96 && code < 123) {
        lowerCase = true;
        break;
      }
    }
    bool upperCase = false;
    for(int i=0;i<value.length;i++) {
      int code = value.codeUnitAt(i).toInt();
      if(code > 64 && code < 91) {
        upperCase = true;
        break;
      }
    }
    bool number = false;
    for(int i=0;i<value.length;i++) {
      int code = value.codeUnitAt(i).toInt();
      if(code > 47 && code < 58) {
        number = true;
        break;
      }
    }
    if(lowerCase) {
      setState(() {
        validators[1] = 1;
      });
    } else {
      setState(() {
        validators[1] = 0;
      });
    }
    if(upperCase) {
      setState(() {
        validators[2] = 1;
      });
    } else {
      setState(() {
        validators[2] = 0;
      });
    }
    if(number) {
      setState(() {
        validators[3] = 1;
      });
    } else {
      setState(() {
        validators[3] = 0;
      });
    }
    bool allCheck = true;
    for(int i=0;i<validators.length;i++) {
      if(validators[i] == 0) {
        allCheck = false;
        break;
      }
    }
    if(allCheck) {
      setState(() {
        btnEnable = true;
      });
    } else {
      setState(() {
        btnEnable = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(Constants.changePass_title),
        backgroundColor: Color.fromRGBO(2, 29, 38, 1.0),
        centerTitle: true,
        leading: drawerEnable ? null : Container(),
      ),
      drawer: drawerEnable ? _buildDrawer() : null,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              //padding: EdgeInsets.only(top: 40),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Image.asset('images/resetpass.png', width: 128, height: 128,),
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                    //decoration: BoxDecoration(color: Color.fromRGBO(valColors[0][0], valColors[0][1], valColors[0][2], valColors[0][3])),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('La Contraseña debe contener:')
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            validators[0] == 1 ? Icon(Icons.check, color: Colors.green) : Icon(Icons.arrow_right),
                            validators[0] == 1 ? Text(Constants.changePass_validation1, style: TextStyle(decoration: TextDecoration.lineThrough)) : Text(Constants.changePass_validation1)
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            validators[1] == 1 ? Icon(Icons.check, color: Colors.green) : Icon(Icons.arrow_right),
                            validators[1] == 1 ? Text(Constants.changePass_validation2, style: TextStyle(decoration: TextDecoration.lineThrough)) : Text(Constants.changePass_validation2)
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            validators[2] == 1 ? Icon(Icons.check, color: Colors.green) : Icon(Icons.arrow_right),
                            validators[2] == 1 ? Text(Constants.changePass_validation3, style: TextStyle(decoration: TextDecoration.lineThrough)) : Text(Constants.changePass_validation3)
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            validators[3] == 1 ? Icon(Icons.check, color: Colors.green) : Icon(Icons.arrow_right),
                            validators[3] == 1 ? Text(Constants.changePass_validation4, style: TextStyle(decoration: TextDecoration.lineThrough)) : Text(Constants.changePass_validation4)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      decoration: InputDecoration(
                        hintText: Constants.changePass_hintText_OldPass,
                        hintStyle: TextStyle(fontSize: 14)
                      ),
                      obscureText: true,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      controller: newPasswordController,
                      keyboardType: TextInputType.text,
                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      decoration: InputDecoration(
                        hintText: Constants.changePass_hintText_NewPass,
                        hintStyle: TextStyle(fontSize: 14)
                      ),
                      obscureText: true,
                      onChanged: (value) => validate(),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.text,
                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      decoration: InputDecoration(
                        hintText: Constants.changePass_hintText_ConfirmPass,
                        hintStyle: TextStyle(fontSize: 14)
                      ),
                      obscureText: true
                    ),
                  ),
                  Container(
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
                            Constants.changePass_btn.toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          onPressed: btnEnable ? () => changePassword() : null
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(this.errorText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red[300])),
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