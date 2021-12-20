import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rimaintenance/bienvenue/welcome.dart';
import 'package:rimaintenance/constants.dart';
import 'package:rimaintenance/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Home(),
    );
  }
}
