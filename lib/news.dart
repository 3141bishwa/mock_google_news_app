import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


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
    var response = await http.get('http://newsapi.org/v2/top-headlines?country=us&apiKey=7c0325c05d0545168c09765c234efd43');
    setState(() {
      newsList = NewsList.fromList(jsonDecode(response.body)).news;
    });

    }
    
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: FlexFit.loose,
      child: Container(
        child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: newsList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 20.0,
                  child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage('https://i0.wp.com/metro.co.uk/wp-content/uploads/2019/04/SEI_601281802.jpg?quality=90&strip=all&zoom=1&resize=644%2C428&ssl=1'),
                              fit: BoxFit.cover,
                            )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[

                              Text(newsList[index].headline, style: Theme.of(context).textTheme.body2, textAlign: TextAlign.left,),
                              Text(newsList[index].description, style: Theme.of(context).textTheme.body1, textAlign: TextAlign.left,),
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


  News({Key key, @required this.headline, @required this.description, @required this.imageUrl});

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


