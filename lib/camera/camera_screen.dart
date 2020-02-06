import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maga/authentication/signIn.dart';
import 'package:maga/camera/pictureItem.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:maga/camera/result_screen.dart';
import 'package:maga/loader/loader.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
class CameraScreen extends StatefulWidget {
  //inal FirebaseUser user;
  //CameraScreen(this.user);
  final FirebaseUser user;
  CameraScreen(this.user);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File image;
  List<ImageLabel> labels = [];
  bool showLoader = false;
  final ImageLabeler cloudLabeler = FirebaseVision.instance.cloudImageLabeler();
  //FirebaseUser user;
  Stream<QuerySnapshot> snapQuery;

  // FirebaseUser user = await FirebaseAuth.instance.currentUser();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getQurey();
   // print();
  }

  void _getQurey() {
    snapQuery = Firestore.instance
        .collection('scanHistory')
        .where('user', isEqualTo: widget.user.email)
        .orderBy('date', descending: true)
        .snapshots();

      // Firestore.instance.collection('').where('').getDocuments()
  }

  Widget streamBuilder() {
    return StreamBuilder(
      //initialData: Firestore.instance.collection('scanHistory') .where('user', isEqualTo: this.user.email).snapshots(),
      stream: snapQuery = Firestore.instance
          .collection('scanHistory')
          .where('user', isEqualTo: widget.user.email)
          .orderBy('date', descending: true)
          .snapshots(),
        
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        /// print(snapshot.data.documents.length);
        if (snapshot.hasError) {
          return new Center(
            child: Text("Error on streambuilder: ${snapshot.error.toString()}"),
          );
        }
        if(!snapshot.hasData) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return new Center(child: Text("No data Scann one"),);
          }
          return new Loader();
        } else {
          // print(snapshot.data.documents.length);
           //print(snapshot.connectionState.toString());
          if(snapshot.connectionState == ConnectionState.waiting){
            return new Center(child: Text("No data Scann one"),);
          }
          
          return new ListView.builder(
            itemExtent: 234,
            //cacheExtent: 100.0,
            addAutomaticKeepAlives: true,
            itemBuilder: (ctx, index) {
            //  print(snapshot.data.documents[index].documentID);
              return PictureItem(
                  snapshot.data.documents[index]['imageurl'],
                  snapshot.data.documents[index]['date'] as Timestamp,
                  snapshot.data.documents[index]['result_type'],
                  snapshot.data.documents[index].documentID,
                  widget.user
              );
            },
            itemCount: snapshot.data.documents.length,
          );
          
        }
        //print(snapshot.requireData.documents.length);
        // switch (snapshot.connectionState) {
        //   case ConnectionState.waiting:
        //     return Loader();
        //     break;
        //   case ConnectionState.none:
        //     print('connection none');

        //     //return streamBuilder();
        //     break;

        //   case ConnectionState.active:
        //     print('connection active');
        //     if (!snapshot.hasData) {
        //       print("fking hell");
        //       return Loader();
        //     }
        //    // snapshot.data.document
        //     //print();
        //     return ListView.builder(

        //       itemBuilder: (ctx, index) {
        //         return PictureItem(
        //             snapshot.data.documents[index]['imageurl'],
        //             snapshot.data.documents[index]['date'] as Timestamp,
        //             snapshot.data.documents[index]['result_type']);
        //       },
        //       itemCount: snapshot.data.documents.length,
        //     );
        //     break;
        //   case ConnectionState.done:
        //     print('connection done');
        //     if (!snapshot.hasData) {
        //       print("fking hell");
        //       return Loader();
        //     }

        //     return ListView.builder(
        //       itemBuilder: (ctx, index) {
        //         return PictureItem(
        //             snapshot.data.documents[index]['imageurl'],
        //             snapshot.data.documents[index]['date'],
        //             snapshot.data.documents[index]['result_type']);
        //       },
        //       itemCount: snapshot.data.documents.length,
        //     );
        //     break;
        // }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner'),
      ),
      body: showLoader
          ? Center(
              child: Loader(),
            )
          : streamBuilder(),
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: _cameraAction,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
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
              SizedBox(
                height: 10,
              ),
              CupertinoActionSheetAction(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
  var targetPath;
  void getFileimage() async{
    final dir = await path_provider.getTemporaryDirectory();
    targetPath = dir.absolute.path + '/temp.jpg';
  } 
  
  void _getImage(BuildContext context, ImageSource imageSource) async {
    var compressedFile;
    setState(() {
      showLoader = true;
    });
    try {
      image = await ImagePicker.pickImage(source: imageSource);
      await getFileimage();
      labels =
          await cloudLabeler.processImage(FirebaseVisionImage.fromFile(image));
      compressedFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path, targetPath ,quality: 40);
    } catch (e) {
      print(e);
      setState(() {
        showLoader = false;
      });
      return;
    }
    setState(() {
      showLoader = false;
    });
    print("length of result " + labels.length.toString());
    for (ImageLabel label in labels) {
      print(label.confidence);
      print(label.entityId);
      print(label.text);
      print("----------------\n");
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ResultScreen(false,labels, compressedFile,targetPath.toString(),0,null,widget.user)));
  }
}
