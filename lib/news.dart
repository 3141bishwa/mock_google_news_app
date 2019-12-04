import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NewsWidget extends StatefulWidget {
  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  List<News> newsList = new List();

  @override
  void initState() {
    super.initState();
    this.getNews();
  }

  void getNews() async {
    var response = await http.get(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=7c0325c05d0545168c09765c234efd43');
    setState(() {
      newsList = NewsList.fromList(jsonDecode(response.body)).news;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          //shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: newsList.length,
          staggeredTileBuilder: (_) => StaggeredTile.fit(2),
          itemBuilder: (BuildContext context, int index) {
            if(newsList[index] != null) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.only(top: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 15.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: FadeInImage(
                          placeholder:  AssetImage('assets/images/news_placeholder.png'),
                          image: NetworkImage(newsList[index].imageUrl),
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
                              newsList[index].headline,
                              style: Theme.of(context).textTheme.title,
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              child: Text(
                                newsList[index].description,
                                style: Theme.of(context).textTheme.body1,
                                textAlign: TextAlign.left,
                                //overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              child: Text(
                                newsList[index].source,
                                style: Theme.of(context).textTheme.body1,
                                textAlign: TextAlign.left,
                                //overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );

            } else {
              return Text("Somethings not right");
            }

          },
        ),
      ),
    );
  }
}

class News {
  final String headline;
  final String imageUrl;
  final String description;
  final String source;

  News(
      {Key key,
        @required this.headline,
        @required this.description,
        @required this.imageUrl,
        @required this.source
      });

  News.fromJson(Map<String, dynamic> newsJson)
      : headline = newsJson['title'],
        description = newsJson['description'],
        imageUrl = newsJson['urlToImage'],
        source = newsJson['source']['name'];
}

class NewsList {
  List<News> news;

  NewsList({Key key, @required this.news});

  NewsList.fromList(Map<String, dynamic> jsonResponse)
      : news = List.from(jsonResponse['articles'])
            .map((news) {

              if(news['title'] != null && news['description'] != null && news['urlToImage'] != null && news['source']['name'] != null) {
                print(news['urlToImage']);
                return News.fromJson(news);
              }
            })
            .toList();
}
