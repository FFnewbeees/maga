import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:convert/convert.dart' as convert;
import 'dart:convert';

class NewsDetail extends StatelessWidget {

  static const routeName = '/news-detail';

  final dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {

    final routeArgs = ModalRoute.of(context).settings.arguments as Map<dynamic, dynamic>;
    final imageUrl = routeArgs['thumbNail'];
    final title = routeArgs['title'];
    final date = routeArgs['date'];
    final author = routeArgs['author'];
    final content = routeArgs['content'];
    
   



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text("Article Detail", 
        style: TextStyle(color: Colors.white)),
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
                child: Image.network(imageUrl, fit: BoxFit.cover),
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
                    Text(title, style: Theme.of(context).textTheme.title),
                    SizedBox(height: 10.0),
                    //date & author
                    Text(dateFormat.format(DateTime.parse(date)) + " " + "by" + " " + author),
                    SizedBox(height: 10.0),
                    Divider(),
                    SizedBox(height: 10.0),
                    Row(children: <Widget>[
                      Icon(Icons.favorite_border),
                      SizedBox(width: 5.0),
                      Text("20.2k"),
                      // SizedBox(width: 16.0),
                      // Icon(Icons.comment),
                      // SizedBox(width: 5.0),
                      // Text("2.2k")
                    ],),
                    SizedBox(height: 10.0),
                    HtmlWidget(content),
                    SizedBox(height: 10.0),
                  ],
              ),)
            ],
          ),
        ),
      ),



    );
  }
}