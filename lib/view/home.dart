import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoklinik/model/api.dart';
import 'package:infoklinik/view/detailklinik.dart';
import 'package:infoklinik/view/pilihmenu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Post {
  final String id;
  final String nama;
  final String alamat;
  final String nohp;
  final String layanan;
  final String latitude;
  final String longtitude;

  Post(this.id, this.nama, this.alamat, this.nohp, this.layanan, this.latitude,
      this.longtitude);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

String userid, username, namalengkap = "", jabatan, nik, foto, urlfoto;

class _HomeState extends State<Home> {
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userid = preferences.getString("id");
      username = preferences.getString("username");
      namalengkap = preferences.getString("nama");
      jabatan = preferences.getString("jabatan");
      nik = preferences.getString("nik");
      foto = preferences.getString("foto");
      urlfoto = foto;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  static final List<String> imgSlider = ['1.jpg', '2.jpg', '3.jpg', '4.jpg'];
  final CarouselSlider autoPlayImage = CarouselSlider(
    options: CarouselOptions(
      autoPlay: true,
      aspectRatio: 2.0,
      enlargeCenterPage: true,
    ),
    items: imgSlider.map((fileImage) {
      return Container(
        margin: EdgeInsets.all(2.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            'gambar/slider' + '/${fileImage}',
            fit: BoxFit.cover,
          ),
        ),
      );
    }).toList(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green,
      body: DefaultTextStyle(
        style:
            GoogleFonts.poppins().copyWith(color: Colors.black, fontSize: 13),
        child: Stack(
          children: [
            // Container(
            //   height: 200,
            //   //SAMA HALNYA DENGAN CONTAINER SEBELUMNYA, WARNANYA DI-SET DAN BORDERRADIUSNYA KALI INI BERBEDA KITA SET KE-4 SISINYA AGAR MELENGKUNG
            //   decoration: BoxDecoration(
            //     color: Colors.green,
            //     borderRadius: BorderRadius.only(
            //       bottomLeft: Radius.circular(20),
            //       bottomRight: Radius.circular(20),
            //     ),
            //   ),
            // ),
            ListView(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 10),
                  child: Text(
                    'Selamat datang !  ' + namalengkap ?? '',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                autoPlayImage,
                MenuUtama(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MenuUtama extends StatefulWidget {
  @override
  _MenuUtamaState createState() => _MenuUtamaState();
}

class _MenuUtamaState extends State<MenuUtama> {
  final SearchBarController<Post> _searchBarController = SearchBarController();

  bool isReplay = false;

  Future<List<Post>> _getALlPosts(String text) async {
    await Future.delayed(Duration(seconds: text.length == 4 ? 10 : 1));
    if (text.length == 6) return [];
    List<Post> posts = [];

    final response = await http.post(BaseUrl.getKlinik, body: {'nama': text});
    var data = jsonDecode(response.body);

    for (var i = 0; i < data.length; i++) {
      posts.add(Post(
          data[i]['id'],
          data[i]['nama'],
          data[i]['alamat'],
          data[i]['no_telp'],
          data[i]['layanan'],
          data[i]['latitude'],
          data[i]['longtitude']));
    }

    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 150,
      padding: EdgeInsets.all(8.0),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 1,
        children: <Widget>[
          SearchBar<Post>(
            searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
            headerPadding: EdgeInsets.symmetric(horizontal: 10),
            listPadding: EdgeInsets.all(5.0),
            onSearch: _getALlPosts,
            searchBarController: _searchBarController,
            hintText: 'Pencarian berdasarkan nama klinik ..',
            hintStyle: GoogleFonts.poppins().copyWith(
                color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
            // searchBarStyle: SearchBarStyle(backgroundColor: Colors.white),
            cancellationWidget: Text("Cancel"),
            emptyWidget: Center(child: NotFound()),
            onCancelled: () {
              print("Cancelled triggered");
            },
            minimumChars: 5,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            crossAxisCount: 1,
            onItemFound: (Post post, int index) {
              final formatter = new NumberFormat("#,###,###,###,###");

              return new GestureDetector(
                onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailKlinik(
                            id: post.id,
                            nama: post.nama,
                            alamat: post.alamat,
                            nohp: post.nohp,
                            layanan: post.layanan,
                            latitudeDes: double.parse(post.latitude),
                            longtitudeDes: double.parse(post.longtitude),
                          )))
                },
                child: Container(
                  child: new Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DefaultTextStyle(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        child: new ListTile(
                          title: new Text(post.nama ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          leading: CircleAvatar(
                              radius: 20.0,
                              backgroundImage: AssetImage('gambar/logo.png')),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.alamat,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                post.nohp,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                post.layanan,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Image.asset('gambar/404-error.png'));
  }
}
