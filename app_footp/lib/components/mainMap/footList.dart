import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:app_footp/components/msgFoot/eventFoot.dart';
import 'package:app_footp/components/msgFoot/normalFoot.dart';

import 'package:get/get.dart';
import 'package:app_footp/mainMap.dart' as mainmap;

mainmap.MainData maindata = mainmap.maindata;

class FootList extends StatefulWidget {
  const FootList({super.key});

  State<FootList> createState() => _FootListState();
}

class _FootListState extends State<FootList> {
  int _selectedIndex = 0;
  final _valueList = ['HOT', '좋아요', 'NEW', 'EVENT'];
  var _selectedValue = "HOT";

  Map<String, dynamic> jsonData = {};
  List<dynamic> footData = [];
  int eventlen = 0;
  int messagelen = 0;

  ///서버 통신으로 받아온 메시지 파싱
  void readFile() {
    try{
      jsonData = maindata.dataList;
    }
    catch(e){
      jsonData={};    
    }
    print(jsonData);

    try{
      eventlen = jsonData["event"].length;
    }
    catch(e){
      eventlen=0;
    }

    try{
      messagelen = jsonData["message"].length;
    }
    catch(e){
      messagelen=0;
    }

    for (int i = 0; i < eventlen; i++) {
      jsonData["event"][i]["check"] = 0; //이걸로 어떤 메시지인지 파악
      footData.add(jsonData["event"][i]);
    }
    for (int i = 0; i < messagelen; i++) {
      jsonData["message"][i]["check"] = 1;
      footData.add(jsonData["message"][i]);
    }
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.62;
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
          child: Column(children: <Widget>[
            //상단바
            Container(
              color: Colors.white,
              height: 50,
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //필터
                  DropdownButton(
                    value: _selectedValue,
                    items: _valueList.map(
                      (value) {
                        return DropdownMenuItem(
                            value: value, child: Text(value));
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
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
                  IconButton(
                    //검색
                    onPressed: () {},
                    icon: Icon(Icons.search, size: 40),
                  ),
                ],
              ),
            ),
            //메시지 목록들
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  302,
              child: ListView.builder(
                controller: scrollController,
                itemCount: eventlen + messagelen,
                itemBuilder: (BuildContext context, int index) {
                  return (footData[index]["check"] == 0)
                      ? EventFoot(footData[index])
                      : NormalFoot(footData[index]);
                },
              ),
            ),
          ]),
        );
      },
    );
  }

  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 2), (v) {
      setState(() {
        readFile();
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
