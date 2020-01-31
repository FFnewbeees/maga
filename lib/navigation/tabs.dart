import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../camera/camera_screen.dart';
import '../news_feed/newsPage.dart';
import '../user_profile/profile.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  List<Map<String, Object>> _pages = [];

  @override
  void initState() {
    _pages = [
      {'page': CameraScreen(), 'title': 'Scanner'},
      {'page': NewsPage(), 'title': 'News Feed'},
      {'page': ProfilePage(), 'title': 'Profile'},
    ];

    _welcomeMessage();

    super.initState();
  }

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Future _welcomeMessage() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    if(user != null){
      return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context){
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('Message'),
              content: Text('Welcome' + user.email),
              elevation: 24.0,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
            );
          }
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).accentColor,
            icon: Icon(Icons.camera_enhance),
            title: Text('Scanner'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).accentColor,
            icon: Icon(Icons.dashboard),
            title: Text('News Feed'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).accentColor,
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}
