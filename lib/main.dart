import 'package:flutter/material.dart';
import 'package:google_app_ios_layout/home.dart';
import 'package:google_app_ios_layout/collections.dart';
import 'package:google_app_ios_layout/more.dart';
import 'package:google_app_ios_layout/recent.dart';
import 'package:google_app_ios_layout/model/mockdata.dart';
import 'package:provider/provider.dart';

void main() => runApp(GoogleSearchApp());

class GoogleSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'ProductSans',

      ),
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider<MockUserData>(
        builder: (_) => MockUserData(
            name: 'Jon Snow',
            email: 'youaremyqueen@westeros.com',
            imageUrl:
                'https://i0.wp.com/metro.co.uk/wp-content/uploads/2019/04/SEI_601281802.jpg?quality=90&strip=all&zoom=1&resize=644%2C428&ssl=1'),
        child: HooliSearchHomeApp(),
      ),
    );
  }
}


class HooliSearchHomeApp extends StatefulWidget {
  @override
  _HooliSearchHomeAppState createState() => _HooliSearchHomeAppState();
}

class _HooliSearchHomeAppState extends State<HooliSearchHomeApp> with SingleTickerProviderStateMixin {
  @override

  int _currentIndex = 0;
  TabController _tabController;

  final List<Widget> _tabs = [
    HomeTab(),
    CollectionsTab(),
    RecentTab(),
    MoreTab(),
  ];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);

  }
  void onTabTapped(int index) {

    if(index == 0) {
      print("Home Tab tapped");
    }
    setState(() {
      _currentIndex = index;
    });

    _tabController.animateTo(_currentIndex);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.black87,
        onTap: onTabTapped,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            title: Text('Collections'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            title: Text('Recent'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            title: Text('More'),
          ),
        ],
      ),

    );
  }
}
