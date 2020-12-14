import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// ignore_for_file: code-metrics

class Map extends StatefulWidget {
  @override
  _Map createState() => _Map();
}

class _Map extends State<Map> {

  //global variables
  StreamSubscription locationStream;
  Location currentLocation = Location();
  Marker marker;
  GoogleMapController mapController;
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  //get markerIcon.png from assets folder, convert it to Uint8 list return it
  Future<Uint8List> getMarkerImage() async {
    ByteData image = await DefaultAssetBundle.of(context).load(
        "assets/markerIcon.png");
    return image.buffer.asUint8List();
  }


  /*using the new location data, get new latitude and longitude, update state
  * https://developers.google.com/android/reference/com/google/android/gms/maps/model/Marker
  */
  void updateMarkerLocation(LocationData newLocalData, Uint8List markerImage) {
    LatLng curLatLng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
        markerId: MarkerId("root"),
        position: curLatLng,
        draggable: false,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(markerImage),
      );
    });
  }


  /*must get users permission to access location*/
  void getPermission() async
  {
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
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await currentLocation.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  /*get permission, marker image, location, then update marker location
  * add listener for location change, we want camera to 'follow' marker
  * update camera position using new latitude and longitude
  */
  void getCurrentLocation() async {
    getPermission();
    Uint8List imagePing = await getMarkerImage();
    var location = await currentLocation.getLocation();
    updateMarkerLocation(location, imagePing);

    if (locationStream != null)
      locationStream.cancel();

    locationStream = currentLocation.onLocationChanged.listen((newLocalData) {
      if (mapController != null) {
        mapController.animateCamera(
            CameraUpdate.newCameraPosition(new CameraPosition(
                bearing: 192.8,
                target: LatLng(newLocalData.latitude, newLocalData.longitude),
                zoom: 18.00)));
        updateMarkerLocation(newLocalData, imagePing);
      }
    });
  }

  @override
  //clean up
  void dispose() {
    if (locationStream != null) {
      locationStream.cancel();
    }
    super.dispose();
  }

  @override
  //default camera position, check if marker needs to me set or not
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(39.7285, -121.837479),
                zoom: 16.00
              ),
              markers: Set.of((marker != null) ? [marker] : []),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            FloatingActionButton(onPressed: (){
              getCurrentLocation();
            }),
          ],
        ),
    );
  }
}



