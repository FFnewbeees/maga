import 'package:flutter/material.dart';

class NewsDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text("Article Name", 
        style: TextStyle(color: Colors.white, fontSize: 25.0)),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share), onPressed: (){},)
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                height: 300.0,
                width: double.infinity,
                child: Image.asset('assets/recycling.jpg', fit: BoxFit.cover),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16.0, 250.0, 16.0,16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0)
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //title
                    Text("Title", style: Theme.of(context).textTheme.title),
                    SizedBox(height: 10.0),
                    //date & author
                    Text("Dec 18, 2019 by Lily"),
                    SizedBox(height: 10.0),
                    Divider(),
                    SizedBox(height: 10.0),
                    Row(children: <Widget>[
                      Icon(Icons.favorite_border),
                      SizedBox(width: 5.0),
                      Text("20.2k"),
                      SizedBox(width: 16.0),
                      Icon(Icons.comment),
                      SizedBox(width: 5.0),
                      Text("2.2k")
                    ],),
                    SizedBox(height: 10.0),
                    Text('Alex Fraser has been operating its Clarinda facility since 2009.Alex Fraser has been operating its Clarinda facility since 2009.Alex Fraser has been operating its Clarinda facility since 2009.Alex Fraser has been operating its Clarinda facility since 2009.'),
                    SizedBox(height: 10.0),
                    Text('Alex Fraser has been operating its Clarinda Alex Fraser has been operating its Clarinda Alex Fraser has been operating its Clarinda Alex Fraser has been operating its Clarinda Alex Fraser has been operating its Clarinda Alex Fraser has been operating its Clarinda Alex Fraser has been operating its Clarinda Alex Fraser has been operating its Clarinda facility since 2009.Alex Fraser has been operating its Clarinda facility since 2009.Alex Fraser has been operating its Clarinda facility since 2009.Alex Fraser has been operating its Clarinda facility since 2009.Alex Fraser has been operating its Clarinda facility since 2009.Alex Fraser has been operating its Clarinda facility since 2009.'),
                  ],
              ),)
            ],
          ),
        ),
      ),



    );
  }
}