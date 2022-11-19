import 'dart:async';
import 'dart:convert';

import 'package:app_footp/components/msgFoot/eventFoot.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:app_footp/mainMap.dart' as mainmap;
import 'package:app_footp/components/mainMap/chatRoom.dart';

mainmap.MainData maindata = mainmap.maindata;

class ListMaker extends GetxController {}

class gatherList extends StatefulWidget {
  const gatherList({super.key});

  State<gatherList> createState() => _gatherListState();
}

class _gatherListState extends State<gatherList> {
  int _selectedIndex = 0;
  final _valueList = ['HOT', '좋아요', 'NEW', 'EVENT'];
  final _filterList = ['hot', 'like', 'new'];
  var _selectedValue = "hot";
  int clickCategory=0;
  List<String> category=['전체','공연','행사','맛집','관광','친목'];
  List<Color> colorSelect=[Color.fromARGB(255, 190, 212, 255),Color.fromARGB(255, 190, 223, 178),Color.fromARGB(255, 255, 234, 246),Color.fromARGB(255, 155, 169, 99),Color.fromARGB(255, 182, 114, 205),Color.fromARGB(255, 252, 169, 45),Color.fromARGB(255, 20, 98, 186)];

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
  bool _searchClick = false;
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
    // print("gather이야아아아아ㅏ아아아");
    // print(_gatherlen);
  }

  void refresh() {
    maindata.getMapEdge();
    readFile();
  }

  set musicCheck(bool check) {
    _music_on = check;
  }

  Widget build(BuildContext context) {
    if (maindata.attendChat) {
      return maindata.chatRoom;
    }
    readFile();
    return DraggableScrollableSheet(
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
                itemCount: gatherlen + 3,
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
                                            fontSize: 20,
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
                                  onPressed: refresh,
                                ),
                                IconButton(
                                  // 검색
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
                  }
                  else if(index==1){
                    return Container(
                      color:Colors.white,
                        height: 65,
                         padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                        
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: category.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                SizedBox(width: 8,),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 3),
                                    borderRadius: BorderRadius.circular(20),
                                    ), 
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                       //테두리
                                      foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      backgroundColor:
                                        MaterialStateProperty.all<Color>(clickCategory==index?
                                          colorSelect[index]:Colors.white),
                                      shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                            BorderRadius.circular(20.0),
                                        )),
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        clickCategory=index;
                                      });
                                    },
                                    child: Text("# ${category[index]}",style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                                  ),
                                ),
                              ],
                            );
                          }
                        )
                      );
                  } 
                  else if (index > gatherlen+1) {
                    return Container(color: Colors.white, height: 60);
                  } else {
                    return EventFoot(gatherData[index - 2]);
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
