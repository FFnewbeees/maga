import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maga/authentication/signIn.dart';
import '../camera/camera_screen.dart';
import '../news_feed/newsPage.dart';
import '../user_profile/profile.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  List<Map<String, Object>> _pages = [];
  FirebaseUser user;
  @override
  void initState() {
    super.initState();

    print("fkfkfkffkfkfk" + user.toString());
    FirebaseAuth.instance.currentUser().then((user) {
      if (user == null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => Login()));
      }
    });
    _pages = [
      {'page': CameraScreen(), 'title': 'Scanner'},
      {'page': NewsPage(), 'title': 'News Feed'},
      {'page': ProfilePage(), 'title': 'Profile'},
    ];
    // if (user == null) {
    //   Navigator.of(context)
    //       .pushReplacement(MaterialPageRoute(builder: (_) => Login()));
    // }
  }

  // Future getFirebaseUser() async {
  //   user = await FirebaseAuth.instance.currentUser();
  //   if (user == null) {
  //     Navigator.of(context)
  //         .pushReplacement(MaterialPageRoute(builder: (_) => Login()));
  //   }
  // }

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
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
