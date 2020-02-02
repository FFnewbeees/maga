import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maga/camera/recycleModel.dart';
import './result_screen.dart';

class PictureItem extends StatelessWidget {
  final imageUrl;
  final date;
  final result;
  final dateFormat = DateFormat('yyyy-MM-dd');
  PictureItem(this.imageUrl, this.date, this.result);
  String resultDisplay(int result) {
    return RecycleModel().displayHistory[result];
  }

  @override
  Widget build(BuildContext context) {
    //print(date.toDate());
    return InkWell(
     onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ResultScreen(true,null,imageUrl,result))),
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
                  child: Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
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
