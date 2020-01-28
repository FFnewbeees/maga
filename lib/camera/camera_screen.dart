import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maga/camera/pictureItem.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:maga/camera/result_screen.dart';
import 'package:maga/loader/loader.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File image;
  List<ImageLabel> labels = [];
  bool showLoader = false;
  final ImageLabeler cloudLabeler = FirebaseVision.instance.cloudImageLabeler();
  Future user = FirebaseAuth.instance.currentUser();
  // FirebaseUser user = await FirebaseAuth.instance.currentUser();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // user.then(onValue)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showLoader
          ? Center(
              child: Loader(),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return PictureItem();
              },
              itemCount: 1,
            ),
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
    print("length of result "+labels.length.toString());
    for (ImageLabel label in labels) {
      print(label.confidence);
      print(label.entityId);
      print(label.text);
      print("----------------\n");
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ResultScreen(false,labels,image)));
  }
}
