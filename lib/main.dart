import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '././news_feed/newsDetail.dart';
import './navigation/tabs.dart';
import './authentication/signIn.dart';
import './news_feed/newsBottomSheet.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<FirebaseUser> userGet() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAGA App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Color.fromRGBO(59, 196, 185, 1),
      ),
      //home: Tabs(),
      //initialRoute: '/',
      routes: {
        // '/': (ctx) {
        //   if(userGet() == null) return Login();
        //   else return Tab();
        // } ,
        '/': (ctx)=>Login(),
        NewsDetail.routeName: (ctx) => NewsDetail(),
      },
    );
  }
}



