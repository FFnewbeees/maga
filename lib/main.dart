import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maga/loader/splash_screen.dart';
import '././news_feed/newsDetail.dart';
import './navigation/tabs.dart';
import './authentication/signIn.dart';
import './news_feed/newsBottomSheet.dart';
import './user_profile/editProfile.dart';

//WidgetsFlutterBinding.ensureInitialized();
void main() => runApp(MyApp());


// Future<void> userGet() async {

//      //user = fireuser;
//      print(fireuser.email+"  main dart");
//      if(fireuser == null) _build = Login();
//      else _build = Tab();
//   }
class MyApp extends StatefulWidget {
  // //final fireuser = await FirebaseAuth.instance.currentUser();
  //  FirebaseUser user;

  @override
  _MyAppState createState() {
    //userGet();
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  // FirebaseUser user;
  // Future<void> userGet() async {
  //   final fireuser = await FirebaseAuth.instance.currentUser();
  //   user = fireuser;
  //   print(fireuser.email + "  main dart");
  // }
 
  @override
  void initState() {
    // print(user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // userGet();
    return MaterialApp(
      title: 'MAGA App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Color.fromRGBO(59, 196, 185, 1),
      ),
      //home: buildState,
      //initialRoute: '/',
      routes: {
        '/': (ctx) => SplashScren(),
        NewsDetail.routeName: (ctx) => NewsDetail(),
        Login.routeName:(ctx) => Login(),
        EditProfile.routeName:(ctx) => EditProfile()

      },
    );
  }
}
