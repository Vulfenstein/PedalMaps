import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pedal_maps/screens/trailScreen.dart';

// ignore_for_file: code-metrics

class NearbyTrails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Trails"),
      ),
      body: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  Future getTrails() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot q = await firestore.collection("trails").get();
    return q.docs;
  }
  
  navigateToDetail(DocumentSnapshot trail){
    Navigator.push(context, MaterialPageRoute(builder: (context) => TrailPage(trail: trail,),),);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getTrails(),
        builder: (_, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitWave(
                color: Colors.white,
                size: 50.0,
              ),

            );
          }

          else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemExtent: 100,
              itemBuilder: (_, index) {
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  title: Text(snapshot.data[index].get('trailName'),
                  style: TextStyle(fontSize: 25.0),),
                  subtitle: Text("difficulty: ${snapshot.data[index].get('difficulty')}",
                  style: TextStyle(fontSize: 15.0),),
                  onTap: () => navigateToDetail(snapshot.data[index]),
                );
              },
            );
          }
        },
      ),
    );
  }
}

