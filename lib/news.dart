import 'package:flutter/material.dart';

class News {
  final String headline;
  final String imageUrl;
  final String description;
  final String source;
  final String webPageUrl;
  final String publishedDate;

  News(
      {Key key,
      @required this.headline,
      @required this.description,
      @required this.imageUrl,
      @required this.source,
      @required this.webPageUrl,
      @required this.publishedDate});

  News.fromJson(Map<String, dynamic> newsJson)
      : headline = newsJson['title'],
        description = newsJson['description'],
        imageUrl = newsJson['urlToImage'],
        source = newsJson['source']['name'],
        webPageUrl = newsJson['url'],
        publishedDate = newsJson['publishedAt'];
}

class NewsList {
  List<News> news;

  NewsList({Key key, @required this.news});

  NewsList.fromList(Map<String, dynamic> jsonResponse)
      : news = List.from(jsonResponse['articles']).map((news) {
          if (news['title'] != null &&
              news['description'] != null &&
              news['urlToImage'] != null &&
              news['source']['name'] != null) {
            return News.fromJson(news);
          } else {
            return null;
          }
        }).toList();
}
