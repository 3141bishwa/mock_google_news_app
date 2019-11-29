import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

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
        'http://newsapi.org/v2/top-headlines?country=us&apiKey=7c0325c05d0545168c09765c234efd43');
    setState(() {
      newsList = NewsList.fromList(jsonDecode(response.body)).news;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: GridView.builder(
          //shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: newsList.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
          itemBuilder: (BuildContext context, int index) {
            double c_width = MediaQuery.of(context).size.width * 0.6;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.only(top: 30.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 20.0,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: FittedBox(
                        child: CachedNetworkImage(
                          height: 200.0,
                          imageUrl: newsList[index].imageUrl,
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                        fit: BoxFit.fitWidth,
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
                          Text(
                            newsList[index].description,
                            style: Theme.of(context).textTheme.body1,
                            textAlign: TextAlign.left,
                            //overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
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

  News(
      {Key key,
      @required this.headline,
      @required this.description,
      @required this.imageUrl});

  News.fromJson(Map<String, dynamic> newsJson)
      : headline = newsJson['title'],
        description = newsJson['description'],
        imageUrl = newsJson['urlToImage'];
}

class NewsList {
  List<News> news;

  NewsList({Key key, @required this.news});

  NewsList.fromList(Map<String, dynamic> jsonResponse)
      : news = List.from(jsonResponse['articles'])
            .map((news) => News.fromJson(news))
            .toList();
}
