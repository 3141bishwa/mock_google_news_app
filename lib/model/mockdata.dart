import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';


class MockUserData with ChangeNotifier{

  String name;
  String email;
  String imageUrl;

  MockUserData({
    @required this.name, 
    @required this.email, 
    @required this.imageUrl
    })  : assert(name!=null),
          assert(email!=null),
          assert(imageUrl!=null);
}


