import 'package:flutter/material.dart';
import './result_screen.dart';

class PictureItem extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      //onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ResultScreen())),
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
                  child: Image.asset(
                    'assets/recycling.jpg',
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.date_range,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text('18/01/2020'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.done_outline,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text('recycle'),
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
