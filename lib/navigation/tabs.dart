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
  final List<Widget> _pages = [
    CameraScreen( key: PageStorageKey('scanner')),
    NewsPage(key: PageStorageKey('news')),
    ProfilePage(key: PageStorageKey('profile'))
  ];

  final PageStorageBucket bucket =PageStorageBucket();
  int _selectedPageIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
    onTap: (int index) => setState(()=>_selectedPageIndex = index),
    backgroundColor: Theme.of(context).accentColor,
    unselectedItemColor: Colors.white,
    selectedItemColor: Colors.black,
    currentIndex: selectedIndex,
    type: BottomNavigationBarType.shifting,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(59, 196, 185, 1),
            icon: Icon(Icons.camera_enhance),
            title: Text('Scanner'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(59, 196, 185, 1),
            icon: Icon(Icons.dashboard),
            title: Text('News Feed'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(59, 196, 185, 1),
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
    ],
  );

  @override
  void initState() {
    // _pages = [
    //   {'page': CameraScreen(), 'title': 'Scanner'},
    //   {'page': NewsPage(), 'title': 'News Feed'},
    //   {'page': ProfilePage(), 'title': 'Profile'},
    // ];

    _welcomeMessage();

    super.initState();
  }


  // void _selectPage(int index) {
  //   setState(() {
  //     _selectedPageIndex = index;
  //   });
  // }

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
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: _pages,
        index: _selectedPageIndex
        ),
      bottomNavigationBar: _bottomNavigationBar(_selectedPageIndex),
      // BottomNavigationBar(
      //   onTap: _selectPage,
      //   backgroundColor: Theme.of(context).accentColor,
      //   unselectedItemColor: Colors.white,
      //   selectedItemColor: Colors.black,
      //   currentIndex: _selectedPageIndex,
      //   type: BottomNavigationBarType.shifting,
      //   items: [
      //     BottomNavigationBarItem(
      //       backgroundColor: Theme.of(context).accentColor,
      //       icon: Icon(Icons.camera_enhance),
      //       title: Text('Scanner'),
      //     ),
      //     BottomNavigationBarItem(
      //       backgroundColor: Theme.of(context).accentColor,
      //       icon: Icon(Icons.dashboard),
      //       title: Text('News Feed'),
      //     ),
      //     BottomNavigationBarItem(
      //       backgroundColor: Theme.of(context).accentColor,
      //       icon: Icon(Icons.person),
      //       title: Text('Profile'),
      //     ),
      //   ],
      // ),
    );
  }
}
