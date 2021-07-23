import 'package:flutter/material.dart';

import 'package:rest_app/screens/home.dart';
import 'package:rest_app/screens/signin.dart';
import 'package:rest_app/screens/signup.dart';

//import 'package:shared_preferences/shared_preferences.dart'; removido para sempre fazer o login


void main() {
  runApp(MaterialApp(home: MyApp(),));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //getPref(); removido para sempre fazer o login
  }
  @override
  Widget build(BuildContext context) {
    //var _loginStatus=0; removido para sempre fazer o login
    return MaterialApp(
      home: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            "assets/background.jpg",
            fit: BoxFit.fill,
          ),
        ),
        //(_loginStatus==1)?Home():SignIn() removido para sempre fazer o login
        SignIn()
      ],),
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signin': (BuildContext context) => new SignIn(),
        '/signup': (BuildContext context) => new SignUp(),
        '/home': (BuildContext context) => new Home(),
      },
    );
  }
  
  getPref() async {
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      //_loginStatus = preferences.getInt("value"); removido para sempre fazer o login
    });
  }
}
