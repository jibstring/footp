import 'dart:async';
import 'dart:convert';

import 'package:app_footp/components/msgFoot/eventFoot.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:app_footp/mainMap.dart' as mainmap;
import 'package:app_footp/components/mainMap/chatRoom.dart';

mainmap.MainData maindata = mainmap.maindata;

class ListMaker extends GetxController {

  
}

class gatherList extends StatefulWidget {
  const gatherList({super.key});
  
  State<gatherList> createState() => _gatherListState();
}

class _gatherListState extends State<gatherList> {
  int _selectedIndex = 0;
  final _valueList = ['HOT', '좋아요', 'NEW', 'EVENT'];
  final _filterList = ['hot', 'like', 'new'];
  var _selectedValue = "hot";

  int _gatherlen = 0;
  bool _music_on = false;
  Map<String, dynamic> _jsonData = {};
  List<dynamic> _gatherData = [];
  DraggableScrollableController _listcontroller =
      DraggableScrollableController();

  int get gatherlen => _gatherlen;
  bool get music_on => _music_on;
  Map<String, dynamic> get jsonData => _jsonData;
  List<dynamic> get gatherData => _gatherData;
  DraggableScrollableController get listcontroller => _listcontroller;
  bool _searchClick=false;
  TextEditingController searchController = TextEditingController();


  void readFile() {
    //서버 통신으로 받아온 메시지 파싱
    try {
      _jsonData = maindata.dataList;
    } catch (e) {
      _jsonData = {};
    }

    try {
      _gatherlen = jsonData["gather"].length;
    } catch (e) {
      _gatherlen = 0;
    }

    for (int i = 0; i < gatherlen; i++) {
      if (gatherData.length <= i) {
        gatherData.add(jsonData["gather"][i]);
      } else {
        gatherData[i] = jsonData["gather"][i];
      }
    }
    print("gather이야아아아아ㅏ아아아");
    print(gatherData);
  }

  void refresh() {
    maindata.getMapEdge();
    readFile();
  }

  set musicCheck(bool check) {
    _music_on = check;
  }

  Widget build(BuildContext context) {
    if(maindata.attendChat) {
      return maindata.chatRoom;
    }
    readFile();
    return
    DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 1,
      snap: true,
      controller: listcontroller,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            color: Colors.white,
            child: ListView.builder(
                controller: scrollController,
                itemCount: gatherlen + 2,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return maindata.searchFlag==false? 
                    Container(
                      color: Colors.white,
                      height: 50,
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // 필터
                          DropdownButton(
                            value: _selectedValue,
                            items: _filterList.map(
                              (value) {
                                return DropdownMenuItem(
                                    value: value, child: Text(value));
                              },
                            ).toList(),
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  _selectedValue = value!;
                                  maindata.fixFilter = _selectedValue;
                                  //=String(_filter:selectedValue);
                                });
                              }
                            },
                          ),
                          // 새로고침
                          IconButton(
                            icon: Icon(
                              Icons.refresh,
                              size: 40,
                            ),
                            onPressed: refresh,
                          ),
                          IconButton(
                            // 검색
                            onPressed: () {
                              setState(() {
                                maindata.setSearchFlag=true;
                                maindata.setListclean=true;
                              });
                            },
                            icon: Icon(Icons.search, size: 40),
                          ),
                        ],
                      ),
                    ):
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: TextField(
                                controller: searchController,
                                // decoration: InputDecoration(
                                //   labelText: '검색',
                                // )
                            ),
                          ),
                          IconButton(
                            // 검색완료
                            onPressed: () {
                              setState(() {
                                maindata.setSearchFlag=true;
                                maindata.setSearchKeyword=searchController.text;
                              });                              
                            },
                            icon: Icon(Icons.search, size: 35),
                          ),
                          IconButton(
                            // 취소
                            onPressed: () {
                              setState(() {
                                maindata.setSearchFlag=false;
                              });                              
                            },
                            icon: Icon(Icons.close, size: 30),
                          ),
                        ],),
                    );
                  } else if (index > gatherlen) {
                    return Container(color: Colors.white, height: 60);
                  } else {
                    return EventFoot(gatherData[index - 1]);
                    
                  }
                }));
      },
    );
  }

  void initState() {
    readFile();
    super.initState();
    Timer.periodic(Duration(seconds: 10), (v) {
      if (mounted) {
        setState(() {
          readFile();
        });
      }
    });
  }
}
