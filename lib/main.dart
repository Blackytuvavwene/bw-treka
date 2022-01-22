import 'package:bw_treka/helper/user.dart';
import 'package:flutter/material.dart';
import 'package:bw_treka/screens/onboard.dart';
import 'package:bw_treka/screens/home.dart';
import 'package:bw_treka/screens/register.dart';
import 'package:bw_treka/screens/info.dart';
import 'package:bw_treka/screens/about.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:bw_treka/provider/auth.dart';
import 'package:bw_treka/screens/splash.dart';
import 'package:bw_treka/model/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: AuthProvider()),
    StreamProvider<UserModel>.value(value: UserServices().user),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BW Treka',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ScreensController());
  }
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (auth.status == Status.Uninitialized) {
      return OnBoarding();
    } else {
      if (auth.status == Status.Authenticated) {
        return Home();
      } else {
        if (auth.status == Status.Unauthenticated) {
          return OnBoarding();
        } else {
          return Register();
        }
      }
    }
  }
}
