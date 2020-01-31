import 'package:firebase_auth/firebase_auth.dart';
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
  bool isFavourite = false;
  
  @override
  Widget build(BuildContext context) {

    final routeArgs = ModalRoute.of(context).settings.arguments as Map<dynamic, dynamic>;
    final imageUrl = routeArgs['thumbNail'];
    final title = routeArgs['title'];
    final date = routeArgs['date'];
    final author = routeArgs['author'];
    final content = routeArgs['content'];
    final url = routeArgs['url'];
    //bool isFavourite = false;

      openBottomSheet(context){
      showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheetWidget(url:url),
        );
    }
    
    void saveAsFavourite() async{
    
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;

    final CollectionReference collectionRef = Firestore.instance.collection('users');
    final postRef = collectionRef.document(uid);

    try{

      var data = {
        'thumbNail': imageUrl,
        'title': title,
        'date': date,
        'author': author,
        'content': content,
        'url': url,
        'isFavourite': isFavourite = true
    };

      await postRef.updateData({
        "favNews" : FieldValue.arrayUnion([data])
      });
       setState(() {
          isFavourite = true;
        });

        return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context){
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('Reminder'),
              content: Text('Saved Successful'),
              elevation: 24.0,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
            );
          }
        );
      

    }catch(error){
      return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context){
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('Error'),
              content: Text(error),
              elevation: 24.0,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
            );
          }
        );
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
    
          IconButton(
            icon: isFavourite ? Icon(Icons.favorite,color: Colors.red,) : Icon(Icons.favorite_border),
            onPressed: (){
               saveAsFavourite();
            },
          ),
    
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