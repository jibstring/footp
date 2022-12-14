import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:app_footp/signIn.dart';
import 'package:app_footp/custom_class/store_class/store.dart';

class MailCertification extends StatefulWidget {
  const MailCertification({super.key});

  @override
  State<MailCertification> createState() => _MailCertificationState();
}

class _MailCertificationState extends State<MailCertification> {
  var url;
  var response;
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
          child: ListView(
        children: <Widget>[
          Center(
              child: Container(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Text(
              "최초 가입 시 유효한 이메일 인증을 위해",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          )),
          Center(
              child: Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              "가입 시 입력한 이메일로 인증 번호를 발송합니다.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          )),
          Center(
              child: Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              "유효 기간 3분 내로 인증 번호 10자리를 입력해 주세요!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          )),
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
                    onPressed: () async {
                      url = Uri.parse(
                          'http://k7a108.p.ssafy.io:8080/auth/email/${user.userinfo["userEmail"]}');
                      response = await http.post(url);

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

                      Fluttertoast.showToast(
                          msg: "인증 번호를 메일로 발송하였습니다.",
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: const Color(0xff6E6E6E),
                          fontSize: 11,
                          toastLength: Toast.LENGTH_SHORT);
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
                    width: 150,
                    child: TextField(
                        controller: numberController,
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 10,
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
                            onPressed: () async {
                              if (time != 0) {
                                if (numberController.text.length == 10) {
                                  numberController.text =
                                      numberController.text.toUpperCase();

                                  url = Uri.parse(
                                      'http://k7a108.p.ssafy.io:8080/auth/success/${user.userinfo["userId"]}/${numberController.text}');
                                  response = await http.post(url);

                                  if (json.decode(response.body) == true) {
                                    Fluttertoast.showToast(
                                        msg: "인증이 완료되었습니다.",
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor:
                                            const Color(0xff6E6E6E),
                                        fontSize: 11,
                                        toastLength: Toast.LENGTH_SHORT);
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "인증 번호가 다릅니다. 다시 확인해주세요.",
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor:
                                            const Color(0xff6E6E6E),
                                        fontSize: 11,
                                        toastLength: Toast.LENGTH_SHORT);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "10자리 인증번호를 모두 입력해주세요.",
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: const Color(0xff6E6E6E),
                                      fontSize: 11,
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "유효 기간이 경과하였습니다. 재발송 바랍니다.",
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
