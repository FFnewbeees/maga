import 'dart:ffi';

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {

  final List<Map> collections = [
    {
      "title":"Some Recycle News",
      "image": "assets/recycling.jpg",
    },
    {
      "title":"Some Tips",
      "image":"assets/recycling.jpg",
    },
    {
      "title":"Some random News",
      "image":"assets/recycling.jpg",
    },
    {
      "title":"Some thing",
      "image":"assets/recycling.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    if(index==2) return _buildCollectionsRow();
    if(index==3) return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
      // child: Text("Most liked posts",
      //   style: Theme.of(context).textTheme.title
      // )
    );
    // return _buildListItem();
  }

  // Widget _buildListItem(){
  //   return Container(
  //     color: Colors.white,
  //     padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(5.0),
  //       child: Image.asset('assets/recycling.jpg', fit: BoxFit.cover),
  //     ),
  //   );
  // }

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
    return Container(
      color: Colors.white,
      height: 340.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount:collections.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            margin:EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            width: 300.0,
            height: 250.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset('assets/recycling.jpg', fit: BoxFit.cover),
                  )
                ),
                SizedBox(height: 5.0),
                Text(collections[index]['title'], style: Theme.of(context).textTheme.subhead.merge(TextStyle(color: Colors.grey.shade600)))
              ],
            ),
          );
        },
      ),
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