import 'dart:developer';
import 'package:flutter/material.dart';
import 'map.dart';
import 'stopwatch.dart';

class distanceTraveled extends StatefulWidget{
  _distanceTraveled createState() => _distanceTraveled();
}

class _distanceTraveled extends State<distanceTraveled> {

  var hoursStr = '00';
  var minutesStr = '00';
  var secondsStr = '00';
  var timerStream, timerSubscription;
  var start_pressed = false;
  var pause_pressed = false;

  int prevTick = 0;

  void StopWatchStart(){ //function that affects stopwatch when start button pressed
    if (start_pressed == false){
      timerStream = stopWatchStream();
      timerSubscription = timerStream.listen((int newTick) {
        setState(() {
          hoursStr = ((newTick / (60 * 60)) % 60)
              .floor()
              .toString()
              .padLeft(2, '0');
          minutesStr = ((newTick / 60) % 60)
              .floor()
              .toString()
              .padLeft(2, '0');
          secondsStr = (newTick % 60)
              .floor()
              .toString()
              .padLeft(2, '0');
          prevTick = newTick;
        });
      });
      start_pressed = true;

    }
    if(start_pressed == true && pause_pressed == true){
      timerStream = stopWatchStream();
      timerSubscription = timerStream.listen((int newTick) {
        setState(() {
          hoursStr = (((prevTick + 1) / (60 * 60)) % 60)
              .floor()
              .toString()
              .padLeft(2, '0');
          minutesStr = (((prevTick + 1) / 60) % 60)
              .floor()
              .toString()
              .padLeft(2, '0');
          secondsStr = ((prevTick + 1) % 60)
              .floor()
              .toString()
              .padLeft(2, '0');
          prevTick = prevTick + 1;
        });
      });
      pause_pressed = false;
    }
  }//end StopWatchStart

  void StopWatchReset(){ // function that affects stopwatch when reset button is pressed
    if (timerStream != null) {
      timerSubscription.cancel();
      timerStream = null;
      setState(() {
        hoursStr = '00';
        minutesStr = '00';
        secondsStr = '00';
        prevTick = 0;
      });
      start_pressed = false;
      pause_pressed = false;
    }else{
      setState(() {
        hoursStr = '00';
        minutesStr = '00';
        secondsStr = '00';
        prevTick = 0;
      });
    }
  }// end StopWatchReset

  void StopWatchPause(){ // function that affects stopwatch when pause button is pressed
    if(start_pressed == true){
      //timerStream.stop();
      timerSubscription.cancel();
      timerStream = null;
      pause_pressed = true;
    }
  }// end StopWatchPause

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Ride"),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: map(),
              width: 350,
              height: 400,
              padding: new EdgeInsets.only(bottom: 25),
            ),
            
            Text(
              "$hoursStr:$minutesStr:$secondsStr",
              style: TextStyle(
                fontSize: 60.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  color: Colors.green,
                  child: Text('START',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () {
                    StopWatchStart();
                  },
                ),
                SizedBox(width: 30.0),
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  color: Colors.red,
                  child: Text(
                    'RESET',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () {
                    StopWatchReset();
                  },
                ),
              ], // RowChildren
            ),
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 8.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              color: Colors.white24,
              child: Text(
                'PAUSE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: (){
                StopWatchPause();
              },
            ),
            SizedBox(height: 30.0)
          ], // ColumnChildren
        ),
      ),
    );
  }// Build
}// DistanceTraveled