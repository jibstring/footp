import 'dart:math';

import 'package:app_footp/custom_class/store_class/store.dart';
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
  JoinStampInfo joinedStamp = Get.put(JoinStampInfo());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadJoinStamp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(40.0),
      child: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  Image.network('${stampDetail['stampboard_designurl']}'),
                  Container(
                    // width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // itemCount: joinedStamp.joinedMessages.length,
                        itemCount: stampDetailMessages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedStamp = index;
                                  });
                                },
                                child: Container(
                                    width: 50,
                                    height: 50,
                                    margin: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: selectedStamp == index
                                          ? Colors.lightBlue
                                          : Colors.orange,
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 1),
                                    ),
                                    child: Text('$index번 상자')),
                              )
                            ],
                          );
                        }),
                  ),
                  Container(
                      child: selectedStamp != null
                          ? Text(getDistance(selectedStamp!).toString())
                          : Text('hi')),
                  Row(
                    children: [
                      ElevatedButton(
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
                        child: Text(clearButtonMessage(selectedStamp)),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            loadJoinStamp();
                          },
                          child: Text('OK'))
                    ],
                  ),
                ],
              ))),
    ));
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

  void loadJoinStamp() async {
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
        var joinStamp = response.data;
        joinedStamp.joinedStamp = joinStamp;

        print('#########################');
        print(response.data);
        print(response.data['stampboard_id']);
        print(response.data['stampboard_id'].runtimeType);
        print('##############################');

        await dio
            .post(
                'http://k7a108.p.ssafy.io:8080/stamp/info/$firstMessage/$secondMessage/$thirdMessage/${user.userinfo["userId"]}')
            .then((res) {
          joinedStamp.message1 = res.data[0];
          joinedStamp.message2 = res.data[1];
          joinedStamp.message3 = res.data[2];
          joinedStamp.joinedMessages = [res.data[0], res.data[1], res.data[2]];
          setState(() {
            stampDetailMessages = [res.data[0], res.data[1], res.data[2]];
          });
        });
      } else {
        setState(() {
          stampDetailMessages = [];
        });
      }
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
      return 's';
    } else if (index == null) {
      return '선택된 메세지가 없음';
    } else if (stampDetail['userjoinedStampboard_cleardate${index + 1}'] !=
        null) {
      return '이미 클리어';
    } else if (isNearMessage(index) &&
        stampDetail['userjoinedStampboard_cleardate${index + 1}'] == null) {
      return '$index번 클리어하기';
    } else {
      return '거리가 멀어용';
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
