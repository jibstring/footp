import 'package:flutter/material.dart';
import 'package:my_app/mainMap.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget{
  const MyApp({ Key? key}):super (key:key);

  Widget build(BuildContext context){
    return MaterialApp(
      home:mainMap(),
    );
  }
}