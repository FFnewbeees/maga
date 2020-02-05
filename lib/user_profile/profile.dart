
import '../loader/loader.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maga/user_profile/favNewsItem.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  List<FavNewsItem> collections = [];
  bool _isLoading = false;
 // bool _isInit = true;
  String currentUser;

  Stream<QuerySnapshot> querySnapshot;

  @override               
    void initState(){
    super.initState();
    getQuery();
      
  }

  void getQuery() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    currentUser = user.email;
    
    querySnapshot = Firestore.instance
    .collection('favouriteNews')
    .where('user', isEqualTo:currentUser)
    .orderBy('date', descending: true)
    .snapshots();

    print('got data');

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){},
          ),
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){},)
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade200, Colors.green.shade400],
              ),
            ),
          ),
          ListView.builder(
            itemCount: 7,
            itemBuilder: _mainListBuilder,
          )
        ],
      ),
    );
  }

  Widget _mainListBuilder(BuildContext context, int index){
    if(index==0) return _buildHeader(context);
    if(index==1) return _buildSectionHeader(context);
    if(index==2) return _isLoading ? Center(child: Loader()) :  
              Container(
                color: Colors.white,
                height: 340.0,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child:_buildCollectionsRow()
              );
    if(index==3) return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
    );
  }

  Widget _buildSectionHeader(BuildContext context){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("News Collection", style: Theme.of(context).textTheme.title,),
          SizedBox(height: 40.0),
        ],
      ),
    );
  }

  Widget _buildCollectionsRow(){
    return StreamBuilder(
      stream: querySnapshot = Firestore.instance
    .collection('favouriteNews')
    .where('user', isEqualTo:currentUser)
    .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasError){
          return new Center(
            child: Text('Error on streamBuilder : ${snapshot.error.toString()}'),
          );
        }

        if(!snapshot.hasData){
          return new Loader();
        }
        
        if(snapshot.data.documents.length == 0){
          return new Center(
            child: Text('Your News Collection is empty', style: TextStyle(color:Colors.blue) ),
            );
        }
        else{
          return new ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (ctx, index){
            return FavNewsItem(
                      snapshot.data.documents[index]['id'],
                      snapshot.data.documents[index]['thumbNail'],
                      snapshot.data.documents[index]['title'],
                      snapshot.data.documents[index]['date'],
                      snapshot.data.documents[index]['author'],
                      snapshot.data.documents[index]['content'],
                      snapshot.data.documents[index]['url'],
                      snapshot.data.documents[index]['user'],
                      snapshot.data.documents[index]['isFavourite'],
                    );
          });
        }
      }
    );
  }

  Container _buildHeader(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 50.0, bottom: 40.0),
      height: 200.0,
      child: Stack(
        children: <Widget>[
          Container(
            width: 400.0,
            padding: EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0, bottom: 10.0),
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 60.0),
                  Text("Victor", style: Theme.of(context).textTheme.title),
                  SizedBox(height: 10.0),
                  Text("Email: victor666@gmail.com"),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Material(
                elevation: 5.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  radius: 40.0,
                  //avator image here
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}