import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoklinik/view/about.dart';
import 'package:infoklinik/view/home.dart';
import 'package:infoklinik/view/profile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

String notifikasi;

class _MainMenuState extends State<MainMenu> {
  signOut() {
    if (this.mounted) {
      setState(() {
        widget.signOut();
      });
    }
  }

  String username = "", nama = "", userid = "";
  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        username = preferences.getString("user");
        nama = preferences.getString("nama");
        userid = preferences.getString("id");
        // getPesan(userid);
      });
    }
  }

  @override
  initState() {
    if (this.mounted) {
      super.initState();
      getPref();
    }
  }

  @override
  void dispose() {
    // sub.dispose();
    if (mounted) {
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          title: Row(
            children: [
              new Image.asset(
                "gambar/logo.png",
                width: 40,
                height: 40,
              ),
              SizedBox(
                width: 20.0,
              ),
              new Text(
                "Informasi klinikQ",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                signOut();
              },
              color: Colors.white,
              icon: Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: DefaultTextStyle(
          style:
              GoogleFonts.poppins().copyWith(color: Colors.black, fontSize: 13),
          child: TabBarView(
            children: <Widget>[
              Home(),
              Profile(),
              About(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.green,
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.green[900],
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
                child: new Text(
                  "Home",
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Tab(
                icon: Icon(Icons.account_circle),
                child: new Text(
                  "Account",
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Tab(
                icon: Icon(Icons.info),
                child: new Text(
                  "About",
                  style: TextStyle(fontSize: 12.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildIconBadge(
  IconData icon,
  String badgeText,
  Color badgeColor,
) {
  return Stack(
    children: <Widget>[
      Icon(
        icon,
        size: 30.0,
      ),
      Positioned(
        top: 2.0,
        right: 4.0,
        child: Container(
          padding: EdgeInsets.all(1.0),
          decoration: BoxDecoration(
            color: badgeColor,
            shape: BoxShape.circle,
          ),
          constraints: BoxConstraints(
            minWidth: 18.0,
            minHeight: 18.0,
          ),
          child: Center(
            child: Text(
              badgeText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
