
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maga/user_profile/editProfile.dart';

import '../loader/loader.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maga/user_profile/favNewsItem.dart';
import '../authentication/signIn.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ProfilePage extends StatefulWidget {
  final FirebaseUser user;
  ProfilePage(this.user);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  List<FavNewsItem> collections = [];
  bool _isLoading = false;
  File image;
  bool reloadProfile = false;
  String url;
  Stream<QuerySnapshot> querySnapshot;

  @override               
    void initState(){
    super.initState();
    url = widget.user.photoUrl;
    getQuery();
  }
  
  void signOut() async{
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> Login()));

  }

  void getQuery() async{    
    querySnapshot = Firestore.instance
    .collection('favouriteNews')
    .where('user', isEqualTo:widget.user.email)
    .orderBy('date', descending: true)
    .snapshots();

    print('got data');

  }

    var targetPath;
    void getFileimage() async {
    final dir = await path_provider.getTemporaryDirectory();
    targetPath = dir.absolute.path + '${DateTime.now()}.jpg';
   }

    void _getImage(BuildContext context, ImageSource imageSource) async {
    var compressedFile;
      setState(() {
        reloadProfile = true;
      });

    try {
      image = await ImagePicker.pickImage(source: imageSource);
      await getFileimage();
      compressedFile = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path, 
        targetPath, 
        quality: 40
        );

      StorageReference storageReference = FirebaseStorage()
        .ref()
        .child('userProfle/${widget.user.email}/profilePicture.jpg');

      StorageUploadTask uploadTask = storageReference.putFile(compressedFile);
      await uploadTask.onComplete.then((_){
        print('upload completed');
      }).catchError((onError){
        print('upload has error' + onError.toString());
      });

      var downloadURL = await storageReference.getDownloadURL();
      url = downloadURL;
      print(downloadURL);

      UserUpdateInfo newProfileImage = UserUpdateInfo();
      newProfileImage.photoUrl = downloadURL.toString();
      
      await widget.user.updateProfile(newProfileImage);

      await widget.user.reload();

    } catch (e) {
      print(e);
      setState(() {
        reloadProfile = false;
      });
      return;
    }
    
    setState(() {
      reloadProfile = false;
      //widget.user.reload();
    });
    
  }

    void _cameraAction() {
    showCupertinoModalPopup(
        context: context,
        builder: (ctx) {
          return new CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const Text('Open Camera'),
                onPressed: () {
                  _getImage(context, ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('Open Gallery'),
                onPressed: () {
                  _getImage(context, ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            message: Text("Please choose a beautiful profile image"),
          );
        });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     icon: Icon(Icons.settings),
        //     onPressed: (){
        //       Navigator.pushNamed(context,
        //         EditProfile.routeName, 
        //         arguments: {
        //           'profileImage': widget.user.photoUrl,
        //       });
        //     },
        //   ),
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              signOut();
            },)
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
    .where('user', isEqualTo:widget.user.email)
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
                  SizedBox(height: 70.0),
                  FlatButton(
                      child: Text('Change Profile Photo'),
                      color: Colors.grey[350],
                      onPressed: () async {
                        _cameraAction();
                      },
                    ),
                  SizedBox(height: 10.0),
                  Text("Email:" + " " +widget.user.email),
                  SizedBox(height: 20.0),
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
                child: reloadProfile ? CircleAvatar(child: CircularProgressIndicator(),radius: 40.0, backgroundColor: Colors.transparent,) : CircleAvatar(
                  backgroundImage:  NetworkImage(url.toString()) ,
                  backgroundColor: Colors.transparent,
                  radius: 50.0,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}