import 'package:flutter/material.dart';
import 'package:my_app/createFoot.dart';

class mainMap extends StatelessWidget{
  const mainMap({Key? key}):super(key:key);

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text("메인페이지"),
        actions:<Widget>[
          IconButton(
            icon:Icon(
              Icons.add,
              color:Colors.black,
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