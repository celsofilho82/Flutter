import 'package:flutter/material.dart';

import 'screens/dashbord.dart';
import 'package:bytebank2/http/webclient.dart';
void main() {
  runApp(ByteBankApp());
  findAll();
}

class ByteBankApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[900],
        accentColor: Colors.blueAccent[700],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: Dashboard()
    );
  }
}


