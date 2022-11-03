
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_footp/components/msgFoot/eventFoot.dart';
import 'package:app_footp/components/msgFoot/normalFoot.dart';


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
       "event": [
	      {
        "eventId" : 2013,
        "userNickname" : "역사박물관관장",
        "eventText" : "오늘 10시까지 역사퀴즈 이벤트 진행합니다 다들 많관부",
        "eventFileurl" : "imgs/orange_print.png",
        "eventWritedate" : "2022-10-27 15:34",
        "eventFinishdate" : "2022-10-28 10:34",
        "eventLongitude": 127.0378592,
	      "eventLatitude" : 37.5013365,
        "eventLikenum" : 12,
        "eventSpamnum" : 0,
        "isQuiz" : true,
        "isMylike": true,
        "eventQuestion" : "숭례문은 국보 몇 호 일까요?(숫자만)",
        "eventAnswer" : "1",
        "eventExplain" : "숭례문은 국보 1호였습니다. 안내데스크에서 사탕 받아가세요!",
        "eventExplainurl" : "https://ldb-phinf.pstatic.net/20150901_60/1441045635833GhE61_JPEG/13491509_0.jpg",
        "isSolvedByMe":false
        },
        {
        "eventId" : 182,
        "userNickname" : "역삼투썸",
        "eventText" : "퇴근 전에 커피한잔 어떠세요?",
        "eventFileurl" : "imgs/blue_print.png",
        "eventWritedate" : "2022-11-01 11:00",
        "eventFinishdate" : "2022-11-02 17:00",
        "eventLongitude": 127.04034467847467,
	      "eventLatitude" : 37.49991991765725,
        "eventLikenum" : 4,
        "eventSpamnum" : 0,
        "isQuiz" : true,
        "isMylike": true,
        "eventQuestion" : "숭례문은 국보 몇 호 일까요?(숫자만)",
        "eventAnswer" : "1",
        "eventExplain" : "숭례문은 국보 1호였습니다. 안내데스크에서 사탕 받아가세요!",
        "eventExplainurl" : "https://ldb-phinf.pstatic.net/20150901_60/1441045635833GhE61_JPEG/13491509_0.jpg",
        "isSolvedByMe":true
        }
        ],
        "message": [
        {
        "messageId" : 234,
        "userNickname" : "산책좋아 강아지",
        "messageText" : "숭례문 광장 산책하기 좋네",
        "messageFileurl" : "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/26f8915a-0f71-4b1a-9c90-3afdf5ca7340/IMG_2543.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20221027%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20221027T040454Z&X-Amz-Expires=86400&X-Amz-Signature=af647a88e5be6e55610eb47b19a2d5dcadaf345afde02e07828412304a08ee4b&X-Amz-SignedHeaders=host&response-content-disposition=filename%3D%22IMG_2543.JPG.jpg%22&x-id=GetObject",        "messageLongitude": 127.0397679,
	      "messageLongitude":127.0419788,
        "messageLatitude": 37.5012424,
        "isOpentoall" : true,
        "isMylike": false,
        "messageLikenum" : 10,
        "messageSpamnum" : 0,
        "messageWritedate" :"2022-10-27 14:29"
        },
        {
        "messageId" : 7382,
        "userNickname" : "아이스크림러버",
        "messageText" : "여기 자몽 아이스크림 존맛",
        "messageFileurl" : null,
        "messageLongitude": 127.0399788,
	      "messageLatitude":37.5019121,
        "isOpentoall" : true,
        "isMylike": true,
        "messageLikenum" : 8,
        "messageSpamnum" : 0,
        "messageWritedate" :"2022-10-25 18:08"
        }
        ]
        }
  ''';



  Map<String,dynamic>jsonData={};
  List <dynamic>footData=[];
  int eventlen=0;
  int messagelen=0;

///서버 통신으로 받아온 메시지 파싱
  void readFile(){
    jsonData=jsonDecode(jsonString);
    print(jsonData);

    eventlen=jsonData["event"].length;
    messagelen=jsonData["message"].length;

    for(int i=0;i<eventlen;i++){
      jsonData["event"][i]["check"]=0; //이걸로 어떤 메시지인지 파악
      footData.add(jsonData["event"][i]);
    }
    for(int i=0;i<messagelen;i++){
      jsonData["message"][i]["check"]=1;
      footData.add(jsonData["message"][i]);
    }
  }

  Widget build(BuildContext context){
    double width=MediaQuery.of(context).size.width* 0.62; 
    readFile();
    return DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 1,
        snap: true,
        snapSizes: [0.65],
        builder: (BuildContext context, ScrollController scrollController) {
          return Expanded(
            //height:double.infinity,
            child:
            Column(
              children:<Widget>[
                //상단바 
                Container(
                  color:Colors.white,
                  height: 50,
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:<Widget> [
                      //필터
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
                      //새로고침
                      IconButton(
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
                //메시지 목록들 
                Container(
                  color:Colors.white,
                  padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                  height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top-302,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: eventlen+messagelen,
                    itemBuilder: (BuildContext context, int index) {
                      return (footData[index]["check"]==0)? EventFoot(footData[index]) :NormalFoot(footData[index]);
                    },
                  ),
                ),
              ]
            ),
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