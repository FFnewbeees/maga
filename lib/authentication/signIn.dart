import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../authentication/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../navigation/tabs.dart';
import 'package:email_validator/email_validator.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
  static const routeName = '/login';
}

class _LoginState extends State<Login> {
  String _email, _password ;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    print("enter login");
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.light;
    EasyLoading.instance.maskType = EasyLoadingMaskType.black;
    //checkAuth();
  }

  void errorMessageChange(String message) {
    setState(() {
      errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: Scaffold(
          body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.green,
            Colors.lightBlueAccent.withOpacity(0.6),
          ])),
          child: Column(
            children: <Widget>[
              SizedBox(height: 80.0),
              Container(
                margin: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                height: 80,
                child: Text(
                  'M.A.G.A',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 46.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!EmailValidator.validate(input)) {
                    return 'Please enter the correct email';
                  }
                },
                keyboardType: TextInputType.emailAddress,
                onChanged: (input) => _email = input,
                onSaved: (input) => _email = input,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16.0),
                  prefixIcon: Container(
                    padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    margin: EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                          bottomRight: Radius.circular(10.0)),
                    ),
                    child: Icon(Icons.person, color: Colors.lightGreen),
                  ),
                  hintText: 'Enter Your Email',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                validator: (input) {
                  if (input.length < 6) {
                    return 'Password has to be at least 6 characters';
                  }
                },
                onSaved: (input) => _password = input,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16.0),
                  prefixIcon: Container(
                    padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    margin: EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                          bottomRight: Radius.circular(10.0)),
                    ),
                    child: Icon(Icons.lock, color: Colors.lightGreen),
                  ),
                  hintText: 'Enter Your Password',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                ),
                obscureText: true,
              ),
              SizedBox(height: 40.0),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.white,
                  textColor: Colors.lightGreen,
                  padding: EdgeInsets.all(20.0),
                  child: Text('Login'.toUpperCase()),
                  onPressed: () {
                    signIn();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                      textColor: Colors.white70,
                      child: Text("Create Account".toUpperCase()),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ));
                      }),
                  Container(
                    color: Colors.white54,
                    width: 2.0,
                    height: 20.0,
                  ),
                  FlatButton(
                    textColor: Colors.white70,
                    child: Text("Forgot Password".toUpperCase()),
                    onPressed: () async {
                      resetPassword();
                    },
                  ),
                ],
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      )),
    );
  }

  void resetPassword() async {
    if (EmailValidator.validate(_email)) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title:
                    Text("Reset password link has been sent to your email"),
                content: Text(_email.toString()),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      } catch (e) {
        print("signin resetPassword()\n" + e.toString());
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text("oops, looks your email is not sign up yet"),
                //content: Text("Do you want to delete?"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
    } else {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("oops..Look like your email has wrong format"),
              //content: Text("Do you want to delete?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  Future signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        EasyLoading.show();
        final response = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        EasyLoading.dismiss();
        if (response.user != null) {
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Tabs(response.user)));
          print(response.user);
        }
      } catch (e) {
        //   return showDialog(
        //   context: context,
        //   barrierDismissible: true,
        //   builder: (BuildContext context){
        //     return AlertDialog(
        //       backgroundColor: Colors.white,
        //       title: Text('Error'),
        //       content: Text(e.toString()),
        //       elevation: 24.0,
        //       shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
        //     );
        //   }
        // );
        EasyLoading.dismiss();
        if (Platform.isAndroid) {
          switch (e.message) {
            case 'There is no user record corresponding to this identifier. The user may have been deleted.':
              errorMessageChange("User not found, please check your email");
              break;
            case 'The password is invalid or the user does not have a password.':
              errorMessageChange(
                  "Password not matched, please check your password");
              break;
            case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
              errorMessageChange("NetworkError, please try again");
              break;
            // ...
            default:
              print('Case ${e.message} is not yet implemented');
          }
        } else if (Platform.isIOS) {
          switch (e.code) {
            case 'Error 17011':
              errorMessageChange("User not found, please check your email");
              break;
            case 'Error 17009':
              errorMessageChange(
                  "Password not matched, please check your password");
              break;
            case 'Error 17020':
              errorMessageChange("Network error, please try again");
              break;
            // ...
            default:
              print('Case ${e.message} is not yet implemented');
          }
        }
      }
    }
  }
}
