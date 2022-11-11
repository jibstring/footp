import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import 'package:app_footp/components/msgFoot/eventFoot.dart';
import 'package:app_footp/components/msgFoot/normalFoot.dart';
import 'package:app_footp/mainMap.dart' as mainmap;

mainmap.MainData maindata = mainmap.maindata;
ListMaker listmaker = Get.put(ListMaker());

class ListMaker extends GetxController {
  int _messagelen = 0;
  Map<String, dynamic> _jsonData = {};
  List<dynamic> _footData = [];
  // DraggableScrollableController _listcontroller =
  //     DraggableScrollableController();

  int get messagelen => _messagelen;
  Map<String, dynamic> get jsonData => _jsonData;
  List<dynamic> get footData => _footData;
  // DraggableScrollableController get listcontroller => _listcontroller;

  void readFile() {
    //서버 통신으로 받아온 메시지 파싱
    try {
      _jsonData = maindata.dataList;
    } catch (e) {
      _jsonData = {};
    }

    try {
      _messagelen = jsonData["message"].length;
    } catch (e) {
      _messagelen = 0;
    }

    for (int i = 0; i < messagelen; i++) {
      if (footData.length <= i) {
        footData.add(jsonData["message"][i]);
      } else {
        footData[i] = jsonData["message"][i];
      }
    }
  }

  void refresh() {
    maindata.getMapEdge();
    readFile();
  }
}

class FootList extends StatefulWidget {
  const FootList({super.key});

  State<FootList> createState() => _FootListState();
}

class _FootListState extends State<FootList> {
  int _selectedIndex = 0;
  final _valueList = ['HOT', '좋아요', 'NEW', 'EVENT'];
  final _filterList = ['hot', 'like', 'new'];
  var _selectedValue = "hot";

  Widget build(BuildContext context) {
    listmaker.readFile();
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 1,
      snap: true,
      // controller: listmaker.listcontroller,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            color: Colors.white,
            child: ListView.builder(
                controller: scrollController,
                itemCount: listmaker.messagelen + 2,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Container(
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
                            onPressed: listmaker.refresh,
                          ),
                          IconButton(
                            // 검색
                            onPressed: () {},
                            icon: Icon(Icons.search, size: 40),
                          ),
                        ],
                      ),
                    );
                  } else if (index > listmaker.messagelen) {
                    return Container(color: Colors.white, height: 60);
                  } else {
                    return NormalFoot(listmaker.footData[index - 1]);
                    // footData[index]["check"] == 0
                    //     ? EventFoot(footData[index])
                    //     : NormalFoot(footData[index]);
                  }
                }));
      },
    );
  }

  void initState() {
    listmaker.readFile();
    super.initState();
    Timer.periodic(Duration(seconds: 2), (v) {
      if (mounted) {
        setState(() {
          listmaker.readFile();
        });
      }
    });
  }
}
