
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


const footAPIURL='https://';

class FootList extends StatefulWidget{
  const FootList({super.key});

  State<FootList> createState()=> _FootListState();
}

class _FootListState extends State<FootList> {

  int _selectedIndex = 0;
  final _valueList=['HOT','좋아요','NEW','EVENT'];
  var _selectedValue="HOT";

  String jsonString='''
{
        "eventId" : 2013,
        "userNickname" : "역사박물관관장",
        "eventText" : "오늘 10시까지 역사퀴즈 이벤트 진행합니다 다들 많관부", 
        "eventFileurl" : "s3",
        "eventWritedate" : "2022-10-27 15:34",
        "eventFinishdate" : "2022-10-28 10:34",
        "eventLikenum" : 12,
        "eventSpamnum" : 0,
        "isQuiz" : true,
        "isMylike": true,
        "eventQuestion" : "숭례문은 국보 몇 호 일까요?(숫자만)",
        "eventAnswer" : "1",
        "eventExplain" : "숭례문은 국보 1호였습니다. 안내데스크에서 사탕 받아가세요!",
        "eventExplainurl" : "imgs/orange_print.png",
        "isSolvedByMe": false
        }
  ''';
  Map<String,dynamic>jsonData={};

  void readFile(){
    jsonData=jsonDecode(jsonString);
    print(jsonData);
  }
    
  Widget build(BuildContext context){
    double width=MediaQuery.of(context).size.width* 0.7; 
    readFile();
    return DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 1,
        snap: true,
        snapSizes: [0.65],
        builder: (BuildContext context, ScrollController scrollController) {
          return Column(
            
      children:<Widget>[
        Container(
          color:Colors.blue[100],
          height: 50,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:<Widget> [
              DropdownButton(
                value:_selectedValue,
                items: _valueList.map(
                (value){
                  return DropdownMenuItem(
                    value:value,
                    child:Text(value)
                  );
                },
              ).toList(),
              onChanged: (value){
                setState((){
                  _selectedValue=value!;
                });
              },
            ),
            IconButton(//새로고침
            icon: Icon(
              Icons.refresh,
              //color: Color.fromARGB(255, 228, 229, 160),
              size: 40,
            ),
            // padding: EdgeInsets.fromLTRB(0, 0, 50, 300),
            onPressed: () {
              readFile();
            },
          ),
              IconButton(//검색
                onPressed:(){},
                icon: Icon(Icons.search,size:40),
                ),
                

            ],

      ),
        ), 
          Container(
            padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
            color: Colors.white,
            height:MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            child: ListView.builder(
              controller: scrollController,
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child:Column(
                    children: [
                      SizedBox(
                        height:10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              jsonData["userNickname"],
                              style:const TextStyle(
                                fontSize:15,
                                fontWeight:FontWeight.bold,
                                color:Colors.grey),
                                ),
                          Text(
                              jsonData["eventWritedate"],
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
                          child:Image.asset(jsonData["eventExplainurl"])
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          width:width,
                          child:Text(
                            jsonData["eventText"],//100자로 제한
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
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
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
                                jsonData["eventLikenum"].toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              )
                            ]),
                        )

                      ],)
                    ],
                  )
                
                  );

              },
            ),
          ),
      ]
          );
        },
      );

  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
}