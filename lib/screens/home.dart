import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rest_app/apis/api.dart';
import 'package:rest_app/screens/signin.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cpfcnpj/cpfcnpj.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
final _formKey = GlobalKey<FormState>();
String info;
String formName = 'info';
bool isLoading = false;
final maskCpf = MaskTextInputFormatter(mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
TextEditingController _info = new TextEditingController();
GlobalKey<ScaffoldState>_scaffoldKey=GlobalKey();

void clearFields() {
  _info.clear();
}
  @override
  Widget build(BuildContext context) {
    FocusNode infoF = new FocusNode();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black12,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                //color: Colors.white70,
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  "assets/background.jpg",
                  fit: BoxFit.fill,
                  //color: Colors.black26,
                ),
              ),
              Container(
                //width: MediaQuery.of(context).size.width * 0.70,
                //height: MediaQuery.of(context).size.height*0.70, 
                color: Colors.black12,
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
                      height: 40,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(1, 10, 1, 10),
                      child: Text(
                        "Informe o cpf do cliente",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                        margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                inputFormatters:[maskCpf],
                                focusNode: infoF,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                ),
                                controller: _info,
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
                                  hintText: "",
                                  hintStyle: TextStyle(
                                    color: Colors.black87, fontSize: 25
                                  ),
                                ),
                                onSaved: (val) {
                                  info = val;
                                },
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
                                      if(_info.text.isEmpty)
                                      {
                                        AlertDialog alert = AlertDialog(
                                          title: Text('Por favor, preencha a informação do cliente'),
                                        );
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return alert;
                                          },
                                        );
                                        infoF.requestFocus();
                                        return;
                                      } else if(!CPF.isValid(_info.text))
                                      {
                                        AlertDialog alert = AlertDialog(
                                          title: Text('Por favor, informe um cpf válido'),
                                        );
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return alert;
                                          },
                                        );
                                        infoF.requestFocus();
                                        return;
                                      }
                                      infopost(_info.text, formName);
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
                              )
                            ]
                          )
                      )
                    ),
                  ]
                ),
              ),
            ]
          )
        ),
      ),
    );
  }

  infopost(info, formName) async
  {
    Map data = {
      'info': info,
      'form': formName
    };
    try {
      final  response= await http.post(
          INFO,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8")
      ).timeout(Duration(seconds: 20));
      setState(() {
        isLoading=false;
      });
      if (response.statusCode == 200) {      
        Map<String,dynamic>resposne=jsonDecode(response.body);
        //print(resposne['data']);
        if(!resposne['error'])
        {
          if (!resposne['isCustomer']) {
            Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ThirdRoute(info, resposne['message'])));
          } else {
            //Map<String,dynamic>user=resposne['data'];
            final jsonList = resposne['data'] as List;
            final userList = jsonList.map((map) => User.fromJson(map)).toList();
            //savePref(1,userList);
            
            clearFields();
            Navigator.of(context).push(MaterialPageRoute(builder:(context)=>SecondRoute(info, userList, userList.length.toString())));
              //Navigator.push(context, "/home");
          }
          
        }else{
          //print(" ${resposne['message']}");
          showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text("${resposne['message']}"),
              //content: new Text("Hey! I'm Coflutter!"),
            )
          );
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${resposne['message']}")));
        }
      } else {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text("Ocorreu um erro! por favor, tente novamente"),
              //content: new Text("Hey! I'm Coflutter!"),
            )
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
            builder: (BuildContext context) => FirstRoute()))
      );
    }


  }

  savePref(int id, List userList) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setStringList("list", userList);
      preferences.setString("id", id.toString());
  }
}
class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignIn();
  }
}
// ignore: must_be_immutable
class SecondRoute extends StatefulWidget {
  String info;
  final userList;
  String total;
  SecondRoute(this.info, this.userList, this.total);
  @override
  State<StatefulWidget> createState() {
    return SecondRouteState(this.info, this.userList, this.total);
  }
}
class SecondRouteState extends State<SecondRoute> {
  String info;
  final userList;
  String total;
  SecondRouteState(this.info, this.userList, this.total);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              'Nova Pesquisa',
              textAlign: TextAlign.left,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 140,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: [
                        Text(
                          "Você pesquisou pelo cpf " + info,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: 1,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          "Resultado(s): " + total,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: 1,
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.80, // fixed height
                          child: ListView(
                            children: [getTextWidgets(userList)],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        /*child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 140,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: [
                        Text(
                          "Termo utilizado na pesquisa: " + info,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: 1,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [/*
                        Text(
                          "Nome: " + name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: 1,
                              fontSize: 40,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),*/
                      ]
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    /*Column(
                      children: [
                        Text(
                          "Status: " + status,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: 1,
                              fontSize: 40,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ]
                    ),*/
                  ]
                ),
              ),
            ],
          ),
        ),*/
      ),
    );
  }
}

/// THIRD ROUTE
// ignore: must_be_immutable
class ThirdRoute extends StatefulWidget {
  String cpf;
  String message;
  ThirdRoute(this.cpf, this.message);
  @override
  State<StatefulWidget> createState() {
    return ThirdRouteState(this.cpf, this.message);
  }
}
class ThirdRouteState extends State<ThirdRoute> {
  final _formKeyNew = GlobalKey<FormState>();
  TextEditingController _infoNew = new TextEditingController();
  bool isLoadingNew = false;
  String formNameNew = 'preregister';
  String info;
  String cpf;
  String message;
  final maskCpfNew = MaskTextInputFormatter(mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
  ThirdRouteState(this.cpf, this.message);
  void clearFields() {
  _infoNew.clear();
}
  @override
  Widget build(BuildContext context) {
    FocusNode infoFNew = new FocusNode();
    _infoNew.text = cpf;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              'Nova Pesquisa',
              textAlign: TextAlign.left,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 140,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: [
                        Text(
                          "Você pesquisou pelo cpf " + cpf,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: 1,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          message,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: 1,
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: <Widget>[
                        Form(
                          key: _formKeyNew,
                          child: Container(
                            margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                              child: Column(
                                children: <Widget>[
                                  Visibility(
                                    visible: false,
                                    child: 
                                      TextFormField(
                                        inputFormatters: [maskCpfNew],
                                        focusNode: infoFNew,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                        ),
                                        controller: _infoNew,
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
                                          hintText: "",
                                          hintStyle: TextStyle(
                                            color: Colors.black87, fontSize: 25
                                          ),
                                        ),
                                        onSaved: (val) {
                                          info = val;
                                        },
                                      ),
                                  ),
                                  
                                  Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if(isLoadingNew)
                                            {
                                              return;
                                            }
                                          if(_infoNew.text.isEmpty)
                                          {
                                            AlertDialog alert = AlertDialog(
                                              title: Text('Por favor, informe o CPF do cliente'),
                                            );
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              },
                                            );
                                            infoFNew.requestFocus();
                                            return;
                                          }
                                          infopostNew(_infoNew.text, formNameNew);
                                          setState(() {
                                            isLoadingNew=true;
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
                                            border: Border.all(color: Colors.black),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Text(
                                            "REALIZAR PRÉ CADASTRO",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    letterSpacing: 1)),
                                          ),
                                        ),
                                      ),
                                      Positioned(child: (isLoadingNew)?Center(child: Container(height:26,width: 26,child: CircularProgressIndicator(backgroundColor: Colors.green,))):Container(),right: 30,bottom: 0,top: 0,)
                                    ],
                                  )
                                ]
                              )
                          )
                        ),
                      ],
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

  infopostNew(info, formName) async
  {
    Map data = {
      'cpf': info,
      'form': formName
    };
    //print(data);
    try {
      final  response= await http.post(
          INFO,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8")
      ).timeout(Duration(seconds: 20));
      setState(() {
        isLoadingNew=false;
      });
      if (response.statusCode == 200) {      
        Map<String,dynamic>resposne=jsonDecode(response.body);
        print(resposne);
        if(!resposne['error'])
        {
          showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text("${resposne['message']}"),
              //content: new Text("Hey! I'm Coflutter!"),
            )
          ).then((value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Home())));
          
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
            builder: (BuildContext context) => Home())));
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${resposne['message']}")));
        }
      } else {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text("Ocorreu um erro! por favor, tente novamente"),
              //content: new Text("Hey! I'm Coflutter!"),
            )
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
            builder: (BuildContext context) => FirstRoute()))
      );
    }


  }

}

class User {
  final int id;
  final String nome;
  final String endereco;
  final String status;

  User._({this.id, this.nome, this.endereco, this.status});

    factory User.fromJson(Map<String, dynamic> json) {
      return new User._(
        id: json['id'],
        nome: json['nome'],
        endereco: json['endereco'],
        status: json['status'],
      );
    }
}
Widget getTextWidgets(List<User> strings){
  return new Column(
    children: strings.map(
      (item) => new Column(
        children: [
          Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: Container(
                  child: Text(
                    "Nome: " + item.nome,
                    textAlign: TextAlign.left,
                    style: 
                      GoogleFonts.roboto(
                        textStyle: 
                          TextStyle(
                            color: Colors.black,
                            letterSpacing: 1,
                            fontSize: 26,
                            fontWeight: FontWeight.normal,
                          ),
                      )
                  ),
                ),
              ),/*
              SizedBox(
                width: double.infinity,
                child: Container(
                  child: Text(
                    "Endereço: " + item.endereco,
                    textAlign: TextAlign.left,
                    style: 
                      GoogleFonts.roboto(
                        textStyle: 
                          TextStyle(
                            color: Colors.black,
                            letterSpacing: 1,
                            fontSize: 28,
                            fontWeight: FontWeight.normal,
                          ),
                      )
                  ),
                ),
              ),*/
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  child: Text(
                    "Status: " + item.status,
                    textAlign: TextAlign.left,
                    style: 
                      GoogleFonts.roboto(
                        textStyle: 
                          TextStyle(
                            color: Colors.black,
                            letterSpacing: 1,
                            fontSize: 26,
                            fontWeight: FontWeight.normal,
                          ),
                      )
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                width: double.infinity,
                height: 1,
                child: Container(
                  color: Colors.black26,
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ]
          ),
        ],
        //item.status + " - " + item.nome
      )
    ).toList()
  );
}