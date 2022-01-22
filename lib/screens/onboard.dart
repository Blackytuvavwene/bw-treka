import 'package:flutter/material.dart';
import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:bw_treka/screens/register.dart';
import 'package:bw_treka/helper/navigation.dart';

class OnBoarding extends StatelessWidget {
  final pageList = [
    PageModel(
        color: const Color(0xFFFFFFFF),
        heroImagePath: 'images/contacttracing.png',
        title: Text('Contact Tracing',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.blue,
              fontSize: 34.0,
            )),
        body: Text(
            'This a contact tracing app, any user you meet \n that contact will be saved in your phone',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18.0,
            )),
        iconImagePath: 'images/group.png'),
    PageModel(
        color: const Color(0xFF9B90BC),
        heroImagePath: 'images/uuid.png',
        title: Text('UUID',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text(
            'The app will generate a unique user ID for you hat will be used for conatct tracing thus ensuring your privacy',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
        iconImagePath: 'images/group.png'),
    PageModel(
        color: const Color(0xFF22047C),
        heroImagePath: 'images/uuid.png',
        title: Text('UUID',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text(
            'The app will generate a unique user ID for you hat will be used for conatct tracing thus ensuring your privacy',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
        iconImagePath: 'images/group.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      FancyOnBoarding(
        doneButtonText: "Done",
        skipButtonText: "Skip",
        pageList: pageList,
        onDoneButtonPressed: () => changeScreenReplacement(context, Register()),
        onSkipButtonPressed: () => changeScreenReplacement(context, Register()),
      ),
      Positioned.fill(
        bottom: 10,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text('swipe left',
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      )
    ]));
  }
}
