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

class CameraScreen extends StatefulWidget {
  //inal FirebaseUser user;
  //CameraScreen(this.user);
  @override
  _CameraScreenState createState() => _CameraScreenState();
  CameraScreen({Key key}) : super(key: key);
}

class _CameraScreenState extends State<CameraScreen> {
  File image;
  List<ImageLabel> labels = [];
  bool showLoader = false;
  final ImageLabeler cloudLabeler = FirebaseVision.instance.cloudImageLabeler();
  FirebaseUser user;
  Stream<QuerySnapshot> snapQuery;

  // FirebaseUser user = await FirebaseAuth.instance.currentUser();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getQurey();
  }

  @override
  void dispose() {
    super.dispose();
    //Firestore.instance.
  }

  Future<String> _getFirebaseUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    this.user = user;
    print("abcd  ${user.toString()}");
    if (user == null) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => Login()));
    }
    return user.email;
  }

  Future<void> _getQurey() async {
    // print(_getFirebaseUser().toString() + ".....fkfkfkfkfkfkfkfkkf");
    final userPath = await _getFirebaseUser();
    //this.user = userPath;
    print(userPath + "  ...fkfkfk");
    final response = Firestore.instance
        .collection('scanHistory')
        .where('user', isEqualTo: userPath)
        .orderBy('date', descending: true)
        .snapshots();

    snapQuery = response;
  }

  Widget streamBuilder() {
    return StreamBuilder(
      //initialData: Firestore.instance.collection('scanHistory') .where('user', isEqualTo: this.user.email).snapshots(),
      stream: snapQuery,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return new Center(
            child: Text("Error on streambuilder: ${snapshot.error.toString()}"),
          );
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Loader();
            break;
          case ConnectionState.none:
            print('connection none');
            snapQuery = Firestore.instance
                .collection('scanHistory')
                .where('user', isEqualTo: user)
                .orderBy('date', descending: true)
                .snapshots();
            return streamBuilder();
            break;

          case ConnectionState.active:
            print('connection active');
            if (!snapshot.hasData) {
              print("fking hell");
              return Loader();
            }

            return ListView.builder(
              itemBuilder: (ctx, index) {
                return PictureItem(
                    snapshot.data.documents[index]['imageurl'],
                    snapshot.data.documents[index]['date'] as Timestamp,
                    snapshot.data.documents[index]['result_type']);
              },
              itemCount: snapshot.data.documents.length,
            );
            break;
          case ConnectionState.done:
            print('connection done');
            if (!snapshot.hasData) {
              print("fking hell");
              return Loader();
            }

            return ListView.builder(
              itemBuilder: (ctx, index) {
                return PictureItem(
                    snapshot.data.documents[index]['imageurl'],
                    snapshot.data.documents[index]['date'],
                    snapshot.data.documents[index]['result_type']);
              },
              itemCount: snapshot.data.documents.length,
            );
            break;
        }
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

  void _getImage(BuildContext context, ImageSource imageSource) async {
    setState(() {
      showLoader = true;
    });
    try {
      image = await ImagePicker.pickImage(source: imageSource);
      labels =
          await cloudLabeler.processImage(FirebaseVisionImage.fromFile(image));
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
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultScreen(false, labels, image)));
  }
}
