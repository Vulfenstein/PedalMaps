import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedal_maps/screens/home.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _auth = FirebaseAuth.instance;
  String value;
  String email;
  String password;
  String e;
  bool logLoading = true;
  bool signLoading = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LogoWidget(),
                SizedBox(
                  height: 20.0,
                  width: 210.0,
                  child: Divider(
                    color: Colors.red.shade500,
                  ),
                ),
                Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      labelText: 'email',
                    ),
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      labelText: 'password',
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                ButtonTheme(
                  minWidth: 345.0,
                  height: 50.0,
                  child: logLoading
                      ? new RaisedButton(
                          color: Colors.red.shade500,
                          child: Text('Log In'),
                          onPressed: () async {
                            setState(() {
                                logLoading = false;
                              },
                            );
                            try {
                              final newUser =
                                  await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);
                              if (newUser != null) {
                                setState(() {
                                  logLoading = true;
                                });
                                Navigator.of(context).push(
                                  MaterialPageRoute<Null>(
                                    builder: (BuildContext context) {
                                      return new Home();
                                    },
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                  logLoading = true;
                                },
                              );
                              print(e);
                            }
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(backgroundColor: Colors.white,),
                        ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                ButtonTheme(
                  minWidth: 345.0,
                  height: 50.0,
                  child: signLoading
                      ? new RaisedButton(
                          color: Colors.red.shade900,
                          child: Text('Sign Up'),
                          onPressed: () async {
                            setState(() {
                              signLoading = false;
                            });
                            try {
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                              if (newUser != null) {
                                setState(
                                  () {
                                    signLoading = true;
                                  },
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute<Null>(
                                    builder: (BuildContext context) {
                                      return new Home();
                                    },
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                  signLoading = true;
                                },
                              );
                              print(e);
                            }
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(backgroundColor: Colors.white,),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
