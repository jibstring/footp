import 'package:app_footp/createStamp.dart';
import 'package:app_footp/signUp.dart';
import 'package:app_footp/signIn.dart';
import 'package:flutter/material.dart';
import 'package:app_footp/mainMap.dart';
import 'package:get/get.dart';

import 'notice.dart' as notice;
import 'notice.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  Notice mainNotice = notice.notice;
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'footp'),
      debugShowCheckedModeBanner: false,
      home: MainMap(),
    );
  }
}
