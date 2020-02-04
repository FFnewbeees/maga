import 'package:flutter/material.dart';
import '../news_feed/newsDetail.dart';

class FavNewsItem extends StatelessWidget {
  final String id;
  final String thumbNail;
  final String title;
  final String date;
  final String author;
  final String content;
  final String url;
  final String user;
  final bool isFavourite;

  FavNewsItem(
    this.id, 
    this.thumbNail, 
    this.title, 
    this.date, 
    this.author,
    this.content,
    this.url,
    this.user,
    this.isFavourite 
  );


  @override
  Widget build(BuildContext context) {

    void selectFavouriteNews(BuildContext context){
      Navigator.of(context).pushNamed(
        NewsDetail.routeName,
        arguments: {
          'id':id,
          'thumbNail': thumbNail, 
          'title': title, 
          'date': date, 
          'author': author, 
          'content': content, 
          'url':url,
          'isFavourite': isFavourite,
          'user': user
        }
      );
    }


    return InkWell(
        onTap: () => selectFavouriteNews(context),
          child: Container(
                    margin:EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                    width: 300.0,
                    height: 300.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                       
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              height: 250,
                              child: Image.network(thumbNail, width: double.infinity , fit: BoxFit.cover)),
                          ),
                        
                        SizedBox(height: 5.0),
                        Text(title, style: Theme.of(context).textTheme.subhead.merge(TextStyle(color: Colors.grey.shade600)))
                      ],
                    ),
                  ),
    );
  }
}