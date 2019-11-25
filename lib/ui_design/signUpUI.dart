import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green,
              Colors.lightBlueAccent.withOpacity(0.6),
            ]
          )
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 80.0),
            Container(
              margin: const EdgeInsets.only(top: 40.0, bottom: 20.0),
              height: 80,
              child: Text('M.A.G.A', style: TextStyle(
                color: Colors.white,
                fontSize: 46.0,
                fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40.0),
            TextField(
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
                      bottomRight: Radius.circular(10.0)
                    ),
                  ),
                  child: Icon(Icons.person, color: Colors.lightGreen), 
                ),
                hintText: 'Enter Your Email',
                hintStyle: TextStyle(color:Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 10.0),
                        TextField(
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
                      bottomRight: Radius.circular(10.0)
                    ),
                  ),
                  child: Icon(Icons.lock, color: Colors.lightGreen), 
                ),
                hintText: 'Enter Your Password',
                hintStyle: TextStyle(color:Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none
                ),
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
                child: Text('Sign Up'.toUpperCase()),
                onPressed: (){},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
                ),
              ),
            ),
        ],
      ),
    )
      
    );
  }
}