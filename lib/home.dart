import 'package:flutter/material.dart';
import 'package:google_app_ios_layout/model/mockdata.dart';
import 'package:provider/provider.dart';
import 'package:google_app_ios_layout/search.dart';
import 'package:google_app_ios_layout/news.dart';

class HomeTab extends StatefulWidget {

  HomeTab({Key key}) : super(key: key);

  @override
  HomeTabState createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  final ScrollController _homeController = ScrollController();

  void getToTop() {
    _homeController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: PageStorageKey("Home"),
      body: CustomScrollView(
          controller: _homeController,
          //physics: AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              Provider.of<MockUserData>(context).imageUrl),
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 40,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/png_logo.png',
                      height: 50.0,
                    ),
                  ),
                  SearchText(),
                  //WeatherWidget(),
                ],
              ),
            ),
            SliverToBoxAdapter(child: NewsWidget()),
          ]),
    );
  }
}
