import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:maga/camera/labelCheck.dart';
import 'package:maga/camera/recycleModel.dart';

class ResultScreen extends StatefulWidget {
  //final bool iconCheck;
  final List<ImageLabel> labels;
  final File imageFile;

  ResultScreen(this.labels, this.imageFile);
  //ResultScreen(this.iconCheck,);
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String result = 'Not recycle';
  String comment = 'this item can not be recycled';
  // Future<FirebaseUser> user = FirebaseAuth.instance.currentUser();
  FirebaseAuth auth = FirebaseAuth.instance;
  int result_type = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (ImageLabel label in widget.labels) {
      //label.text
      int a = LabelCheck().check(label.text);
      if (a == 0) {
        continue;
      }
      if (a == 1) {
        result = RecycleModel().displayHistory[a];
        comment = RecycleModel().commentCheck(a);
        result_type = a;
        break;
      }
      if (a == 2) {
        result = RecycleModel().displayHistory[a];
        comment = RecycleModel().commentCheck(a);
        result_type = a;
        break;
      }
      if (a == 3) {
        result = RecycleModel().displayHistory[a];
        comment = RecycleModel().commentCheck(a);
        result_type = a;
        break;
      }
    }
  }

  // String commentCheck(int result) {
  //   if(result == 0){
  //     return null;
  //   }
  //   if (result == 1) {
  //     return 'this item can be recycled';
  //   }
  //   if (result == 2) {
  //     return 'please contact local council for pick up or drop off';
  //   }
  //   if (result == 3) {
  //     return 'this is E-waste please contact local council for pick up or drop off';
  //   }
  //   return '';
  // }

  void delete() {}
   save() async {
    try {
      FirebaseUser user = await auth.currentUser();
      StorageReference storageReference = FirebaseStorage()
          .ref()
          .child('scanImage/${user.email}/${DateTime.now()}');
      StorageUploadTask uploadTask = storageReference.putFile(widget.imageFile);
      await uploadTask.onComplete.then((_) {
        print('upload complete');
      }).catchError((data) {
        print('result screen save error : ' + data);
      });
      var url = await storageReference.getDownloadURL();
      await Firestore.instance.collection('scanHistory').document().setData({
        'user': user.email,
        'result_type': result_type,
        'imageurl': url,
        'date': DateTime.now().toLocal()
      });
    } catch (e) {
      print('result screen save error1 : ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('fk'+widget.labels[0].text.toString());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Result'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                //CircularProgressIndicator();
                save();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Image.file(
                  widget.imageFile,
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
              Text(result),
              Text(comment),
              Container(
                height: MediaQuery.of(context).size.height - 225,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      title: Text(widget.labels[index].text),
                      subtitle: Text(widget.labels[index].entityId.toString() +
                          "\n" +
                          widget.labels[index].confidence.toString()),
                      isThreeLine: true,
                    );
                  },
                  itemCount: widget.labels.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
