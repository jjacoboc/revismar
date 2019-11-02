import 'dart:convert';
import 'util.dart';
import 'login.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  final docNumberController = TextEditingController();
  String errorText = '';

  void reset() async {
    String number = docNumberController.text;
    if(number != ''){
      await http.get(
          Uri.encodeFull(Constants.url_login + Constants.DNI_Code + Constants.separator + number),
          headers: {"Accept": "application/json"}
        ).then((http.Response response) {
          if(response.statusCode == 200) {
            Map<String, dynamic> user = jsonDecode(response.body);
            http.post(
              Uri.encodeFull(Constants.url_resetPassword),
              //Uri.encodeFull('http://10.0.2.2:8084/reset/password/'),
                headers: {"Content-Type": "application/json"},
                body: json.encode(user)
            );
            Alert(
              context: context,
              title: Constants.alert_success_title,
              desc: "Se envió su nueva contraseña al correo electrónico: \n" + Util.obscureEmail(user['email']),
              type: AlertType.success,
              style: AlertStyle(isOverlayTapDismiss: false),
              closeFunction: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              }
            ).show();
          } else {
            setState(() {
              this.errorText = Constants.resetPass_error_docNumberNotFound;
              this.docNumberController.text = '';
            });
            this.cleanErrorMsg();
          }
      });
    } else {
      setState(() {
        this.errorText = Constants.resetPass_error_docNumberRequired;
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

  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(Constants.resetPass_title),
        backgroundColor: Color.fromRGBO(2, 29, 38, 1.0),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 40),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Image.asset('images/resetpass.png', width: 128, height: 128,),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    padding: EdgeInsets.only(top: 20, bottom:20, left: 16, right: 16),
                    child: Text(
                      Constants.resetPass_text,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                  ),
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
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid, width: 2.0)),
                        prefixIcon: Icon(
                          Icons.chrome_reader_mode,
                          color: Color.fromRGBO(2, 29, 38, 1.0),
                        ),
                        hintText: Constants.resetPass_hintText_DNI,
                        hintStyle: TextStyle(fontSize: 14)
                      ),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          child: Text(
                            Constants.resetPass_btn.toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          onPressed: () => reset()
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