import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrailPage extends StatefulWidget {
  final DocumentSnapshot trail;

  TrailPage({this.trail});

  @override
  _TrailPageState createState() => _TrailPageState();
}

class _TrailPageState extends State<TrailPage> {

  GoogleMapController mapController;
  Set<Polyline> _routemarkers = {};
  List<LatLng> points = [];
  int x = 0;

  void _drawRoute() {
    for (var i = 0; i < widget.trail.get("positions").length; i++) {
      GeoPoint geo = widget.trail.get("positions")[i];
      points.add(new LatLng(geo.latitude, geo.longitude));
    }
    _routemarkers.add(Polyline(
      polylineId: PolylineId("one"),
      visible: true,
      points: points,
      color: Colors.blue,
    ));
  }

  String _gravelType(){
    if(widget.trail.get("pavement") == true) {
      return "Road";
    }
    else{
      return "Off-Road";
    }
  }

  @override
  void initState() {
    _drawRoute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Pedal Maps'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: points[0],
                  zoom: 16,
                ),
                zoomGesturesEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                polylines: _routemarkers,
              ),
              width: 350,
              height: 400,
              padding: new EdgeInsets.only(top: 25),
            ),
            SizedBox(
              height: 25.0,
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    widget.trail.get("trailName"),
                    style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    "Total Distance: ${widget.trail.get("totalDistance").toStringAsFixed(2)} miles",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    "Difficulty: ${widget.trail.get("difficulty").toString()}",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    "Type: ${_gravelType()}",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
