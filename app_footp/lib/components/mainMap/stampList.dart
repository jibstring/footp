import 'package:app_footp/components/mainMap/footList.dart';
import 'package:app_footp/components/msgFoot/normalFoot.dart';
import 'package:app_footp/components/msgFoot/reportModal.dart';
import 'package:app_footp/createStamp.dart';
import 'package:app_footp/signIn.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  StampDetailInfo stampDetail = Get.put(StampDetailInfo());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadStampList();
    loadJoinStamp();
  }

  @override
  Widget build(BuildContext context) {
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
                    )),

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
                              side: BorderSide(
                                color: Colors.orangeAccent,
                              ),
                            ),
                            elevation: 2.0,
                            child: Container(
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  // 스탬푸 제목
                                  Text(
                                    _stampList[index]['stampboard_title'],
                                  ),
                                  SizedBox(height: 10),

                                  // 스탬푸 시트
                                  GestureDetector(
                                    child: Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(_stampList[index]
                                              ['stampboard_designurl']),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Expanded(
                                                        child: Container(),
                                                        flex: 1,
                                                      ),
                                                      Expanded(
                                                        child: Container(),
                                                        flex: 1,
                                                      ),
                                                      Expanded(
                                                        child: IconButton(
                                                          icon:
                                                              Icon(Icons.close),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        flex: 1,
                                                      )
                                                    ],
                                                  ),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Column(
                                                        children:
                                                            // Container(
                                                            //   height: 200,
                                                            //   decoration:
                                                            //       BoxDecoration(
                                                            //     image:
                                                            //         DecorationImage(
                                                            //       fit: BoxFit.cover,
                                                            //       image: NetworkImage(
                                                            //           _stampList[
                                                            //                   index][
                                                            //               'stampboard_designurl']),
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                            // Container(
                                                            //   child: Text('스탬푸 제목'),
                                                            // ),
                                                            // Container(
                                                            //     decoration:
                                                            //         BoxDecoration(
                                                            //             border: Border
                                                            //                 .all(
                                                            //       width: 1,
                                                            //       color: Colors.black,
                                                            //     )),
                                                            //     child:
                                                            //         Text('스탬푸 내용')),
                                                            List.generate(
                                                                10,
                                                                (index) =>
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              5),
                                                                          color:
                                                                              Colors.orange),
                                                                    ))),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                _stampList[index]
                                                            ["stampboard_id"] !=
                                                        stampDetail.nowStamp[
                                                            "stampboard_id"]
                                                    ? TextButton(
                                                        child: Text('참가하기'),
                                                        onPressed: () {
                                                          joinStamp(index);
                                                        },
                                                      )
                                                    : TextButton(
                                                        child: Text('참가 취소',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red)),
                                                        onPressed: () {
                                                          cancleStamp(index);
                                                        },
                                                      ),
                                                TextButton(
                                                  child: Text('취소'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                  SizedBox(height: 10),

                                  // 스탬푸 버튼 모음
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      PopupMenuButton(
                                        icon: Icon(
                                          Icons.more_horiz,
                                          size: 30,
                                        ),
                                        itemBuilder: (context) => [
                                          PopupMenuItem<int>(
                                            value: 0,
                                            child: TextButton(
                                              child: Text(
                                                '삭제하기',
                                                style: _stampList[index]
                                                            ["user_id"] !=
                                                        user.userinfo["userId"]
                                                    ? null
                                                    : TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15),
                                              ),
                                              onPressed: _stampList[index]
                                                          ["user_id"] !=
                                                      user.userinfo["userId"]
                                                  ? null
                                                  : () {
                                                      deleteStamp(index);
                                                    },
                                            ),
                                          ),
                                          PopupMenuItem<int>(
                                            value: 1,
                                            child: TextButton(
                                                child: Text(
                                                  '신고하기',
                                                  style: _stampList[index]
                                                          ["isMyspam"]
                                                      ? null
                                                      : TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                        ),
                                                ),
                                                onPressed: () {
                                                  if (!user.isLogin()) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SignIn()),
                                                    );
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content:
                                                              Text('신고하시겠습니까?'),
                                                          actions: [
                                                            TextButton(
                                                              child: Text('신고',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                  )),
                                                              onPressed: () {
                                                                reportStamp(
                                                                    index);
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text('취소',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                  )),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                }),
                                          ),
                                        ],
                                      ),

                                      // 참가하기 버튼
                                      _stampList[index]["stampboard_id"] !=
                                              stampDetail
                                                  .nowStamp["stampboard_id"]
                                          ? TextButton(
                                              child: Text('참가하기'),
                                              onPressed: () {
                                                joinStamp(index);
                                              },
                                            )
                                          : TextButton(
                                              child: Text('참가 취소',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              onPressed: () {
                                                cancleStamp(index);
                                              },
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

  // 스탬프 좋아요
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

  // 스탬프 삭제
  void deleteStamp(int index) async {
    var dio = DIO.Dio();

    var url =
        'http://k7a108.p.ssafy.io:8080/stamp/delete/${_stampList[index]["user_id"]}/${_stampList[index]["stampboard_id"]}';
    var response = await dio.delete(
        'http://k7a108.p.ssafy.io:8080/stamp/delete/${_stampList[index]["user_id"]}/${_stampList[index]["stampboard_id"]}');
    if (_selectedValue == '좋아요') {
      loadStampLike();
    } else {
      loadStampList();
    }
    Navigator.pop(context);
  }

  // 스탬프 신고하기
  void reportStamp(int index) async {
    var dio = DIO.Dio();
    var userId = user.userinfo["userId"];

    if (userId == _stampList[index]["user_id"]) {
      Fluttertoast.showToast(
          msg: '자신의 스탬푸는 신고할 수 없습니다.',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.orangeAccent,
          fontSize: 20.0,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    } else if (_stampList[index]["isMyspam"]) {
      Fluttertoast.showToast(
          msg: '이미 신고한 스탬푸입니다.',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.redAccent,
          fontSize: 20.0,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    } else {
      await dio.post(
          'http://k7a108.p.ssafy.io:8080/stamp/spam/$userId/${_stampList[index]["stampboard_id"]}');
      Fluttertoast.showToast(
          msg: '신고가 완료되었습니다.',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.lightGreenAccent,
          fontSize: 20.0,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      _stampList[index]["isMyspam"] = true;
    }
  }

  // 스탬푸 참가하기
  void joinStamp(int index) async {
    var dio = DIO.Dio();
    var userId = user.userinfo["userId"];
    var stampboardId = _stampList[index]["stampboard_id"];

    if (stampDetail.nowStamp["stampboard_id"] == null) {
      if (user.isLogin()) {
        await dio
            .post(
                'http://k7a108.p.ssafy.io:8080/stamp/join/$userId/$stampboardId')
            .then((res) {
          stampDetail.nowStamp = res.data;
        }).then((res) {
          Fluttertoast.showToast(
              msg: '새로운 스탬푸를 시작했습니다.',
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.lightGreenAccent,
              fontSize: 20.0,
              textColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT);
        }).catchError((e) {
          print(e);
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      }
    } else {
      if (user.isLogin()) {
        Fluttertoast.showToast(
            msg: '참가 중인 스탬푸가 있습니다.',
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.orangeAccent,
            fontSize: 20.0,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      }
    }
  }

  // 스탬푸 참가 취소하기
  void cancleStamp(int index) async {
    var dio = DIO.Dio();
    var userId = user.userinfo["userId"];
    await dio
        .delete('http://k7a108.p.ssafy.io:8080/stamp/leave/$userId')
        .then((res) {
      stampDetail.nowStamp = {};
    }).then((res) {
      Fluttertoast.showToast(
          msg: '스탬푸 참가를 취소하였습니다.',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.redAccent,
          fontSize: 20.0,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    });
  }

  // 현재 참가 중인 스탬푸 조회하기
  void loadJoinStamp() async {
    var dio = DIO.Dio();

    if (user.isLogin()) {
      var response = await dio.get(
          'http://k7a108.p.ssafy.io:8080/stamp/joinList/${user.userinfo["userId"]}');
      stampDetail.nowStamp = response.data;
      print("################################################");
      print(stampDetail.nowStamp);
      print('#############################################');
    }
  }
}
