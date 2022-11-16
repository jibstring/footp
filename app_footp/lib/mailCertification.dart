import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:app_footp/signIn.dart';
import 'package:app_footp/custom_class/store_class/store.dart';

class MailCertification extends StatefulWidget {
  const MailCertification({super.key});

  @override
  State<MailCertification> createState() => _MailCertificationState();
}

class _MailCertificationState extends State<MailCertification> {
  int time = 180;
  int timerActive = 0;
  int buttonActive = 0;
  Timer timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {});
  UserData user = Get.put(UserData());
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
          child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Text(
              "최초 가입 시 유효한 이메일 인증을 위해",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              "가입 시 입력한 이메일로 인증 번호를 발송합니다.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              "유효 기간 3분 내로 인증 번호 6자리를 입력해 주세요!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  height: 50,
                  child: Text(
                    user.userinfo["userEmail"],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                  height: 50,
                  child: ElevatedButton(
                    child: const Text(
                      '인증번호 발송',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      time = 180;
                      buttonActive = 1;
                      if (timerActive == 0) {
                        timerActive = 1;
                        timer = Timer.periodic(Duration(milliseconds: 1000),
                            (timer) {
                          setState(() {
                            if (time > 0) {
                              time--;
                            }
                          });
                        });
                      }
                      // 인증번호 발송 요청
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 164, 185, 237))),
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    width: 100,
                    child: TextField(
                        controller: numberController,
                        maxLength: 6,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '인증번호',
                          counterText: '',
                        )),
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(12, 15, 0, 0),
                      height: 50,
                      child: Text(
                        '${((time / 60).toInt()).toString()}:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      )),
                  Container(
                      padding: const EdgeInsets.fromLTRB(1, 15, 0, 0),
                      height: 50,
                      child: Text(
                        (time % 60).toInt() < 10
                            ? changeMinute((time % 60).toInt().toString())
                            : (time % 60).toInt().toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      )),
                  (buttonActive == 0)
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          height: 50)
                      : Container(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          height: 50,
                          child: ElevatedButton(
                            child: const Text(
                              '인증하기',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: () {
                              if (numberController.text.length == 6) {
                                // 인증 요청 보내고 맞는지 확인
                                print(numberController.text);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "6자리 인증번호를 모두 입력해주세요!",
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: const Color(0xff6E6E6E),
                                    fontSize: 11,
                                    toastLength: Toast.LENGTH_SHORT);
                              }
                            },
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(255, 255, 171, 112))),
                          ),
                        ),
                ],
              ))
        ],
      )),
    );
  }

  String changeMinute(String minute) {
    return "0" + minute;
  }
}
