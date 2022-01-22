import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('BW Treka',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              SizedBox(
                height: 5,
              ),
              SpinKitWave(
                color: Colors.white12,
                size: 30,
              )
            ],
          ),
        ]));
  }
}
