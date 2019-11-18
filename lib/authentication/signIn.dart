import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/home.dart';

class SignInPage extends StatefulWidget{
  @override 
  _SignInPageState createState() => new _SignInPageState(); 
}

class _SignInPageState extends State<SignInPage>{
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override 
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (input){
                if(input.isEmpty){
                  return 'Please type an email';
                }
              },
              onSaved:(input) => _email = input ,
              decoration: InputDecoration(
                labelText: 'Email:'
              ),
            ),
            TextFormField(
              validator: (input){
                if(input.length < 6){
                  return 'Your password needs to be at least 6 characters';
                }
              },
              onSaved:(input) => _password = input ,
              decoration: InputDecoration(
                labelText: 'Password:'
              ),
              obscureText: true,
            ),
            RaisedButton(
              onPressed: signIn,
              child: Text('Sign In'),
            )
          ],
        ),
      ),
    );
  }

void signIn() async{
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try{
          FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)) as FirebaseUser;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(user:user)));
      }catch(e){
        print(e.message);
      }

      
    }


  }

}