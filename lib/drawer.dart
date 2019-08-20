import 'changePassword.dart';
import 'profile.dart';
import 'package:flutter/material.dart';

Widget _buildDrawer(BuildContext context, Map<String, dynamic> user) {
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
              Icon(Icons.account_circle, color: Colors.white,),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(user['names'] + ' ' + user['last_names']),
              ),
            ],
          ),
          accountEmail: Row(
            children: <Widget>[
              Icon(Icons.email, color: Colors.white,),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(user['email']),
              ),
            ],
          ),
          otherAccountsPictures: <Widget>[
            Image.asset('images/mgp-ereader-logo.png')
          ],
          //currentAccountPicture: Image.asset('images/mgp-ereader-logo.png'),
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
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
          leading: Icon(Icons.bookmark),
          title: Text('Item 2'),
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
          leading: Icon(Icons.bookmark),
          title: Text('Item 3'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app, color: Colors.red),
          title: Text('Cerrar Sesión', style: TextStyle(color: Colors.red),),
          onTap: () {
            Navigator.pop(context);
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
              onPressed: () {}
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}