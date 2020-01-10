import 'package:flutter/material.dart';
import 'package:maga/pages/welcome.dart';
import 'package:maga/ui_design/loginUI.dart';
import 'package:maga/ui_design/newsDetail.dart';
import 'package:maga/ui_design/profile.dart';
import 'package:maga/ui_design/newsUi.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAGA App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: News(),
    );
  }
}



