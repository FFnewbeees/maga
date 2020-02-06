import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  
  static const routeName = '/editProfile';

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String _email, _name;


  @override
  Widget build(BuildContext context) {

    final routeArgs = ModalRoute.of(context).settings.arguments as Map<dynamic, dynamic>;
    var profileImage = routeArgs['profileImage'];
    var name = routeArgs['name'];
    var email = routeArgs['email'];


    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: <Widget>[
          FlatButton(
            child: Text('Confirm'),
            textColor: Colors.grey[300],
            onPressed: (){},
          )
        ],
      ),
      body:
        Column(children: <Widget>[
          Center(
            child: Column(
                    children: <Widget>[
                      SizedBox(height: 30,),
                      Material(
                        elevation: 5.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          radius: 40.0,
                          child: Image.network(profileImage.toString()),
                        ),
                      ),
                      SizedBox(height: 10,),
                      FlatButton(
                      child: Text('Change Profile Photo'),
                      onPressed: (){},)
                    ],
            ),
          ),
        ],
        ),
        
        
      );
  }
}