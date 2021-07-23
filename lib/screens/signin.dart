import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rest_app/apis/api.dart';
import 'package:http/http.dart' as http;
import 'package:rest_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  String formName = 'login';
  bool isLoading = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<ScaffoldState>_scaffoldKey = GlobalKey();
  // Initially password is obscure
  bool _obscureText = true;
    // Toggles the password show status
  void _togglePasswordStatus() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    FocusNode emailF = new FocusNode();
    FocusNode passwordF = new FocusNode();
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/background.jpg",
                fit: BoxFit.fill,
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      "assets/logo.png",
                      height: 103,
                      width: 260,
                      alignment: Alignment.center,
                    )
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  /*
                  Container(
                    child: Text(
                      "Faça seu login",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.black,
                          letterSpacing: 1,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),*/
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            focusNode: emailF,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                            controller: _emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white70,
                              contentPadding: EdgeInsets.only(top:40.0, left:30.0, right: 30.0),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.7),
                                borderSide: BorderSide(color: Colors.transparent, width: 3.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.7),
                                borderSide: BorderSide(color: Colors.transparent, width: 3.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.7),
                                borderSide: BorderSide(color: Colors.black12, width: 3.0),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.7),
                                  borderSide: BorderSide(color: Colors.transparent, width: 3.0)),
                              hintText: "Login",
                              hintStyle: TextStyle(
                                color: Colors.black87, fontSize: 22
                              ),
                            ),
                            onSaved: (val) {
                              email = val;
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            focusNode: passwordF,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                            controller: _passwordController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white70,
                              contentPadding: EdgeInsets.only(top:40.0, left:30.0, right: 10.0),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.7),
                                borderSide: BorderSide(color: Colors.transparent, width: 3.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.7),
                                borderSide: BorderSide(color: Colors.transparent, width: 3.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.7),
                                borderSide: BorderSide(color: Colors.black12, width: 3.0),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.7),
                                  borderSide: BorderSide(color: Colors.black, width: 50.0)),
                              hintText: "Senha",
                              suffixIcon:  IconButton(
                                padding: EdgeInsets.only(left:5.0, right: 10.0),
                                icon:Icon(_obscureText ? Icons.visibility:Icons.visibility_off,),
                                onPressed: _togglePasswordStatus,
                                color: Colors.black87,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.black87, fontSize: 22
                              ),
                            ),
                            onSaved: (val) {
                              email = val;
                            },
                            obscureText: _obscureText,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if(isLoading)
                                    {
                                      return;
                                    }
                                  if(_emailController.text.isEmpty||_passwordController.text.isEmpty)
                                  {
                                    if(_emailController.text.isEmpty)
                                    {
                                      AlertDialog alert = AlertDialog(
                                        title: Text('Por favor, preencha o campo login'),
                                      );
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                      emailF.requestFocus();
                                      return;
                                    } else if(_passwordController.text.isEmpty)
                                    {
                                      AlertDialog alert = AlertDialog(
                                        title: Text('Por favor, preencha o campo senha'),
                                      );
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                      passwordF.requestFocus();
                                      return;
                                    }
                                  }
                                  login(_emailController.text, _passwordController.text, formName);
                                  setState(() {
                                    isLoading=true;
                                  });
                                  //Navigator.pushReplacementNamed(context, "/home");
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 0),
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Text(
                                    "ENVIAR",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            letterSpacing: 1)),
                                  ),
                                ),
                              ),
                              Positioned(child: (isLoading)?Center(child: Container(height:26,width: 26,child: CircularProgressIndicator(backgroundColor: Colors.green,))):Container(),right: 30,bottom: 0,top: 0,)

                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(1, 10, 1, 10),
                            child: Text(
                              "versão 1.0.9",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  login(email, password, formName) async
  {
    Map data = {
      'email': email,
      'password': password,
      'form': formName
    };
    try {
      final response = await http.post(
        LOGIN,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8")
      ).timeout(Duration(seconds: 20));

      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {  
        //print(response.body);
        Map<String,dynamic>resposne=jsonDecode(response.body);
        if(!resposne['error'])
        {
          Map<String,dynamic>user=resposne['data'];
          savePref(1,user['name'],user['email'],user['id']);
          
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondRoute()));
          
        }else{
          //print(" ${resposne['message']}");
          showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text("${resposne['message']}"),
              //content: new Text("Hey! I'm Coflutter!"),
            )
          ).then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => super.widget))
          );
        }
        //_scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("${resposne['message']}")));
      } else {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text("Ocorreu um erro! por favor, tente novamente"),
            )
          ).then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => super.widget))
          );
        //_scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Ocorreu um erro! por favor, tente novamente")));
      }
    } on TimeoutException catch (e) {
      print(e.duration);
      showDialog(
        context: context,
        builder: (_) => new AlertDialog(
        title: new Text("Não foi possível completar a requisição, por favor entre em contato com o suporte"),
          //content: new Text("Hey! I'm Coflutter!"),
        )
      ).then((value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => super.widget))
      );
    }
  }
  savePref(int value, String name, String email, int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.setInt("value", value);
      preferences.setString("name", name);
      preferences.setString("email", email);
      preferences.setString("id", id.toString());
  }
  
}
class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}