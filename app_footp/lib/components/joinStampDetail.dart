import 'dart:math';

import 'package:app_footp/components/msgFoot/normalFoot.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:app_footp/myPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:vector_math/vector_math.dart' as vect;
import 'package:dio/dio.dart' as DIO;

class JoinStampDetail extends StatefulWidget {
  const JoinStampDetail({super.key});

  @override
  State<JoinStampDetail> createState() => _JoinStampDetailState();
}

class _JoinStampDetailState extends State<JoinStampDetail> {
  Map stampDetail = {}; // 참가 중인 stamp
  List stampDetailMessages = [];
  int? selectedStamp;
  MyPosition myPosition = Get.put(MyPosition());
  UserData user = Get.put(UserData());
  // late Future _post;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadJoinStamp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('imgs/로고_기본.png', height: 45),
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
              future: loadJoinStamp(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      // width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(
                              '${stampDetail['stampboard_designurl']}'),
                        ),
                      ),
                      child: Container(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedStamp = 0;
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      selectedStamp == 0 ||
                                              stampDetail[
                                                      'userjoinedStampboard_cleardate1'] !=
                                                  null
                                          ? Image.asset('imgs/blue_print.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2)
                                          : Image.asset('imgs/white_print.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2),
                                      stampDetail['userjoinedStampboard_cleardate1'] !=
                                              null
                                          ? Image.asset('imgs/스탬푸도장.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2)
                                          : Text('')
                                    ],
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedStamp = 1;
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      selectedStamp == 1 ||
                                              stampDetail[
                                                      'userjoinedStampboard_cleardate2'] !=
                                                  null
                                          ? Image.asset('imgs/gray_print.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2)
                                          : Image.asset('imgs/white_print.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2),
                                      stampDetail['userjoinedStampboard_cleardate2'] !=
                                              null
                                          ? Image.asset('imgs/스탬푸도장.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2)
                                          : Text('')
                                    ],
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedStamp = 2;
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      selectedStamp == 2 ||
                                              stampDetail[
                                                      'userjoinedStampboard_cleardate3'] !=
                                                  null
                                          ? Image.asset('imgs/orange_print.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2)
                                          : Image.asset('imgs/white_print.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2),
                                      stampDetail['userjoinedStampboard_cleardate3'] !=
                                              null
                                          ? Image.asset('imgs/스탬푸도장.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2)
                                          : Text('')
                                    ],
                                  )),
                            ],
                          )),
                    ),
                    stampDetailMessages.length > 0
                        ? Column(
                            children: [
                              SizedBox(height: 10),
                              NormalFoot(stampDetailMessages[0]),
                              SizedBox(height: 10),
                              NormalFoot(stampDetailMessages[1]),
                              SizedBox(height: 10),
                              NormalFoot(stampDetailMessages[2]),
                              SizedBox(height: 70),
                            ],
                          )
                        : Container()
                  ],
                );
              })),
      bottomSheet: Container(
        height: 70,
        color: Color.fromARGB(255, 255, 253, 241),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: isNearMessage(selectedStamp) &&
                        stampDetail[
                                'userjoinedStampboard_cleardate${selectedStamp! + 1}'] ==
                            null
                    ? MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 146, 221, 140))
                    : MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 164, 185, 237)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                            width: 3, color: Colors.black) // border line color
                        )),
              ),
              onPressed: isNearMessage(selectedStamp) &&
                      stampDetail[
                              'userjoinedStampboard_cleardate${selectedStamp! + 1}'] ==
                          null
                  ? () {
                      clearMessage(selectedStamp!);
                      setState(() {
                        loadJoinStamp();
                      });
                    }
                  : null,
              child: Text(
                clearButtonMessage(selectedStamp),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getDistance(int index) {
    double distance = (6371 *
        acos(cos(vect.radians(myPosition.latitude)) *
                cos(vect
                    .radians(stampDetailMessages[index]['messageLatitude'])) *
                cos(vect.radians(
                        stampDetailMessages[index]['messageLongitude']) -
                    vect.radians(myPosition.longitude)) +
            sin(vect.radians(myPosition.latitude)) *
                sin(vect
                    .radians(stampDetailMessages[index]['messageLatitude']))));

    return distance;
  }

  Future<void> loadJoinStamp() async {
    var dio = DIO.Dio();

    if (user.isLogin()) {
      var response = await dio.get(
          'http://k7a108.p.ssafy.io:8080/stamp/joinList/${user.userinfo["userId"]}');
      ;
      setState(() {
        stampDetail = response.data == '' ? {} : response.data;
      });

      if (response.data != '') {
        var firstMessage = response.data['stampboard_message1'];
        var secondMessage = response.data['stampboard_message2'];
        var thirdMessage = response.data['stampboard_message3'];

        await dio
            .post(
                'http://k7a108.p.ssafy.io:8080/stamp/info/$firstMessage/$secondMessage/$thirdMessage/${user.userinfo["userId"]}')
            .then((res) {
          setState(() {
            stampDetailMessages = [res.data[0], res.data[1], res.data[2]];
          });
          // return stampDetailMessages;
        });
      } else {}
    }
  }

  void clearMessage(int index) async {
    var dio = DIO.Dio();
    //   await dio.post(
    //       'http://k7a108.p.ssafy.io:8080/stamp/clear/${user.userinfo["userId"]}/${joinedStamp.joinedMessages[index]["messageId"]}');
    // }
    await dio
        .post(
            'http://k7a108.p.ssafy.io:8080/stamp/clear/${user.userinfo["userId"]}/${stampDetailMessages[index]["messageId"]}')
        .then((value) {
      stampDetail['userjoinedStampboard_cleardate${index + 1}'] =
          DateTime.now().toString();
    });

    if (stampDetail['userjoinedStampboard_cleardate1'] != null &&
        stampDetail['userjoinedStampboard_cleardate2'] != null &&
        stampDetail['userjoinedStampboard_cleardate3'] != null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('스탬푸를 완료했습니다!'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('클리어'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
            );
          });
    }
  }

  String clearButtonMessage(int? index) {
    if (stampDetail['userjoinedStampboard_cleardate1'] != null &&
        stampDetail['userjoinedStampboard_cleardate2'] != null &&
        stampDetail['userjoinedStampboard_cleardate3'] != null) {
      return '스탬푸 완성!';
    } else if (index == null) {
      return '선택된 메세지가 없음';
    } else if (stampDetail['userjoinedStampboard_cleardate${index + 1}'] !=
        null) {
      return '방문 완료';
    } else if (isNearMessage(index) &&
        stampDetail['userjoinedStampboard_cleardate${index + 1}'] == null) {
      return '${index + 1}번 클리어하기';
    } else {
      return '근처에 방문해주세요';
    }
  }

  bool isNearMessage(int? index) {
    if (index != null && getDistance(index) < 0.03) {
      return true;
    } else {
      return false;
    }
  }
}
