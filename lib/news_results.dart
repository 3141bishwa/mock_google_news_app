import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_app_ios_layout/news.dart';
import 'package:google_app_ios_layout/news_page.dart';
import 'package:http/http.dart' as http;

class NewsWidget extends StatefulWidget {
  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  Future<List<News>> newsList;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    newsList = this.getNews("");
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<List<News>> getNews(String news) async {
    var apiType;
    if (news == "") {
      apiType = "top-headlines?country=us";
    } else {
      apiType = "everything?q=$news";
    }
    var response = await http.get(
        'https://newsapi.org/v2/$apiType&apiKey=7c0325c05d0545168c09765c234efd43');

    return NewsList.fromList(jsonDecode(response.body)).news;
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;

    var padding;
    if (!useMobileLayout) {
      padding = 50.0;
    } else if (isPortrait) {
      padding = 5.0;
    } else {
      padding = 150.0;
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Column(children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 200.0, vertical: 20.0),
          child: CupertinoTextField(
            onSubmitted: (text) {
              setState(() {
                newsList = getNews(text);
              });
            },
            controller: _textController,
            clearButtonMode: OverlayVisibilityMode.editing,
          ),
        ),
        FutureBuilder(
          future: newsList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text('Try again'),
                );
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError)
                  return Center(
                    child: Text('Try again'),
                  );
                return NewsGrid(news: snapshot.data);
            } // unreachable
          },
        ),
      ]),
    );
  }
}

class NewsGrid extends StatelessWidget {
  final List<News> news;

  NewsGrid({this.news});

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;

    return StaggeredGridView.countBuilder(
      key: PageStorageKey('News'),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: useMobileLayout ? 1 : 2,
      itemCount: news.length,
      itemBuilder: (BuildContext context, int index) {
        return NewsCard(news: news[index]);
      },
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}

class NewsCard extends StatelessWidget {
  final News news;

  NewsCard({this.news});

  void _navigateToWebPage(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NewsPage(
                webUrl: news.webPageUrl,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (news == null) {
      return Text("Something wrong");
    } else {
      var webUrlfront = news.webPageUrl.split("/")[2];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(top: 30.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 2.0,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _navigateToWebPage(context);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: FadeInImage(
                          placeholder:
                              AssetImage('assets/images/news_placeholder.png'),
                          image: CachedNetworkImageProvider(news.imageUrl),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              news.headline,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'ProductSans',
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              child: Text(
                                news.description,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                NewsSourceInfo(
                  webUrlFront: webUrlfront,
                  newsSource: news.source,
                  publishedDate: news.publishedDate,
                ),
              ],
            )),
      );
    }
  }
}

class NewsSourceInfo extends StatelessWidget {
  final String webUrlFront;
  final String newsSource;
  final String publishedDate;
  NewsSourceInfo({this.webUrlFront, this.newsSource, this.publishedDate});

  Map<String, dynamic> getDiff(String time) {
    var difference = DateTime.now().difference(DateTime.parse(time));

    var unit;
    var val;

    if (difference.inDays > 0) {
      val = difference.inDays;
      unit = val == 1 ? "day" : "days";
    } else if (difference.inHours > 0) {
      val = difference.inHours;
      unit = val == 1 ? "hour" : "hours";
    } else if (difference.inMinutes > 0) {
      val = difference.inMinutes;
      unit = val == 1 ? "minute" : "minutes";
    } else {
      unit = "";
    }

    return {'val': val, 'unit': unit};
  }

  @override
  Widget build(BuildContext context) {
    Map dateDiff = getDiff(publishedDate);

    var timeSincePublished = dateDiff['unit'] == ""
        ? "Just Now"
        : "${dateDiff['val']} ${dateDiff['unit']} ago";
    print(timeSincePublished);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          leading: Image.network(
            'https://logo.clearbit.com/$webUrlFront',
            height: 20.0,
          ),
          title: RichText(
            text: TextSpan(
                style: TextStyle(fontSize: 12, color: Colors.black54),
                children: <TextSpan>[
                  TextSpan(text: newsSource),
                  TextSpan(text: " · "),
                  TextSpan(text: timeSincePublished),
                ]),
          ),
          trailing: InkWell(
            onTap: () {
              print("Tapped");
            },
            child: Icon(Icons.more_vert),
          ),
        ),
      ),
    );
  }
}
