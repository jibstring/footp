import 'package:flutter/material.dart';
import 'dart:convert';

class EventFoot extends StatelessWidget {
  Map<String,dynamic> eventmsg;
  EventFoot(this.eventmsg,{Key? key}):super(key:key);

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
                        //닉넴 & 날짜
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                eventmsg["userNickname"],
                                style:const TextStyle(
                                  fontSize:15,
                                  fontWeight:FontWeight.bold,
                                  color:Colors.grey),
                                  ),
                            Text(
                                eventmsg["eventWritedate"],
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
                        //중간
                        Container(
                          child:(eventmsg["eventFileurl"]!=null)?
                          Row(children: 
                          [
                            SizedBox(
                              width:100,
                              height:100,
                              child:Image.asset(eventmsg["eventFileurl"])
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              width: width,
                              child:Text(
                                eventmsg["eventText"],//100자로 제한
                                style:const TextStyle(
                                  fontSize:15,
                                  fontWeight:FontWeight.bold,
                                  color:Colors.grey),
                                  )
                            )
                          ],
                          ):
                          Text(
                                eventmsg["eventText"],//100자로 제한
                                style:const TextStyle(
                                  fontSize:15,
                                  fontWeight:FontWeight.bold,
                                  color:Colors.grey),
                                  )
                        ),
                        //하단
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          //더보기
                          IconButton(
                            onPressed:(){},
                            icon: Icon(Icons.more_horiz,size:30),
                            ),
                          
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                            child: Row(
                              //좋아요                         
                              children: [
                                //랭킹보기 
                                SizedBox(
                                width: 100,
                                child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                backgroundColor: (eventmsg["isSolvedByMe"]) ? Colors.blue[100]:Colors.blue[400]
                              ),
                                onPressed: () { },
                                child:(eventmsg["isSolvedByMe"]) ? const Text('결과보기') :const Text('퀴즈풀기')
                              ),
                            ),
                          Container(
                            alignment: Alignment.centerRight,
                            width:5,
                          ),
                                  TextButton(
                                    onPressed: () {
                                  },
                                  child: Text("랭킹보기"),
                                ),  
                                IconButton(
                                  onPressed:(){},
                                  icon: Icon(
                                    Icons.favorite,
                                    color:Color.fromARGB(255, 250, 31, 31),
                                    size:30),
                                ),
                                Text(
                                  eventmsg["eventLikenum"].toString(),
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