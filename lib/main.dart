import 'package:flutter/material.dart';
import 'splash.dart';

void main() => runApp(MaterialApp(
      theme:
          ThemeData(primaryColor: Color.fromRGBO(10, 65, 123, 1.0), accentColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ));
