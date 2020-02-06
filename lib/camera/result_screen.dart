import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maga/camera/labelCheck.dart';
import 'package:maga/camera/recycleModel.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ResultScreen extends StatefulWidget {
  final bool iconCheck;
  final List<ImageLabel> labels;
  final File imageFile;
  final String imageUrl;
  final int resultType;
  String documentID;
  final FirebaseUser user;
  // final FirebaseUser user;
  ResultScreen(this.iconCheck, this.labels, this.imageFile, this.imageUrl,
      this.resultType, this.documentID, this.user);
  //ResultScreen(this.iconCheck,);
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String result = 'Not recyclable';
  String comment = 'This item can not be recycled';
  // Future<FirebaseUser> user = FirebaseAuth.instance.currentUser();
  FirebaseAuth auth = FirebaseAuth.instance;
  int result_type = 0;
  @override
  void initState() {
    // TODO: implement initState
   // print("camera screen test1");
    super.initState();
    if (!widget.iconCheck) {
    //  print("camera screen test2");
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
      print(widget.imageFile.toString());
    } else {
      result = RecycleModel().displayHistory[widget.resultType];
      comment = RecycleModel().commentCheck(widget.resultType);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("disposed");
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
  void dialogCancel() {
    Navigator.of(context).pop();
  }

  void dialogYes() async {
    // print(widget.documentID);
    // print(widget.user.email);
    Navigator.of(context).pop();
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.light;
    EasyLoading.instance.maskType = EasyLoadingMaskType.black;
    EasyLoading.show(status: '');
    var tmp = await Firestore.instance
        .collection('scanHistory')
        .document(widget.documentID)
        .get();
    //print(tmp.data);
    StorageReference storageReference =
        await FirebaseStorage().getReferenceFromUrl(tmp.data['imageurl']);
    storageReference.delete();
    await Firestore.instance
        .collection('scanHistory')
        .document(widget.documentID)
        .delete();
    EasyLoading.showSuccess('');

    Navigator.of(context).pop();
  }

  void delete() async {
    //Navigator.of(context).pop();
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Delete?"),
            content: Text("Do you want to delete?"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Yes'),
                onPressed: () {
                  //Navigator.of(context).pop();
                  dialogYes();
                },
              ),
              CupertinoDialogAction(
                child: Text('No'),
                onPressed: () {
                  dialogCancel();
                },
              ),
            ],
          );
        });
  }

  void save() async {
    try {
      //FirebaseUser user = await auth.currentUser();
      EasyLoading.instance.loadingStyle = EasyLoadingStyle.light;
      EasyLoading.instance.maskType = EasyLoadingMaskType.black;
      EasyLoading.show(status: '');
      StorageReference storageReference = FirebaseStorage()
          .ref()
          .child('scanImage/${widget.user.email}/${DateTime.now()}');
      StorageUploadTask uploadTask = storageReference.putFile(widget.imageFile);
      await uploadTask.onComplete.then((_) {
        print('upload complete');
      }).catchError((data) {
        print('result screen save error : ' + data);
      });
      var url = await storageReference.getDownloadURL();
      await Firestore.instance.collection('scanHistory').document().setData({
        'user': widget.user.email,
        'result_type': result_type,
        'imageurl': url,
        'date': DateTime.now().toLocal()
      });
      //AppBar().actions.
      EasyLoading.showSuccess('',duration: new Duration(seconds:1));
    } catch (e) {
      print('result screen save error1 : ' + e.toString());
    }
  }

  TextStyle getColor(){
    var type;
    if(!widget.iconCheck) type = result_type;
    else type = widget.resultType;

      if(type == 0){
        return TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.red);
      }

      else if(type == 1){
        return TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green);
      }

      else if(type == 2){
        return TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blue);
      }

      else{
        return TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blue);
      }
    }

  Column getWidget(){
    if(widget.resultType == 1){
      return Column(
        children: <Widget>[
          SizedBox(height: 20),
          new Image.asset('assets/recyclable.png', width: 100, height: 100,),
          SizedBox(height: 20),
          Text('Please put this item into the yellow recycle bin', 
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
        ],
      );
    }
    else if(widget.resultType == 0){
      return Column(
        children: <Widget>[
          SizedBox(height: 20),
          new Image.asset('assets/unrecyclable.png', width: 100, height: 100,),
          SizedBox(height: 20),
          Text('Please put this item into the waste bin',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      );
    }
    else if(widget.resultType == 2){
      return Column(
        children: <Widget>[
          SizedBox(height: 20),
          new Image.asset('assets/council.png', width: 100, height: 100,),
          SizedBox(height: 20),
          Text('Council Contact Number: 02 9265 9333' , 
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
        ],
      );
    }
    else {
      return Column(
        children: <Widget>[
          SizedBox(height: 20),
          new Image.asset('assets/council.png', width: 100, height: 100,),
          SizedBox(height: 20),
          Text('Council Contact Number: 02 9265 9333', 
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
        ],
      );
    }
  }

  
    
  

  @override
  Widget build(BuildContext context) {
    // print('fk'+widget.labels[0].text.toString());
    return FlutterEasyLoading(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Result'),
          actions: <Widget>[
            widget.iconCheck
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      //CircularProgressIndicator();
                      print('delete');
                      delete();
                    },
                  )
                : IconButton(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: widget.iconCheck
                    ?
                    //   Image.network(
                    //         widget.imageUrl,
                    //         fit: BoxFit.cover,
                    //         height: 200,
                    //       )
                    FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: widget.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        widget.imageFile,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
              ),
              Text(result , style: getColor(),) ,
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(comment, style: TextStyle(fontSize: 15,),),
              ),
              
              widget.iconCheck
                  ? getWidget()
                  : Container(
                      height: MediaQuery.of(context).size.height - 225,
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          return ListTile(
                            title: Text(widget.labels[index].text),
                            subtitle: Text(
                                widget.labels[index].entityId.toString() +
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
