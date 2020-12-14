import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore_for_file: code-metrics

class TrailData{
  String user = "";
  String trailName = "";
  int difficulty = 0;
  String hours = "";
  String minutes = "";
  String seconds = "";
  bool pavement = false;
  double totalDistance = 0.0;
  GeoPoint start;
  GeoPoint end;
  List<GeoPoint> positions = List<GeoPoint>();
}

void setTime(TrailData data, String h, String m, String s){
  data.hours = h;
  data.minutes = m;
  data.seconds = s;
}

void setDistance(TrailData data, double distance){
  data.totalDistance = distance;
}

void setUser(TrailData data, FirebaseAuth auth){
  final User user = auth.currentUser;
  final String uid = user.uid;
  data.user = uid;

}

void setStart(TrailData data, Position pos){
  if(data.start == null){
    data.start = GeoPoint(pos.latitude, pos.longitude);
  }
}

void setEnd(TrailData data, Position pos){
  if(data.end == null){
    data.end = GeoPoint(pos.latitude, pos.longitude);
  }
}

void setPositions(TrailData data, List<LatLng> pos){

  for(int i = 0; i < pos.length; i++){
    data.positions.add(GeoPoint(pos[i].latitude, pos[i].longitude));
  }
}

void addTrail(TrailData data, CollectionReference trails) {
  trails
  .add({
    'user': data.user,
    'trailName': data.trailName,
    'difficulty': data.difficulty,
    'hours': data.hours,
    'minutes': data.minutes,
    'seconds': data.seconds,
    'pavement': data.pavement,
    'totalDistance': data.totalDistance,
    'start': data.start,
    "end": data.end,
    "positions": data.positions
  })
      .then((value) => print("Trail Added"))
      .catchError((error) => print("Failed to add trail: $error"));

}

Widget buildTrailName(TrailData data){
  return TextFormField(
    validator: (value) => value.isEmpty ? "You must enter a trail name" : null,
    onSaved: (String value) {
      data.trailName = value;
    },
    decoration: InputDecoration(
        hintText: "Trail Name"
    ),
  );
}

Widget buildDifficulty(TrailData data){
  return DropdownButtonFormField<int>(
    onSaved: (val) {
      data.difficulty = val;
    },
    validator: (val) => val == null ? 'You must select a difficulty' : null,
    items: [
      1, 2, 3, 4, 5
    ].map<DropdownMenuItem<int>>(
        (val){
          return DropdownMenuItem(
            child: Text(val.toString()),
            value: val,
          );
        },

    ).toList(),
    onChanged: (val){
      data.difficulty = val;
    },
    decoration: InputDecoration(
      labelText: "Difficulty",
    ),
  );
}

Widget buildPaved(TrailData data){
  return DropdownButtonFormField<String>(
    onSaved: (val) {
      if(val == 'Is Paved')
        data.pavement = true;
      else
        data.pavement = false;
    },
    validator: (val) => val == null ? 'You must select a Pavement option' : null,
    items: [
      "Is Paved", "Is Not Paved"
    ].map<DropdownMenuItem<String>>(
          (val){
        return DropdownMenuItem(
          child: Text(val),
          value: val,
        );
      },
    ).toList(),
    onChanged: (val){
      if(val == 'Is Paved')
        data.pavement = true;
      else
        data.pavement = false;
    },
    decoration: InputDecoration(
      labelText: "Pavement",
    ),
  );
}

