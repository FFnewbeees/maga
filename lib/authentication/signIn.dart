import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maga/authentication/signUp.dart';
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Color(0xFF18D191)),
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
                    return 'Please type an email';
                  }
                },
                onSaved:(input) => _email = input ,
                decoration: InputDecoration(
                  labelText: 'Email:'
                ),
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
                    return 'Your password needs to be at least 6 characters';
                  }
                },
                onSaved:(input) => _password = input ,
                decoration: InputDecoration(
                  labelText: 'Password:'
                ),
                obscureText: true,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0),
                    child: GestureDetector(
                      onTap: signIn,
                      child: Container(
                        alignment: Alignment.center,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF18D191),
                          borderRadius: BorderRadius.circular(9.0)),
                        child: Text('Sign In',
                          style: TextStyle(
                            color: Colors.white, fontSize: 20.0),
                            ),
                        ),
                    ),
                ),
              )
            ],
          ),
          Expanded(child: Column(children: <Widget>[],),)
          ],
        ),
      ),
    );
  }

void signIn() async{
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      print("fk1");
      try{
          AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          FirebaseUser user = result.user;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(user:user)));
      }catch(e){
        print(e.message);
      }

      
    }


  }

}