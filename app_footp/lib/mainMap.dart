import 'package:flutter/material.dart';
import 'package:app_footp/createFoot.dart';

class mainMap extends StatelessWidget{
  const mainMap({Key? key}):super(key:key);

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Image.asset('imgs/logo.png',height:35),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions:<Widget>[
          IconButton(
            icon:Icon(
              Icons.account_circle,
              color:Color.fromARGB(255, 134, 164, 223),
            ),
            onPressed:(){},
           ),
        ],
      ),
      body :Center(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child:Text(""),
              onPressed:(){
                Navigator.push(context,MaterialPageRoute(builder:(context)=>createFoot()),
                );
              },
              style:ElevatedButton.styleFrom(
                primary:Colors.red
              )),
          ]),
        ),
    );
  }

}