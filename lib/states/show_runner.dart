import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ungrunner/models/runner_model.dart';
import 'package:ungrunner/widgets/show_progress.dart';

class ShowRunner extends StatefulWidget {
  final RunnerModel runnerModel;
  ShowRunner({@required this.runnerModel});
  @override
  _ShowRunnerState createState() => _ShowRunnerState();
}

class _ShowRunnerState extends State<ShowRunner> {
  RunnerModel runnerModel;
  List<LatLng> latlngs = [];
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    runnerModel = widget.runnerModel;

    List<double> lats = stringToListDouble(runnerModel.listLat);
    List<double> lngs = stringToListDouble(runnerModel.listLng);

    int index = 0;
    for (var item in lats) {
      LatLng latLng = LatLng(item, lngs[index]);
      setState(() {
        latlngs.add(latLng);
      });
      index++;
    }

    PolylineId id = PolylineId('id');
    Polyline polyline = Polyline(
      polylineId: id,
      points: latlngs,width: 4,color: Colors.red.shade700,
    );
    polylines[id] = polyline;
  }

  List<double> stringToListDouble(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    List<double> results = [];
    for (var item in strings) {
      String string = item.trim();
      double d = double.parse(string);
      results.add(d);
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(runnerModel.dateRunner),
      ),
      body: latlngs.length == 0
          ? ShowProgress()
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: latlngs[1],
                zoom: 16,
              ),
              onMapCreated: (controller) {},
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }
}
