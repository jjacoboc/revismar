import 'dart:io';
import 'dart:convert';
import 'constants.dart';
import 'suscription.dart';
import 'avatarPicker.dart';
import 'bookViewList.dart';
import 'changePassword.dart';
import 'sharedPreferencesHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final docNumberController = TextEditingController();
  final emailController = TextEditingController();
  final cipController = TextEditingController();
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  bool _isChecked = false;
  bool _hasEmail = false;
  List<String> _grados = ['Almte.', 'Valmte.', 'Contralmte.', 'Cap. de N.', 'Cap. de F.', 'Cap. de C.', 'Tte. 1°', 'Tte. 2°', 'Alfz. de F.'];
  String _selectedGrado;
  Map<String, dynamic> user;

  FocusNode _focusNode = FocusNode();
  bool showPersonalData = true;

  @override
  initState() {
    super.initState();
    Preference.load();
    user = jsonDecode(Preference.getString('user'));
    this.firstNameController.text = user['names'];
    this.lastNameController.text = user['last_names'];
    this.docNumberController.text = user['document_number'];
    this.emailController.text = user['email'];
    this.cipController.text = user['cip'];
    this._selectedGrado = user['grade'];
    if(user['cip'] != null && user['cip'] != '') {
      setState(() {
        this._isChecked = true;
      });
    } else {
      setState(() {
        this._isChecked = false;
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

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() { showPersonalData = false; });
      } else {
        setState(() { showPersonalData = true; });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      extendBody: true,
      body: _buildBodyEdit(),
      drawer: _hasEmail ? _buildDrawer() : null,
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text("Perfil"),
      backgroundColor: Color.fromRGBO(2, 29, 38, 1.0),
      centerTitle: true,
    );
  }

  Widget _buildBodyEdit() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(2, 29, 38, 1.0),
                  Color.fromRGBO(2, 29, 38, 0.9)
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(90)
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  //child: Image.asset('images/avatar/avatar01.jpg'),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(242, 240, 242, 1),
                    border: Border.all(style: BorderStyle.solid, color: Colors.white, width: 5),
                    image: DecorationImage(image: AssetImage('images/avatar/avatar' + user['avatar'] + '.jpg'))
                  ),
                  width: 100,
                  height: 100,
                  child: Align(
                    child: Container(
                      child: GestureDetector(
                        child: Icon(Icons.edit, color: Colors.white, size: 15),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AvatarPickerPage(),
                              ));
                          },
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      width: 25,
                      height: 25,
                    ),
                    alignment: Alignment(1, -1),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.solidIdCard, color: Colors.white, size: 18),
                      SizedBox(width: 10),
                      Text(user['document_number'], style: TextStyle(color: Colors.white)),
                    ],
                  )
                )
              ],
            ),
          ),
          Scrollbar(
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  /*
                  showPersonalData ? Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      enabled: false,
                      controller: docNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          isDense: true,
                          icon: Icon(
                            FontAwesomeIcons.addressCard,
                            color: Color.fromRGBO(2, 29, 38, 1.0),
                          ),
                          hintStyle: TextStyle(fontSize: 14, color: Colors.black),
                          border: InputBorder.none
                      ),
                    ),
                  ) : Container(),
                  */
                  showPersonalData ? Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      controller: firstNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          isDense: true,
                          icon: Icon(
                            FontAwesomeIcons.userCircle,
                            color: Color.fromRGBO(2, 29, 38, 1.0),
                          ),
                          hintText: 'Nombres',
                          hintStyle: TextStyle(fontSize: 14)),
                    ),
                  ) : Container(),
                  showPersonalData ? Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      controller: lastNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          isDense: true,
                          icon: Icon(
                            FontAwesomeIcons.userCircle,
                            color: Color.fromRGBO(2, 29, 38, 1.0),
                          ),
                          hintText: 'Apellidos',
                          hintStyle: TextStyle(fontSize: 14)),
                    ),
                  ) : Container(),
                  showPersonalData ? Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          isDense: true,
                          icon: Icon(
                            FontAwesomeIcons.envelope,
                            color: Color.fromRGBO(2, 29, 38, 1.0),
                          ),
                          hintStyle: TextStyle(fontSize: 14),
                          hintText: 'Correo electrónico'),
                    ),
                  ) : Container(),
                  showPersonalData ? SizedBox(height: 10) : SizedBox(),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Checkbox(
                            value: _isChecked,
                            activeColor: Color.fromRGBO(2, 29, 38, 1.0),
                            onChanged: (bool val) => setState(() { _isChecked = val; showPersonalData = true; })
                        ),
                        Expanded(
                            child: Container(
                                child: Text('Soy integrante de "La Marina de Guerra del Peru"', style: TextStyle(fontSize: 13)),
                                padding: EdgeInsets.only(right: 10.0)
                            )
                        )
                      ],
                    ),
                  ),
                  _isChecked ? Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            controller: cipController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(8),
                              BlacklistingTextInputFormatter(
                                  new RegExp('[\\-|\\.|\\,|\\ ]'))
                            ],
                            decoration: InputDecoration(
                                icon: Icon(
                                  FontAwesomeIcons.addressCard,
                                  size: 18,
                                  color: Color.fromRGBO(2, 29, 38, 1.0),
                                ),
                                hintText: 'CIP',
                                hintStyle: TextStyle(fontSize: 14),
                                contentPadding: EdgeInsets.only(bottom: 5)
                            ),
                            focusNode: _focusNode,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: DropdownButton(
                            hint: Text("Grado"),
                            value: _selectedGrado,
                            items: _grados.map((grado) {
                              return DropdownMenuItem(
                                child: Text(grado),
                                value: grado,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedGrado = value;
                              });
                            },
                            underline: Container(),
                          ),
                        ),
                      ],
                    ),
                  ) : Container(),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
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
                            'Registrar'.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          onPressed: () => update()
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  void update() {
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
                    this.putRequest().then((http.Response response) {
                      if (response.statusCode == 200) {
                        Preference.load();
                        Preference.setString('user', jsonEncode(this.user));
                        Alert(
                          context: context,
                          title: "Éxito!",
                          desc: "Los datos de su perfil han sido actualizados con éxito.",
                          type: AlertType.success,
                          closeFunction: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookListPage(),
                                ));
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

  Future<http.Response> putRequest() async {
    this.user['names'] = firstNameController.text;
    this.user['last_names'] = lastNameController.text;
    this.user['email'] = emailController.text;
    this.user['cip'] = cipController.text;
    this.user['grade'] = _selectedGrado;
    this.user['updated_date'] = DateTime.now().millisecond;

    //encode Map to JSON
    var body = json.encode(this.user);

    var response = await http.put(
        Uri.encodeFull(Constants.url_user + this.user['idt_user'].toString()),
        headers: {"Content-Type": "application/json"}, body: body);
    return response;
  }
}
