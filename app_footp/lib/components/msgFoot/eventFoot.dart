import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:app_footp/components/msgFoot/reportModal.dart';
import 'package:http/http.dart' as http;

const serverUrl='http://k7a108.p.ssafy.io:8080/foot';

class EventFoot extends StatefulWidget {
  Map<String,dynamic> eventmsg;
  EventFoot(this.eventmsg,{Key? key}):super(key:key);
  

  @override
  State<EventFoot> createState() => _EventFootState();
}

class _EventFootState extends State<EventFoot> {
  @override
  int userId=123;
  int heartnum=0;
  List <String>heartList=[
    "imgs/heart_empty.png",
    "imgs/heart_color.png"
  ];

  void heartChange(){
    setState(() {
      if(heartnum==0){
        heartnum=1;
        widget.eventmsg["isMylike"]=true;
        widget.eventmsg["eventLikenum"]=widget.eventmsg["eventLikenum"]+1;
        updateEventHeart(userId.toString());
      }
      else{
        heartnum=0;
        widget.eventmsg["isMylike"]=false;
        widget.eventmsg["eventLikenum"]=widget.eventmsg["eventLikenum"]-1;
        updateEventHeart("");
      }

    });
  }
  void updateEventHeart(String who) async{
    final uri=Uri.parse(serverUrl+'/like/'+widget.eventmsg["eventId"].toString()+"/"+who);
    http.Response response=await http.post(
      uri
    );
    print(uri);

    if(response.statusCode==200){
      var decodedData=jsonDecode(response.body);
      print(decodedData);
    }
    else{
      print('하트업데이트 실패패패패패패ㅐ퍂');
      print(response.statusCode);

      throw 'sendReport() error';
    }
  }

  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width* 0.62; 
    widget.eventmsg["isMylike"]? heartnum=1:heartnum=0;
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
                                widget.eventmsg["userNickname"],
                                style:const TextStyle(
                                  fontSize:15,
                                  fontWeight:FontWeight.bold,
                                  color:Colors.grey),
                                  ),
                            Text(
                                widget.eventmsg["eventWritedate"],
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
                          child:(widget.eventmsg["eventFileurl"]!=null)?
                          Row(children: 
                          [
                            SizedBox(
                              width:100,
                              height:100,
                              child:Image.asset(widget.eventmsg["eventFileurl"])
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              width: width,
                              child:Text(
                                widget.eventmsg["eventText"],//100자로 제한
                                style:const TextStyle(
                                  fontSize:15,
                                  fontWeight:FontWeight.bold,
                                  color:Colors.grey),
                                  )
                            )
                          ],
                          ):
                          Text(
                                widget.eventmsg["eventText"],//100자로 제한
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
                            onPressed:(){
                              showDialog(context: context, builder: (context){
                                return ReportModal(widget.eventmsg["eventId"],userId);
                              });
                            },
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
                                backgroundColor: (widget.eventmsg["isSolvedByMe"]) ? Colors.blue[100]:Colors.blue[400]
                              ),
                                onPressed: () {

                                },
                                child:(widget.eventmsg["isSolvedByMe"]) ? const Text('결과보기') :const Text('퀴즈풀기')
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
                                InkWell(
                                  child:
                                  Image.asset(heartList[heartnum],
                                  width: 30,
                                  height: 30,),
            
                                  onTap:(){
                                      heartChange();
                                  }
                                ), 
                                SizedBox(width:10),
                                SizedBox(
                                  width: 30,
                                  //height:30,
                                  child: Text(
                                    widget.eventmsg["eventLikenum"].toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
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
