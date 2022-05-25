import 'package:infoklinik/view/klinik.dart';
import 'package:flutter/material.dart';

class Pilihmenu extends StatefulWidget {
  String title;
  Pilihmenu({this.title});

  @override
  _PilihmenuState createState() => _PilihmenuState();
}

class _PilihmenuState extends State<Pilihmenu> {
  String menu;

  menubar() {
    menu = widget.title;
    if (menu == 'klinik') {
      return Klinik();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      child: menubar(),
    ));
  }
}
