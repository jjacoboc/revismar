import 'dart:io';
import 'dart:convert';
import 'profile.dart';
import 'bookViewList.dart';
import 'changePassword.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'sharedPreferencesHelper.dart';

class SuscriptionPage extends StatefulWidget {
  @override
  _SuscriptionPageState createState() => _SuscriptionPageState();
}

class _SuscriptionPageState extends State<SuscriptionPage> {

  Map<String, dynamic> user;

  @override
  initState() {
    super.initState();
    Preference.load();
    user = jsonDecode(Preference.getString('user'));
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _buildAppBar(),
      extendBody: true,
      body: _buildBody(),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(""),
      backgroundColor: Color.fromRGBO(2, 29, 38, 1.0),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height / 2.7,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(2, 29, 38, 1.0),
                    Color.fromRGBO(2, 29, 38, 0.8)
                  ],
                ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(201, 135, 47, 1),
                  offset: Offset(0, 5)
                )
              ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(242, 240, 242, 1),
                    border: Border.all(
                        style: BorderStyle.solid, color: Colors.white, width: 5),
                    image: DecorationImage(
                        image: AssetImage('images/finances_gray_icon.jpg'),
                        fit: BoxFit.scaleDown
                    ),
                  ),
                  width: 60,
                  height: 60,
                ),
                Container(
                  child: Text('Información de Suscripción', style: TextStyle(color: Colors.white, fontSize: 20)),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.email,
                        color: Color.fromRGBO(2, 29, 38, 1.0),
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text('revismar@marina.pe', style: TextStyle(fontSize: 14, color: Colors.black))
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.phone_in_talk,
                        color: Color.fromRGBO(2, 29, 38, 1.0),
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text('2078900 anexo 2356', style: TextStyle(fontSize: 14, color: Colors.black))
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.solidBuilding,
                        color: Color.fromRGBO(2, 29, 38, 1.0),
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                          child: Text('Av. Insurgentes s/n ( Cuadra 36 Av. La Marina) La Perla, Callao.', style: TextStyle(fontSize: 14, color: Colors.black))
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        color: Color.fromRGBO(2, 29, 38, 1.0),
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                          child: Text('8:00 am.– 13:00 pm. / 14:30 pm. - 16.30 pm. / Lunes–Viernes', style: TextStyle(fontSize: 14, color: Colors.black))
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height / 2.7,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(2, 29, 38, 1.0),
                    Color.fromRGBO(2, 29, 38, 0.8)
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(201, 135, 47, 1),
                      offset: Offset(0, 5)
                  )
                ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(242, 240, 242, 1),
                    border: Border.all(
                        style: BorderStyle.solid, color: Colors.white, width: 5),
                    image: DecorationImage(
                        image: AssetImage('images/link.png'),
                        fit: BoxFit.scaleDown
                    ),
                  ),
                  width: 60,
                  height: 60,
                ),
                Container(
                  child: Text('Enlaces de Interés', style: TextStyle(color: Colors.white, fontSize: 20)),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.facebook,
                        color: Color.fromRGBO(2, 29, 38, 1.0),
                        size: 20,
                      ),
                      Expanded(
                        child: FlatButton(
                          onPressed: () => launch('http://patrimoniodocumentalnaval.mil.pe/'),
                          child: Text(
                              'Patrimonio Documental de la Marina de Guerra del Perú',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                          ),
                          textColor: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.local_library,
                        color: Color.fromRGBO(2, 29, 38, 1.0),
                        size: 20,
                      ),
                      Expanded(
                        child: FlatButton(
                          onPressed: () => launch('https://www.iehmp.org.pe'),
                          child: Text(
                            'Instituto de Estudios Histórico-Marítimos del Perú',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          textColor: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.home,
                        color: Color.fromRGBO(2, 29, 38, 1.0),
                        size: 20,
                      ),
                      FlatButton(
                        onPressed: () => launch('https://es-la.facebook.com/museonaval.delperu'),
                        child: Text(
                          'Museos Navales del Perú',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        textColor: Colors.blue[900],
                      ),
                    ],
                  ),
                ),
              ],
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
}