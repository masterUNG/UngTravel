import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ungrunner/utility/dialog.dart';
import 'package:ungrunner/utility/my_constant.dart';
import 'package:ungrunner/utility/my_style.dart';
import 'package:ungrunner/widgets/show_progress.dart';

class Runner extends StatefulWidget {
  @override
  _RunnerState createState() => _RunnerState();
}

class _RunnerState extends State<Runner> {
  double lat, lng, lat1, lng1, lat2, lng2;
  Map<MarkerId, Marker> markers = {};
  bool status = true, setupLatLng = true, statusSave = true;
  int timeRunner = 0;
  double myDistance = 0;

  List<LatLng> latlngs = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  List<double> lats = [];
  List<double> lngs = [];

  String showTimeString, showDisplayString = '';

  @override
  void initState() {
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    Position position = await findPosition();
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
      print('lat = $lat, lng = $lng');
      latlngs.add(LatLng(lat, lng));
      lats.add(lat);
      lngs.add(lng);
      addPolyLine();
      if (setupLatLng) {
        setupLatLng = false;
        lat1 = lat;
        lng1 = lng;
      } else {
        lat2 = lat;
        lng2 = lng;

        setState(() {
          myDistance = myDistance + calculateDistance(lat1, lng1, lat2, lng2);

          var myFormat = NumberFormat('#.##', 'en_US');
          showDisplayString = myFormat.format(myDistance);

          print('######### myDistance ==>>> $myDistance #######');
          lat1 = lat2;
          lng1 = lng2;
        });
      }

      MarkerId markerId = MarkerId('id');
      Marker marker = Marker(
        markerId: markerId,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: 'You Here !!!'),
      );
      markers[markerId] = marker;
    });
  }

  void addPolyLine() {
    PolylineId id = PolylineId('id');
    Polyline polyline = Polyline(width: 4,color: Colors.red.shade700,
      polylineId: id,
      points: latlngs,
    );
    polylines[id] = polyline;
  }

  Future<Position> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildElevatedButton(),
          SizedBox(
            width: 4,
          ),
          buildSave()
        ],
      ),
      appBar: AppBar(
        backgroundColor: MyStyle().primary,
        title: Text('Runner'),
      ),
      body: lat == null
          ? ShowProgress()
          : Center(
              child: Column(
                children: [
                  buildShowMap(context),
                  Text(
                    showTimeString == null ? '' : 'TimeRunner $showTimeString',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    'Distance = $showDisplayString km',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
    );
  }

  ElevatedButton buildSave() => ElevatedButton(
        onPressed: () {
          if (statusSave) {
            normalDialog(
                context, 'Non Start ?', 'Please Tap Start for Record Runner');
          } else if (!status) {
            normalDialog(
                context, 'Tap Stop', 'Please Tap Stop for Record Data');
          } else {
            insertRunner();
          }
        },
        child: Text('Save Runner'),
      );

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
  }

  Future<Null> counterTime() async {
    print('countTime Work');
    Duration duration = Duration(seconds: 5);
    await Timer(duration, () {
      findLatLng();
      timeRunner += 5;
      changeSecToTime(timeRunner);

      if (!status) {
        counterTime();
      }
    });
  }

  void changeSecToTime(int sec) {
    Duration duration = Duration(seconds: sec);
    String hour(int n) => n.toString().padLeft(2, "0");
    String minus = hour(duration.inMinutes.remainder(60));
    String second = hour(duration.inSeconds.remainder(60));
    setState(() {
      showTimeString = '${hour(duration.inHours)}:$minus:$second';
    });
  }

  ElevatedButton buildElevatedButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: status ? Colors.green : Colors.red),
        onPressed: () {
          setState(() {
            status = !status;
            statusSave = false;
          });
          if (!status) {
            counterTime();
          }
        },
        child: Text(status ? 'Start' : 'Stop'),
      );

  Container buildShowMap(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.6,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, lng),
          zoom: 16,
        ),
        onMapCreated: (controller) {},
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }

  Future<Null> insertRunner() async {
    String idUser = '1';

    DateTime dateTime = DateTime.now();
    String dateRunner = dateTime.toString();

    String listLat = lats.toString();
    String listLng = lngs.toString();

    String path =
        '${MyConstant().domain}/ungtravel/insertRunner.php?isAdd=true&idUser=$idUser&dateRunner=$dateRunner&timeRunner=$timeRunner&distance=$myDistance&listLat=$listLat&listLng=$listLng';

    await Dio().get(path).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'Error', 'Please Try Again');
      }
    });
  }
}
