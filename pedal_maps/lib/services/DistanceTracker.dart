import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'dart:math';

class DistanceTracker {
  geolocator.Position _currentPosition;
  double _totalDistance;
  var _isTrackingDistance;
  List<LatLng> positions;
  Timer _timer;
  Duration timerInterval;
  Set<Polyline> _polylines = {};

  bool serviceEnabled;
  location.Location currentLocation = location.Location();
  location.PermissionStatus permissionGranted;

  //Constructor
  DistanceTracker() {
    _totalDistance = 0;
    _isTrackingDistance = false;
    positions = new List<LatLng>();
    timerInterval = Duration(seconds: 2);
    _timer = Timer.periodic(timerInterval, addDistance);

    getPermission();
  }

  void startTrackingDistance() async {
    _currentPosition = await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high);
    positions
        .add(LatLng(_currentPosition.latitude, _currentPosition.longitude));
    _isTrackingDistance = true;
  }

  void pauseTrackingDistance() async {
    _isTrackingDistance = false;
  }

  void stopTrackingDistance() {
    _totalDistance = 0;
    positions.clear();
    _isTrackingDistance = false;
  }

  /*must get users permission to access location*/
  void getPermission() async {
    /*location services check*/
    serviceEnabled = await currentLocation.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await currentLocation.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    /*users permission check*/
    permissionGranted = await currentLocation.hasPermission();
    if (permissionGranted == location.PermissionStatus.denied) {
      permissionGranted = await currentLocation.requestPermission();
      if (permissionGranted != location.PermissionStatus.granted) {
        return;
      }
    }
  }

  //gets called every 5 seconds
  void addDistance(_) async {
    if (_isTrackingDistance) {
      _currentPosition = await geolocator.Geolocator.getCurrentPosition(
          desiredAccuracy: geolocator.LocationAccuracy.high);
      _totalDistance += geolocator.Geolocator.distanceBetween(
          positions.last.latitude,
          positions.last.longitude,
          _currentPosition.latitude,
          _currentPosition.longitude);
      positions
          .add(LatLng(_currentPosition.latitude, _currentPosition.longitude));

      _polylines.add(Polyline(
        polylineId: PolylineId("Where you been"),
        visible: true,
        points: positions,
        color: Colors.blue,
      ));
    }
  }

  geolocator.Position getCurrentLocation() {
    return _currentPosition;
  }

  Set<Polyline> getPolylines() {
    return _polylines;
  }

  double printDistanceInMiles() {
    return (_totalDistance / 1609);
  }

  List<LatLng> getPositions() {
    return positions;
  }

  double getCurrentBearing() {
    if (positions.length < 2) {
      return 180;
    }
    double x, y, B, dL;
    LatLng b = positions.last;
    LatLng a = positions[positions.length - 2];

    dL = a.longitude - b.longitude;

    x = cos(b.latitude) * sin(dL);
    y = cos(a.latitude) * sin(b.latitude) -
        sin(a.latitude) * cos(b.latitude) * cos(dL);
    B = atan2(x, y);
    B = B * 180 / pi;
    return B;
  }
}
