import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'newsDetail.dart';

class NewsItem extends StatelessWidget {

  final String id;
  final String thumbNail;
  final String title;
  final String date;
  final String author;
  final String content;
  final String url;
  bool isFavourite = false;

  NewsItem({
    @required this.id, 
    @required this.thumbNail, 
    @required this.title, 
    @required this.date, 
    @required this.author,
    @required this.content,
    @required this.url,
    this.isFavourite 
    });
  
  @override
  Widget build(BuildContext context) {

    var titleTextStyle = TextStyle(
      color: Colors.black87,
      fontSize: 20.0
    );

    final dateFormat = DateFormat('yyyy-MM-dd');

    void selectNews(BuildContext context){
      Navigator.of(context).pushNamed(
        NewsDetail.routeName, 
        arguments: {
          'thumbNail': thumbNail, 
          'title': title, 
          'date': date, 
          'author': author, 
          'content': content, 
          'url':url,
          'isFavourite': isFavourite,
          
        }
      );
    }

    return InkWell(
          onTap: () => selectNews(context),
          splashColor: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10.0),
          child: Card(
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
                                title,
                                style: titleTextStyle,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    dateFormat.format(DateTime.parse(date)) ,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(  
                                    author,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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
                ),
    );        
  }
}