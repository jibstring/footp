import 'package:app_footp/createStamp.dart';
import 'package:app_footp/notice.dart';
import 'package:app_footp/signUp.dart';
import 'package:app_footp/signIn.dart';
import 'package:flutter/material.dart';
import 'package:app_footp/mainMap.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  Notice notice = Notice();
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMap(),
    );
  }
}
