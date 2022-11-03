import 'package:flutter/material.dart';
import 'dart:convert';

class NormalFoot extends StatelessWidget {
  Map<String,dynamic> normalmsg;
  NormalFoot(this.normalmsg,{Key? key}):super(key:key);

  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width* 0.62; 
    return Card(
                  child:Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        SizedBox(
                          height:10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                normalmsg["userNickname"],
                                style:const TextStyle(
                                  fontSize:15,
                                  fontWeight:FontWeight.bold,
                                  color:Colors.grey),
                                  ),
                            Text(
                                normalmsg["messageWritedate"],
                                style:const TextStyle(
                                  fontSize:15,
                                  fontWeight:FontWeight.bold,
                                  color:Colors.grey),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height:10,
                        ),
                        Row(children: [
                          SizedBox(
                            width:100,
                            height:100,
                            child:((){
                              if(normalmsg["messageFileurl"]!=null){
                                Image.asset(normalmsg["messageFileurl"]);
                              }})(),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            width: width,
                            child:Text(
                              normalmsg["messageText"],//100자로 제한
                              style:const TextStyle(
                                fontSize:15,
                                fontWeight:FontWeight.bold,
                                color:Colors.grey),
                                )
                          )
                        ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          IconButton(//검색
                            onPressed:(){},
                            icon: Icon(Icons.more_horiz,size:30),
                            ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                            child: Row(                          
                              children: [
                                IconButton(//검색
                                  onPressed:(){},
                                  icon: Icon(
                                    Icons.favorite,
                                    color:Color.fromARGB(255, 250, 31, 31),
                                    size:30),
                                ),
                                Text(
                                  normalmsg["messageLikenum"].toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                )
                              ]),
                          )

                        ],)
                      ],
                    ),
                  )
                
                  );
  }
}