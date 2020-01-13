import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'newsDetail.dart';

class NewsItem extends StatelessWidget {

  // final String id;
  final String thumbNail;
  final String title;
  final String date;
  final String description;
  final String author;
  final String url;
  bool isFavourite;

  NewsItem({
    // @required this.id, 
    @required this.thumbNail, 
    @required this.title, 
    @required this.description, 
    @required this.date, 
    @required this.author,
    @required this.url
    });
  
  @override
  Widget build(BuildContext context) {

    var titleTextStyle = TextStyle(
      color: Colors.black87,
      fontSize: 20.0
    );

    return Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            child:Image.network(thumbNail, fit: BoxFit.cover, width: double.infinity, height: 200.0,),  
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              description,
                              style: titleTextStyle,
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  date,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  author,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ), 
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ],
                  ),
              );        
  }
}