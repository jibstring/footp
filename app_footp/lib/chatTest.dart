import 'dart:async';
import 'package:flutter/material.dart'; 
import 'package:app_footp/location.dart';

class ChatTest extends StatefulWidget{
  @override
  _ChatTestState createState() => _ChatTestState();
}

class _ChatTestState extends State<ChatTest> {
  Location location = Location();
  String chatAll = "";

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 2), (v) {
      setState(() {
        location.getCurrentLocation();
        print("wow ${location.latitude} / ${location.longitude}");
      });
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      body:Center(
        child: Text("위도 ${location.latitude} / 경도 ${location.longitude}"),
        ),
    );
  }
}