import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchText extends StatefulWidget {
  SearchText({Key key}) : super(key: key);

  @override
  _SearchTextState createState() => _SearchTextState();
}

class _SearchTextState extends State<SearchText> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: '');
  }

   @override
  Widget build(BuildContext context) {

    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200.0, vertical: 20.0),
        child: TextField(
          controller: _textController,
          decoration: InputDecoration(
              hintText: 'Search anything',
              contentPadding: const EdgeInsets.all(15.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              )
          ),
        ),
      )
    );
  }

}