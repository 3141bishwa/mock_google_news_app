
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_app_ios_layout/model/mockdata.dart';

class MoreTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        child: Column(
          children: [
            Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Image.asset(
                    'assets/images/png_logo.png',
                    height: 25.0,
                  ),
                )
            ),



            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(Provider.of<MockUserData>(context).imageUrl),
              ),
              title: Text(Provider.of<MockUserData>(context).name),
              subtitle: Text(Provider.of<MockUserData>(context).email),
            ),

            Divider(color: Colors.black12, thickness: 0.5,),

            Flexible(
              child: ListView(
                children: <Widget>[


                  ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Search Activity')
                  ),
                  ListTile(
                      leading: Icon(Icons.star),
                      title: Text('Discover')
                  ),
                  ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Turn on incognito')
                  ),
                  ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings')
                  ),
                  ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Your data in Search')
                  ),
                  ListTile(
                      leading: Icon(Icons.feedback),
                      title: Text('Send feedback')
                  ),
                  ListTile(
                      leading: Icon(Icons.help),
                      title: Text('Help')
                  ),

                ],
              ),
            )

          ]
        ),
      ),
    );
  }
}