import 'package:flutter/material.dart';

class News extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color bgColor = Color(0xffF3F3F3);
    final Color primaryColor = Colors.greenAccent;

    var titleTextStyle = TextStyle(color: Colors.black87, fontSize: 20.0);
    var teamNameTextStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: Colors.grey.shade800,
    );
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "News Feed",
          style: TextStyle(color: Colors.black, fontSize: 30.0),
        ),
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 600,
              margin: EdgeInsets.only(top: 10),
              child: ListView(
                padding: EdgeInsets.all(16.0),
                
                children: <Widget>[
                  Center(
                    child: ToggleButtons(
                      fillColor: primaryColor,
                      hoverColor: primaryColor,
                      renderBorder: true,
                      borderRadius: BorderRadius.circular(10.0),
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.av_timer),
                              SizedBox(height: 16.0),
                              Text(
                                "Latest News",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16.0),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.public),
                              SizedBox(height: 16.0),
                              Text(
                                "Recycle News",
                              )
                            ],
                          ),
                        ),
                      ],
                      isSelected: [
                        true,
                        false,
                      ],
                      onPressed: (index) {},
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                              ),
                              child: Image.asset('assets/recycling.jpg'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Kingston recycling centre denied extension for second time by council",
                                style: titleTextStyle,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Yesterday, 9:24 PM",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "Recycling",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                              ),
                              child: Image.asset('assets/recycling.jpg'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Kingston recycling centre denied extension for second time by council",
                                style: titleTextStyle,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Yesterday, 9:24 PM",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "Recycling",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20.0),
                          ],
                        ),
                      ],
                    ),
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
