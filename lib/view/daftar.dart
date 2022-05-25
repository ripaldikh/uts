import 'dart:convert';
import 'package:infoklinik/model/api.dart';
import 'package:infoklinik/view/login.dart';
import 'package:infoklinik/view/mainmenu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Daftar extends StatefulWidget {
  @override
  _DaftarState createState() => _DaftarState();
}

enum DaftarStatus { notSignIn, signIn }

class _DaftarState extends State<Daftar> {
  DaftarStatus _DaftarStatus = DaftarStatus.notSignIn;
  String username, password, jabatan, nama_lengkap, no_hp, alamat;
  final _key = new GlobalKey<FormState>();
  String msg = "";
  bool _secureText = true;
  bool _apiCall = false;

  showHide() {
    if (this.mounted) {
      setState(() {
        _secureText = !_secureText;
      });
    }
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      if (this.mounted) {
        setState(() {
          _apiCall = true;
        });
      }
      daftar();
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

  void _snackbar(String str) {
    if (str.isEmpty) return;
    _scaffoldState.currentState.showSnackBar(new SnackBar(
      backgroundColor: Colors.green,
      content: new Text(str,
          style: new TextStyle(fontSize: 15.0, color: Colors.white)),
      duration: new Duration(seconds: 5),
    ));
  }

  daftar() async {
    final response = await http.post(BaseUrl.daftar, body: {
      "username": username,
      "password": password,
      "no_hp": no_hp,
      "nama_lengkap": nama_lengkap,
      "alamat": alamat
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];

    if (value == 1) {
      _snackbar(pesan);
      setState(() {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => new Login()));
      });
    } else {
      _snackbar(pesan);
      setState(() {
        _apiCall = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (this.mounted) {
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: new Text("Daftar"),),
      key: _scaffoldState,
      body: Form(
        key: _key,
        child: new Container(
          padding: EdgeInsets.only(top: 50.0),
          // decoration: BoxDecoration(
          //     gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          //   Colors.green[900],
          //   Colors.green[700],
          //   Colors.green[500]
          // ])),
          child: new Center(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Daftar Akun",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Aplikasi KlinikQ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Flexible(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                alignment: Alignment.centerRight,
                                child: new Image.asset(
                                  "gambar/logo.png",
                                  width: 150,
                                  height: 100,
                                ),
                              )
                            ],
                          ))
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          bottomRight: Radius.circular(50))),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, 3),
                                    blurRadius: 5,
                                    offset: Offset(0, 2))
                              ]),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.green[200]))),
                                child: TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "Please insert nama lengkap";
                                    }
                                  },
                                  onSaved: (e) => nama_lengkap = e,
                                  decoration: InputDecoration(
                                      hintText: "Nama lengkap",
                                      hintStyle: TextStyle(
                                          color: Colors.black, fontSize: 12.0)),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.green[200]))),
                                child: TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "Please insert no handphone";
                                    }
                                  },
                                  onSaved: (e) => no_hp = e,
                                  decoration: InputDecoration(
                                      hintText: "No HP",
                                      hintStyle: TextStyle(
                                          color: Colors.black, fontSize: 12.0)),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.green[200]))),
                                child: TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "Please insert alamat";
                                    }
                                  },
                                  onSaved: (e) => alamat = e,
                                  decoration: InputDecoration(
                                      hintText: "Alamat lengkap",
                                      hintStyle: TextStyle(
                                          color: Colors.black, fontSize: 12.0)),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.green[200]))),
                                child: TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "Please insert username";
                                    }
                                  },
                                  onSaved: (e) => username = e,
                                  decoration: InputDecoration(
                                      hintText: "Username",
                                      hintStyle: TextStyle(
                                          color: Colors.black, fontSize: 12.0)),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.green[200]))),
                                child: TextFormField(
                                  obscureText: _secureText,
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "Please insert password";
                                    }
                                  },
                                  onSaved: (e) => password = e,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                        color: Colors.black, fontSize: 12.0),
                                    suffixIcon: IconButton(
                                      onPressed: showHide,
                                      icon: Icon(_secureText
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                            onTap: () {
                              check();
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.green),
                              child: Center(
                                child: _apiCall
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text(
                                        "Daftar Akun",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new Login()));
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blueGrey),
                              child: Center(
                                child: Text(
                                  "Kembali",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
