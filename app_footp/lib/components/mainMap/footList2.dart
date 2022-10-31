
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


const footAPIURL='https://';

// class EventFoot{
//   int eventId;
//   String userNickname;
//   String eventText;
//   String eventFileurl;
//   String eventWritedate;
//   String eventFinishdate;
//   //eventPoint;
//   int eventLikenum;
//   int eventSpamnum;
//   bool isQuiz;
//   bool isMylike;
//   String eventQuestion;
//   String eventAnswer;
//   String eventExplain;
//   String eventExplainurl;
//   bool isSolvedByMe;

//   EventFoot({
//     required this.eventId,
//     required this.userNickname,
//     required this.eventText,
//     required this.eventFileurl,
//     required this.eventWritedate,
//     required this.eventFinishdate,
//     //eventPoint,
//     required this.eventLikenum,
//     required this.eventSpamnum,
//     required this.isQuiz,
//     required this.isMylike,
//     required this.eventQuestion,
//     required this.eventAnswer,
//     required this.eventExplain,
//     required this.eventExplainurl,
//     required this.isSolvedByMe,
//   });

//   Map<String,dynamic> toJson(){
//     return{
//       'eventId':this.eventId,
//     'userNickname':this.userNickname,
//     'eventText':this.eventText,
//     'eventFileurl':this.eventFileurl,
//     'eventWritedate':this.eventWritedate,
//     'eventFinishdate':this.eventFinishdate,
//     //eventPoint,
//     'eventLikenum':this.eventLikenum,
//     'eventSpamnum':this.eventSpamnum,
//     'isQuiz':this.isQuiz,
//     'isMylike':this.isMylike,
//     'eventQuestion':this.eventQuestion,
//     'eventAnswer':this.eventAnswer,
//     'eventExplain':this.eventExplain,
//     'eventExplainurl':this.eventExplainurl,
//     'isSolvedByMe':this.isSolvedByMe,
//     };
//   }

//   factory EventFoot.fromJson(Map<String,dynamic> jsonData){
//     return EventFoot(
//       eventId:jsonData['eventId'] as int,
//       userNickname:jsonData['userNickname'],
//       eventText:jsonData['eventText'],
//       eventFileurl:jsonData['eventFileurl'],
//       eventWritedate:jsonData['eventWritedate'],
//       eventFinishdate:jsonData['eventFinishdate'],
//   //eventPoint,
//       eventLikenum:jsonData['eventLikenum'],
//       eventSpamnum:jsonData['eventSpamnum'],
//       isQuiz:jsonData['isQuiz'],
//       isMylike:jsonData['isMylike'],
//       eventQuestion:jsonData['eventQuestion'],
//       eventAnswer:jsonData['eventAnswer'],
//       eventExplain:jsonData['eventExplain'],
//       eventExplainurl:jsonData['eventExplainurl'],
//       isSolvedByMe:jsonData['isSolvedByMe'],
//     );
//   }
// }

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
        "eventExplainurl" : "https://ldb-phinf.pstatic.net/20150901_60/1441045635833GhE61_JPEG/13491509_0.jpg",
        "isSolvedByMe": false
        }
  ''';

  void readFile(){
    Map<String,dynamic>jsonData=jsonDecode(jsonString);
    print(jsonData);
  }
    
  Widget build(BuildContext context){
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
                icon: Icon(Icons.search,size:50)
                ),

            ],

      ),
        ), 
          Container(
            color: Colors.blue[100],
            height:MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            child: ListView.builder(
              controller: scrollController,
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        children: [
                        Row(
                          children: [
                            Align(
                              alignment :Alignment.centerLeft,
                              child: Text('닉넴',style: TextStyle(fontSize: 20),),),
                            Align(
                              alignment :Alignment.centerRight,
                              child: Text('날짜'),)
                          ],
                        ),
                        Text('hello'),
                      ],
                    ),
                  ),

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