import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'newsBottomSheet.dart';


class NewsDetail extends StatefulWidget {

  static const routeName = '/news-detail';

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {

  final dateFormat = DateFormat('yyyy-MM-dd');
  bool isFavourite ;
  String currentNewsId;
  var imageUrl ;
  var title ;
  var date ;
  var author ;
  var content ;
  var url ;
  var user ;
  
  // bool isFavourite ;
  var a =0;
  
  final CollectionReference collectionRef = Firestore.instance.collection('favouriteNews');

  @override
  Widget build(BuildContext context) {
    if(a == 0)
    {
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<dynamic, dynamic>;
      currentNewsId = routeArgs['id'];
      imageUrl = routeArgs['thumbNail'];
      title = routeArgs['title'];
      date = routeArgs['date'];
      author = routeArgs['author'];
      content = routeArgs['content'];
      url = routeArgs['url'];
      user = routeArgs['user'];
      isFavourite = routeArgs['isFavourite'];

      a++;
    }

      openBottomSheet(context){
      showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheetWidget(url:url),
      );
    }

void removedFavourite() async{

  final result = await collectionRef.where("id", isEqualTo: currentNewsId).where('user', isEqualTo: user).getDocuments();
  print(result.documents.length);

  final docID = result.documents.first.documentID;
  print(docID);
  await collectionRef.document(docID.toString()).delete();
  print('deleted yeh');
  
}

void saveAsFavourite() async {

    try{

      var data = {
        'id':currentNewsId,
        'thumbNail': imageUrl,
        'title': title,
        'date': date,
        'author': author,
        'content': content,
        'url': url,
        'user': user,
        'isFavourite': isFavourite = true
    };

      await collectionRef.document().setData(data);
      
      print(isFavourite);
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("Reminder"),
              content: Text("\nSaved To News Collection Successfully"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
      

    }catch(error){
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("Reminder"),
              content: Text("\n ${error}"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text("Article Detail", 
        style: TextStyle(color: Colors.white)),
      ),

      bottomNavigationBar: BottomAppBar(
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              openBottomSheet(context);
            },
          ),
          isFavourite?
          IconButton(
            icon:Icon(Icons.favorite,color: Colors.red,),
            onPressed: (){
              removedFavourite();
                setState(() {
                  isFavourite = false;
                  print('set to normal');
                  print(isFavourite);
                });
            },
          ) : IconButton(icon: Icon(Icons.favorite_border), onPressed: (){
               saveAsFavourite();
                setState(() {
                  print('set to favourte');
                  print(isFavourite);
                  isFavourite = true;
                });
            },)
    
        ],
      ),
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
                    HtmlWidget(content),
                    
                  ],
              ),)
            ],
          ),
        ),
      ),
    );
  }
}