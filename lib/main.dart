import 'package:flutter/material.dart';
import './navigation/tabs.dart';
import './authentication/signIn.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAGA App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Color.fromRGBO(59, 196, 185, 1),
      ),
      home: Login(),
    );
  }
}



