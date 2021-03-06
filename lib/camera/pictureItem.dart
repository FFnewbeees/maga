import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../camera/recycleModel.dart';
import './result_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class PictureItem extends StatelessWidget {
  final imageUrl;
  final date;
  final result;
  final dateFormat = DateFormat('yyyy-MM-dd');
  final documentID;
  final FirebaseUser user;
  PictureItem(this.imageUrl, this.date, this.result,this.documentID,this.user);
  String resultDisplay(int result) {
    return RecycleModel().displayHistory[result];
  }


  @override
  Widget build(BuildContext context) {
    //print(date.toDate());
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ResultScreen(true,null,new File('abc.txt'),imageUrl,result,documentID,user))),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // Image.network(
                    //   imageUrl,
                    //   height: 160,
                    //   width: double.infinity,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.date_range,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(dateFormat.format(date.toDate())),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      result == 0
                          ? Icon(
                              Icons.thumb_down,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.thumb_up,
                              color: Colors.green,
                            ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(resultDisplay(result)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
