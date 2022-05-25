import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailKlinik extends StatefulWidget {
  String id, nama, alamat, nohp, layanan;
  double latitudeDes, longtitudeDes;
  DetailKlinik(
      {this.id,
      this.nama,
      this.alamat,
      this.nohp,
      this.layanan,
      this.latitudeDes,
      this.longtitudeDes});
  @override
  _DetailKlinikState createState() => _DetailKlinikState();
}

String userid, level;
String lat, long;

class _DetailKlinikState extends State<DetailKlinik> {
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

  String url;

  final Set<Marker> _markers = {};
  LatLng _position;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        userid = preferences.getString("id");
        level = preferences.getString("level");
      });
    }
  }

  @override
  void initState() {
    if (this.mounted) {
      // TODO: implement initState
      super.initState();
      getPref();
      if (this.mounted) {
        setState(() {
          lat = widget.latitudeDes.toString();
          long = widget.longtitudeDes.toString();
          _position = LatLng(double.parse(lat), double.parse(long));
          _markers.add(
            Marker(
              markerId:
                  MarkerId("${_position.latitude}, ${_position.longitude}"),
              position: _position,
              icon: BitmapDescriptor.defaultMarker,
            ),
          );
        });
      }
    }
  }

  @override
  void dispose() {
    if (this.mounted) {
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: new Text(
          'Detail Informasi Klinik',
          style: TextStyle(fontSize: 14.0, color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            new Container(
              child: Column(
                children: [
                  Divider(),
                  ListTile(
                    title: new Text('Nama Klinik'),
                    subtitle: new Text(widget.nama ?? ''),
                  ),
                  Divider(),
                  ListTile(
                    title: new Text('Alamat'),
                    subtitle: new Text(widget.alamat ?? ''),
                  ),
                  Divider(),
                  ListTile(
                    title: new Text('Telepon'),
                    subtitle: new Text(widget.nohp ?? ''),
                  ),
                  Divider(),
                  ListTile(
                    title: new Text('Fasilitas klinik'),
                    subtitle: new Text(widget.layanan ?? ''),
                  ),
                  Divider(),
                  new Container(
                      padding: EdgeInsets.all(8.0),
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      child: widget.latitudeDes == null ||
                              widget.longtitudeDes == null
                          ? Container()
                          : GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: _position,
                                zoom: 15.0,
                              ),
                              markers: _markers,
                            )),
                  Divider(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
