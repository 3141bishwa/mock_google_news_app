import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
      theme: ThemeData(fontFamily: 'ProductSans'),
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider<MockUserData>(
        builder: (_) => MockUserData(
          name: 'Jon Snow', 
          email: 'youaremyqueen@westeros.com',
          imageUrl: 'https://i0.wp.com/metro.co.uk/wp-content/uploads/2019/04/SEI_601281802.jpg?quality=90&strip=all&zoom=1&resize=644%2C428&ssl=1'
        ),
        child: GoogleSearchHomeApp(),
      
      ),
    );
  }
}


class GoogleSearchHomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            title: Text('Home'),
          )  
          ,
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.collections),
            title: Text('Collections'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.phone),
            title: Text('Recent'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            title: Text('More'),
          ),
        ],
      ),


      tabBuilder: (context, index) {

        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HomeTab(),
              );
            },

            );

          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: CollectionsTab()
              );
            },

            );
          
          case 2:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: RecentTab()
              );
            },

            );

          case 3:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: MoreTab()
              );
            },

            );
        }
      },
    );
  }
}

