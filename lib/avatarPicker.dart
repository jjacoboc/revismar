import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile.dart';
import 'sharedPreferencesHelper.dart';

class AvatarPickerPage extends StatefulWidget {
  @override
  _AvatarPickerPageState createState() => _AvatarPickerPageState();
}

class _AvatarPickerPageState extends State<AvatarPickerPage> {

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
      body: _buildScrollView(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text("Elige un Avatar"),
      backgroundColor: Color.fromRGBO(2, 29, 38, 1.0),
      centerTitle: true,
    );
  }

  Widget _buildScrollView() {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.all(3.0),
          sliver: SliverGrid.count(
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            crossAxisCount: 4,
            children: getAvatars(),
          ),
        )
      ],
    );
  }

  List<Widget> getAvatars() {
    List<Widget> listImages = new List<Widget>();
    for (int i = 1; i <= 16; i++) {
      String str = i < 10 ? "0" + i.toString() : i.toString();
      listImages.add(
          Container(
            color: Colors.grey,
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(242, 240, 242, 1),
                    border: Border.all(
                        style: BorderStyle.solid, color: Colors.white, width: 5),
                    image: DecorationImage(
                        image: AssetImage('images/avatar/avatar' + str + '.jpg'),
                        fit: BoxFit.scaleDown
                    ),
                ),
                width: 10,
                height: 10,
              ),
              onTap: () { this.onTapHandle(str); },
            ),
          )
      );
    }
    return listImages;
  }

  onTapHandle(String value) {
    setState(() {
      user['avatar'] = value;
    });
    Preference.setString('user', jsonEncode(this.user));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        )
    );
  }
}
