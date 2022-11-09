import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:app_footp/components/msgFoot/eventFoot.dart';
import 'package:app_footp/components/msgFoot/normalFoot.dart';
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
    try {
      jsonData = maindata.dataList;
    } catch (e) {
      jsonData = {};
    }

    try {
      eventlen = jsonData["event"].length;
    } catch (e) {
      eventlen = 0;
    }

    try {
      messagelen = jsonData["message"].length;
    } catch (e) {
      messagelen = 0;
    }

    for (int i = 0; i < eventlen; i++) {
      jsonData["event"][i]["check"] = 0; // 이걸로 어떤 메시지인지 파악
      footData.add(jsonData["event"][i]);
    }
    for (int i = 0; i < messagelen; i++) {
      jsonData["message"][i]["check"] = 1;
      footData.add(jsonData["message"][i]);
    }
  }

  Widget build(BuildContext context) {
    readFile();
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 1,
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            color: Colors.white,
            child: ListView.builder(
                controller: scrollController,
                itemCount: eventlen + messagelen + 2,
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
                          // 새로고침
                          IconButton(
                            icon: Icon(
                              Icons.refresh,
                              size: 40,
                            ),
                            onPressed: () {
                              readFile();
                            },
                          ),
                          IconButton(
                            // 검색
                            onPressed: () {},
                            icon: Icon(Icons.search, size: 40),
                          ),
                        ],
                      ),
                    );
                  } else if (index == eventlen + messagelen + 1) {
                    return Container(color: Colors.white, height: 60);
                  } else {
                    return (footData[index]["check"] == 0)
                        ? EventFoot(footData[index])
                        : NormalFoot(footData[index]);
                  }
                }));
      },
    );
  }

  void initState() {
    readFile();
    super.initState();
    Timer.periodic(Duration(seconds: 2), (v) {
      setState(() {
        readFile();
      });
    });
  }
}
