import 'package:flutter/material.dart';
import 'login.dart';

class SplashScreen_ extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen_> {

  bool _first = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 3), () {
        setState(() {
          _first = false;
        });
        Future.delayed(
          Duration(seconds: 5), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              )
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Revismar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Color.fromRGBO(2, 29, 38, 1.0),
      ),
      home: Stack(
        fit: StackFit.expand,
          children: <Widget>[
            AnimatedCrossFade(
                firstChild: Container(
                  decoration: BoxDecoration(color: Color.fromRGBO(2, 29, 38, 1.0)),
                  child: Center (
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'images/header-logo.png',
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
                secondChild: Center(
                  child: Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(2, 29, 38, 1.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'images/caratula.jpg',
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                ),
                crossFadeState: _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: Duration(seconds: 5),
                alignment: Alignment.center,
            ),
            /*
            Container(
              decoration: BoxDecoration(color: Color.fromRGBO(2, 29, 38, 1.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/caratula.jpg',
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
            */
          ],
      ),
    );
  }
}
