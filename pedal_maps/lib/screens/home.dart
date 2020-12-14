import 'package:flutter/material.dart';

// ignore_for_file: code-metrics

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LogoWidget(),
            SizedBox(height: 50),
            PageSelectButton(
                buttonText: "Track Ride", route: '/distanceTraveled'),
            SizedBox(
              height: 10,
            ),
            PageSelectButton(buttonText: "Nearby Trails", route: '/nearbyTrails'),
            SizedBox(
              height: 10,
            ),
            //PageSelectButton(buttonText: "Get location", route: '/GetLocationPage'),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class PageSelectButton extends StatelessWidget {
  final String buttonText;
  final String route;

  PageSelectButton({this.buttonText, this.route, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 250.0,
        height: 70.0,
        child: RaisedButton(
          child: Text(buttonText, style: TextStyle(fontSize: 26)),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          color: Colors.red,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
        ));
  }
}

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Container(
      width: 350.0,
      height: 301.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
              image: AssetImage("assets/PedalMapsLogo.png"), fit: BoxFit.fill)),
    ));
  }
}
