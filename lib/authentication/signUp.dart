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
      appBar: new AppBar(
        title: Text('Sign Up'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              child: TextFormField(
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
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              child: TextFormField(
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
            ),
                        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0),
                    child: GestureDetector(
                      onTap: signUp,
                      child: Container(
                        alignment: Alignment.center,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF4364A1),
                          borderRadius: BorderRadius.circular(9.0)),
                        child: Text('Sign Up',
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

void signUp() async {
  final formState = _formKey.currentState;
      if(formState.validate()){
        formState.save();
        try{
            await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignInPage()));
        }catch(e){
          print(e.message);
        }

        
      }
  }



}

