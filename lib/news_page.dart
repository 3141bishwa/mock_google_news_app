import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsPage extends StatelessWidget {

  final String webUrl;

  NewsPage({this.webUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('URL'),
        centerTitle: true,
      ),
      body: WebView(
        javascriptMode: JavascriptMode.disabled,
        initialUrl: webUrl
      ),

    );
  }
}
