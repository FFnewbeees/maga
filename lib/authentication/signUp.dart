import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../authentication/signIn.dart';
import '../navigation/tabs.dart';
import 'package:email_validator/email_validator.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;
  String errorMessage = '';
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
              SizedBox(height: 40.0,child: Text(errorMessage,style: TextStyle(color:Colors.red)),),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return ('Provide an email');
                  }
                  if(!EmailValidator.validate(input)){
                    return 'Please enter the correct email';
                  }

                },
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
                    return 'At least 6 characters';
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
              SizedBox(
                height: 40.0,
                //child: Text(errorMessage,style: TextStyle(color:Colors.red),),
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.white,
                  textColor: Colors.lightGreen,
                  padding: EdgeInsets.all(20.0),
                  child: Text('Sign Up'.toUpperCase()),
                  onPressed: () {
                    signUp();
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
                      child: Text("Already Have Account?".toUpperCase()),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ));
                      }),
                ],
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      )),
    );
  }

  Future signUp() async {
    //EasyLoading.showProgress(value);
    
    final formState = _formKey.currentState;
   // print("wtf1");
    if (formState.validate()) {
      formState.save();
      EasyLoading.show();
      try {
        final response = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
             EasyLoading.showSuccess('', duration: new Duration(seconds: 1));
        if (response.user != null) {
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Tabs(response.user)));
        }
      } catch (e) {
        //    return showDialog(
        //     context: context,
        //     barrierDismissible: true,
        //     builder: (BuildContext context){
        //     return AlertDialog(
        //       backgroundColor: Colors.white,
        //       title: Text('Error'),
        //       content: Text(e),
        //       elevation: 24.0,
        //       shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
        //     );
        //   }
        // );
        EasyLoading.dismiss();
        switch (e.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
           errorMessageChange("Email already in use, please login or change email");
           break;
           default: break;
        }
      }
     
    }
     EasyLoading.dismiss();
  }
}
