import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maga/authentication/signIn.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (input){
                if(input.isEmpty){
                  return('Provide an email');
                }
              },
              decoration: InputDecoration(
                labelText: 'Email'
              ),
              onSaved: (input) => _email = input,
            ),
            TextFormField(
              validator: (input){
                if(input.length < 6){
                  return 'Longer password please';
                }
              },
              decoration: InputDecoration(
                labelText: 'Password'
              ),
              onSaved: (input) => _password = input,
              obscureText: true,
            ),
            RaisedButton(
              onPressed: signUp,
              child: Text('Sign Up'),
            )
          ],
        ),
      ),
    );
  }

void signUp() async {
  final formState = _formKey.currentState;
      if(formState.validate()){
        formState.save();
        try{
            await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()));
        }catch(e){
          print(e.message);
        }

        
      }
  }



}

