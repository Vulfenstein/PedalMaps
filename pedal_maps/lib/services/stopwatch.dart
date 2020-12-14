import 'dart:async';
// ignore_for_file: code-metrics

//adopted from https://medium.com/analytics-vidhya/build-a-simple-stopwatch-in-flutter-a1f21cfcd7a8

class Stopwatch {
  Timer _timer;
  Duration timerInterval;
  int counter;
  bool startpressed;
  bool pausepressed;

  Stopwatch() {
    startpressed = false;
    pausepressed = false;
    counter = 0;
    timerInterval = Duration(seconds: 1);
    _timer = Timer.periodic(timerInterval, addSecond);
  }

  void addSecond(_) {
    if (startpressed && !pausepressed) {
      counter++;
    }
  }

  //while active calls tick function every second
  //Duration timerInterval = Duration(seconds: 1)
  void startStopwatch() {
    //log("Started Stopwatch");
    startpressed = true;
    pausepressed = false;
  }

  void pauseStopwatch() {
    pausepressed = true;
  }

  void resetStopwatch() {
    startpressed = false;
    pausepressed = false;
    counter = 0;
  }

  String getTime() {
    var hoursStr =
        ((counter / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
    var minutesStr = ((counter / 60) % 60).floor().toString().padLeft(2, '0');
    var secondsStr = (counter % 60).floor().toString().padLeft(2, '0');
    return (hoursStr + ":" + minutesStr + ":" + secondsStr);
  }

  String getHours() {
    return (((counter / (60 * 60)) % 60).floor().toString().padLeft(2, '0'));
  }

  String getMinutes() {
    return (((counter / 60) % 60).floor().toString().padLeft(2, '0'));
  }

  String getSeconds() {
    return ((counter % 60).floor().toString().padLeft(2, '0'));
  }
}
