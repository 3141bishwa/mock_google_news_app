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

  Future<List> newsList;

  @override
  void initState() {
    super.initState();
    newsList = this.getNews();
  }

  Future<List> getNews() async {
    var response = await http.get(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=7c0325c05d0545168c09765c234efd43');

    return NewsList.fromList(jsonDecode(response.body)).news;
    }


  @override
  Widget build(BuildContext context) {
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;

    var padding;
    if(!useMobileLayout) {
      padding = 50.0;
    } else if (isPortrait) {
      padding = 5.0;
    } else {
      padding = 150.0;
    }
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Container(
          child: FutureBuilder(
            future: newsList,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(child: Text('Try again'),);
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Center(child: Text('Check internet connection'));
                  return NewsGrid(news: snapshot.data);
              } // unreachable
            },
          )
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

class NewsGrid extends StatelessWidget {
  final List news;

  NewsGrid({this.news});

  @override
  Widget build(BuildContext context) {

    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;

    return StaggeredGridView.countBuilder(
      crossAxisCount: useMobileLayout? 1 : 2,
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
  final news;

  NewsCard({this.news});

  @override
  Widget build(BuildContext context) {
    if(news == null) {
      return Text("Something wrong");
    } else {
      return Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.only(top: 30.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 2.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: FadeInImage(
                  placeholder:  AssetImage('assets/images/news_placeholder.png'),
                  image: NetworkImage(news.imageUrl),
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
                      style: Theme.of(context).textTheme.title,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      child: Text(
                        news.description,
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
                        news.source,
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
    }
    ;
  }
  }


