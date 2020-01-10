import 'package:flutter/material.dart';
import 'package:maga/authentication/signIn.dart';
import 'package:maga/authentication/signUp.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
  
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:8.0, bottom: 80.0),
                  child: Text(
                    'M.A.G.A',
                    style: TextStyle(fontSize: 30.0),
                  ),
                )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Login(),
                          ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF18D191),
                          borderRadius: BorderRadius.circular(9.0)),
                        child: Text('Sign In with Email',
                          style: TextStyle(
                            color: Colors.white, fontSize: 20.0),
                            ),
                        ),
                    ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SignUp(),
                          ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF4364A1),
                          borderRadius: BorderRadius.circular(9.0)),
                        child: Text('Sign Up with Email',
                          style: TextStyle(
                            color: Colors.white, fontSize: 20.0),
                            ),
                        ),
                    ),
                ),
              )
            ],
          ),
          ],
        ),
      ),
    );
  }
}