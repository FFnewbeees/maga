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

  Widget nodata() {
    return Center(
        child: new Image.asset(
      'assets/nodata.png',
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.8,
    ));
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
        if (!snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return nodata();
          }
          return new Loader();
        } else {
          // print(snapshot.data.documents.length);
          //print(snapshot.connectionState.toString());
          if (snapshot.connectionState == ConnectionState.waiting) {
            return nodata();
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
                  widget.user);
            },
            itemCount: snapshot.data.documents.length,
          );
        }
      },
    );
  }

  //void showHint() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                showDialog();
              })
        ],
      ),
      body: showLoader
          ? Center(
              child: Loader(),
            )
          : streamBuilder(),
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          // await showDialog();
          _cameraAction();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget dialogWidget() {
    return Container(
      width: 190,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  Text(
                    'What belongs in the yellow bin',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            Text(
              "\u2022 aluminium and steel tins and cans",
              softWrap: true,
            ),
            Text(
              "\u2022 aerosol cans",
              softWrap: true,
            ),
            Text(
              "\u2022 aluminium foil",
              softWrap: true,
            ),
            Text(
              "\u2022 glass bottles and jars",
              softWrap: true,
            ),
            Text(
              "\u2022 plastic soft-drink and water bottles",
              softWrap: true,
            ),
            Text(
              "\u2022 plastic food containers",
              softWrap: true,
            ),
            Text(
              "\u2022 juice and milk bottles",
              softWrap: true,
            ),
            Text(
              "\u2022 plastic containers for laundry",
              softWrap: true,
            ),
            Text(
              "\u2022 newspapers, magazines,advertising",
              softWrap: true,
            ),
            Text(
              "\u2022 egg cartons",
              softWrap: true,
            ),
            Text(
              "\u2022 envelopes",
              softWrap: true,
            ),
            Text(
              "\u2022 cardboard boxes",
              softWrap: true,
            ),
            Text(
              "\u2022 pizza boxes",
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  void showDialog() async {
    await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Recycle rule"),
            content: dialogWidget(),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  //_getImage(context, ImageSource.camera);
                  // _cameraAction();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
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
                  // showDialog();
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
            message: Text("Please focus on one object at a time\nEnjoy :)"),
          );
        });
  }

  var targetPath;
  void getFileimage() async {
    final dir = await path_provider.getTemporaryDirectory();
    targetPath = dir.absolute.path + '${DateTime.now()}.jpg';
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
          image.absolute.path, targetPath,
          quality: 40);
    } catch (e) {
      print(e);
      setState(() {
        showLoader = false;
      });
      return;
    }

    print("length of result " + labels.length.toString());
    for (ImageLabel label in labels) {
      print(label.confidence);
      print(label.entityId);
      print(label.text);
      print("----------------\n");
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ResultScreen(false, labels, compressedFile,
            targetPath.toString(), 0, null, widget.user)));
    setState(() {
      showLoader = false;
    });
  }
}
