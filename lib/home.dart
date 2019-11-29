import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_app_ios_layout/model/mockdata.dart';
import 'package:provider/provider.dart';
import 'package:google_app_ios_layout/search.dart';
import 'package:google_app_ios_layout/weather.dart';
import 'package:google_app_ios_layout/news.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(Provider.of<MockUserData>(context).imageUrl),
                )
              ],
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 40,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/png_logo.png',
                  height: 50.0,
                ),
              ),
              SearchText(),
              //WeatherWidget(),
              NewsWidget(),
            ],
          ),

        ],
      ),
    );
  }
}