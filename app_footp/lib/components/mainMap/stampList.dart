import 'package:app_footp/components/mainMap/footList.dart';
import 'package:app_footp/components/msgFoot/normalFoot.dart';
import 'package:app_footp/createStamp.dart';
import 'package:app_footp/signIn.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as DIO;

class StampList extends StatefulWidget {
  const StampList({super.key});

  @override
  State<StampList> createState() => _StampListState();
}

class _StampListState extends State<StampList> {
  UserData user = Get.put(UserData());
  int _selectedIndex = 0;
  final _valueList = ['NEW', '좋아요'];
  final _filterList = ['NEW', '좋아요'];
  var _selectedValue = "NEW";
  var _stampList = [];
  List<String> heartList = ["imgs/heart_empty.png", "imgs/heart_color.png"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadStampList();
  }

  @override
  Widget build(BuildContext context) {
    //   return DraggableScrollableSheet(
    //     initialChildSize: 0.3,
    //     minChildSize: 0.3,
    //     maxChildSize: 0.9,
    //     snap: true,
    //     builder: (BuildContext context, ScrollController scrollController) {
    //       return Container(
    //           height: 100,
    //           child: TextButton(
    //             onPressed: () {
    //               if (!user.isLogin()) {
    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(builder: (context) => const SignIn()),
    //                 );
    //               } else {
    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                       builder: (context) => const CreateStamp()),
    //                 );
    //               }
    //             },
    //             child: Text('스탬프 작성하기'),
    //           ));
    //     },
    //   );
    // }

    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 1,
      snap: true,
      // controller: listmaker.listcontroller,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
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
                              if (value == '좋아요') {
                                loadStampLike();
                              } else if (value == 'NEW') {
                                loadStampList();
                              } else {}
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
                        onPressed: () {
                          loadStampList();
                        },
                      ),
                      // 새로운 스탬푸 작성
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 40,
                        ),
                        onPressed: () {
                          if (!user.isLogin()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignIn()),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreateStamp()),
                            );
                          }
                        },
                      ),
                      IconButton(
                        // 검색
                        onPressed: () {},
                        icon: Icon(Icons.search, size: 40),
                      ),
                    ],
                  ),
                ),

                // 스탬푸 목록
                Container(
                    child: Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _stampList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 2.0,
                            child: Container(
                              child: Column(
                                children: [
                                  // 스탬푸 제목
                                  Text(
                                    _stampList[index]['stampboard_title'],
                                  ),
                                  SizedBox(height: 10),

                                  // 스탬푸 시트
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(_stampList[index]
                                            ['stampboard_designurl']),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),

                                  // 스탬푸 버튼 모음
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // 신고하기
                                      IconButton(
                                        onPressed: () {
                                          if (!user.isLogin()) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignIn()),
                                            );
                                          } else {
                                            print('신고하기 모달 띄우기');
                                            // showDialog(
                                            //   // context: context,
                                            //   // builder: (context) {
                                            //   //   return ReportModal(
                                            //   //       widget
                                            //   //           .normalmsg["messageId"],
                                            //   //       user.userinfo["userId"]);
                                            //   // },
                                            // );
                                          }
                                        },
                                        icon: Icon(Icons.more_horiz, size: 30),
                                      ),
                                      // 참가하기 버튼
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Text('참가하기'),
                                      ),

                                      // 좋아요
                                      Row(
                                        children: [
                                          InkWell(
                                              child: Image.asset(
                                                heartList[_stampList[index]
                                                            ['isMylike'] ==
                                                        true
                                                    ? 1
                                                    : 0],
                                                width: 30,
                                                height: 30,
                                              ),
                                              onTap: () {
                                                if (!user.isLogin()) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SignIn()),
                                                  );
                                                } else {
                                                  // heartChange();
                                                  stampLike(index);
                                                }
                                              }),
                                          SizedBox(width: 10),
                                          SizedBox(
                                            width: 40,
                                            //height:30,
                                            child: Text(
                                              _stampList[index]
                                                      ['stampboard_likenum']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ));
                    },
                  ),
                )),
              ],
            ));
      },
    );
  }

  // 스탬푸 목록 조회(최신순)
  void loadStampList() async {
    var dio = DIO.Dio();
    int userId = user.isLogin() ? user.userinfo["userId"] : 0;

    var response =
        await dio.get('http://k7a108.p.ssafy.io:8080/stamp/sort/new/$userId');

    print('#################################################');
    print(response);
    print('##########################################################');

    setState(() {
      _stampList = response.data;
    });
  }

  // 스탬푸 목록 조회(좋아요 순)
  void loadStampLike() async {
    var dio = DIO.Dio();
    var response = await dio.get(
        'http://k7a108.p.ssafy.io:8080/stamp/sort/like/${user.userinfo["userId"]}');

    print('#################################################');
    print(response);
    print('##########################################################');

    setState(() {
      _stampList = response.data;
    });
  }

  void stampLike(int index) async {
    var dio = DIO.Dio();

    var response = _stampList[index]["isMylike"]
        ? await dio.delete(
            'http://k7a108.p.ssafy.io:8080/stamp/unlike/${user.userinfo["userId"]}/${_stampList[index]["stampboard_id"]}')
        : await dio.post(
            'http://k7a108.p.ssafy.io:8080/stamp/like/${user.userinfo["userId"]}/${_stampList[index]["stampboard_id"]}');

    print("*****************************************");
    print(response.data);
    print("********************************************");

    setState((() {
      if (_stampList[index]["isMylike"]) {
        _stampList[index]["isMylike"] = false;
        _stampList[index]["stampboard_likenum"] -= 1;
        print("좋아요 취소");
      } else {
        _stampList[index]["isMylike"] = true;
        _stampList[index]["stampboard_likenum"] += 1;
        print("좋아요");
      }
    }));
  }
}
