import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'newsDetail.dart';

class NewsItem extends StatefulWidget {

  final String id;
  final String thumbNail;
  final String title;
  final String date;
  final String author;
  final String content;
  final String url;
  final String user;
  //bool isFavourite = false;

  NewsItem({
    @required this.id, 
    @required this.thumbNail, 
    @required this.title, 
    @required this.date, 
    @required this.author,
    @required this.content,
    @required this.url,
    @required this.user,
    //this.isFavourite 
    });

  @override
  _NewsItemState createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  bool isFavourite = false;

@override
  void initState() {
    //checkFavourite();
    super.initState();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    
  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    //checkFavourite();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    checkFavourite();
  }
  
  void checkFavourite() async {


    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    //check news id
    //check user id
    final response = await Firestore.instance
    .collection('favouriteNews')
    .where('user', isEqualTo: currentUser.email)
    .where('id', isEqualTo: widget.id)
    .getDocuments();

    if(response.documents.length != 0){
        isFavourite = true;
        print('it is a favourite item $isFavourite');
        return;
    }

      isFavourite = false;
  }

  void selectNews(BuildContext context){
      //checkFavourite();
      print(isFavourite.toString()+"newsitem");
      Navigator.of(context).pushNamed(
        NewsDetail.routeName, 
        arguments: {
          'id':widget.id,
          'thumbNail': widget.thumbNail, 
          'title': widget.title, 
          'date': widget.date, 
          'author': widget.author, 
          'content': widget.content, 
          'url':widget.url,
          'isFavourite': isFavourite,
          'user':widget.user
          
        }
      );
    }
  @override
  Widget build(BuildContext context) {

    var titleTextStyle = TextStyle(
      color: Colors.black87,
      fontSize: 20.0
    );

    final dateFormat = DateFormat('yyyy-MM-dd');

    

    return InkWell(
          onTap: () { checkFavourite() ;selectNews(context);},
          splashColor: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10.0),
          child: Card(
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                              child:Image.network(widget.thumbNail, fit: BoxFit.cover, width: double.infinity, height: 200.0,),  
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                widget.title,
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
                                    dateFormat.format(DateTime.parse(widget.date)) ,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(  
                                    widget.author,
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