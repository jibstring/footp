import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:app_footp/components/msgFoot/normalFoot.dart';
import 'package:app_footp/mainMap.dart' as mainmap;

mainmap.MainData maindata = mainmap.maindata;
ListMaker listmaker = Get.put(ListMaker());

class ListMaker extends GetxController {
  int _messagelen = 0;
  bool _music_on = false;
  Map<String, dynamic> _jsonData = {};
  List<dynamic> _footData = [];
  DraggableScrollableController _listcontroller =
      DraggableScrollableController();

  int get messagelen => _messagelen;
  bool get music_on => _music_on;
  Map<String, dynamic> get jsonData => _jsonData;
  List<dynamic> get footData => _footData;
  DraggableScrollableController get listcontroller => _listcontroller;

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
    // print(footData);
  }

  void refresh() {
    maindata.getMapEdge();
    readFile();
  }

  set musicCheck(bool check) {
    _music_on = check;
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
  bool _searchClick = false;
  TextEditingController searchController = TextEditingController();

  Widget build(BuildContext context) {
    listmaker.readFile();
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 1,
      snap: true,
      controller: listmaker.listcontroller,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            color: Colors.white,
            child: ListView.builder(
                controller: scrollController,
                itemCount: listmaker.messagelen + 2,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return maindata.searchFlag == false
                        ? Container(
                            color: Colors.white,
                            height: 50,
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                // 필터
                                DropdownButton(
                                  icon: Image.asset("./imgs/화살표_o.png",
                                    width: 40,
                                    height:40,
                                  ),
                                  value: _selectedValue,
                                  items: _filterList.map(
                                    (value) {
                                      return DropdownMenuItem(
                                          value: value, child: Text(value,style:TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)));
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
                                 icon: Image.asset("./imgs/새로고침_r.png",width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  onPressed: listmaker.refresh,
                                ),
                                IconButton(
                                  // 검색창 띄기
                                  onPressed: () {
                                    setState(() {
                                      maindata.setSearchFlag = true;
                                      maindata.setListClean = true;
                                    });
                                  },
                                  icon: Image.asset("./imgs/검색_b.png",width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            child: Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
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
                                      maindata.setSearchFlag = true;
                                      maindata.setSearchKeyword =
                                          searchController.text;
                                    });
                                  },
                                  icon: Image.asset("./imgs/검색_b.png",width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                IconButton(
                                  // 취소
                                  onPressed: () {
                                    setState(() {
                                      maindata.setSearchFlag = false;
                                    });
                                  },
                                  icon: Icon(Icons.close, size: 30),
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
    Timer.periodic(Duration(seconds: 5), (v) {
      if (mounted) {
        setState(() {
          listmaker.readFile();
        });
      }
    });
  }
}
