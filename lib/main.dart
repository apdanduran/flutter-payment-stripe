import 'package:flutter/material.dart';
import 'package:flutterapp/app/landing_page.dart';
import 'package:flutterapp/locator.dart';
import 'package:flutterapp/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => UserModel(),
      create: (BuildContext context) => UserModel(),
      child: MaterialApp(
        title: "Duran Apdan",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: LandingPage(),
      ),
    );
  }
}
