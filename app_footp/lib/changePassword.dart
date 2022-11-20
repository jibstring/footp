import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:app_footp/setting.dart';
import 'package:app_footp/custom_class/store_class/store.dart';

class ChangePassword extends StatefulWidget {
  int _case = 0;
  ChangePassword(this._case, {Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var url;
  var response;
  bool obscurePasswordCurrent = true;
  bool obscurePasswordOne = true;
  bool obscurePasswordTwo = true;
  bool currentConfirmed = true;
  bool passwordConfirmed = true;
  String passwordValidation = '알파벳 대,소문자, 숫자, 특수문자를 포함하여 8자 이상';

  UserData user = Get.put(UserData());
  TextEditingController currentController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

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
            "비밀번호 변경을 위해 현재 비밀번호를 입력해주세요.",
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
            "비밀번호는 알파벳 대문자, 소문자, 숫자, 특수문자의",
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
            "네 종류 문자를 조합하여 8자 이상 입력바랍니다.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        )),

        // 현재 비밀번호 입력창
        (widget._case == 1)
            ? Container(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: TextField(
                  obscureText: obscurePasswordCurrent,
                  controller: currentController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '현재 비밀번호',
                      suffixIcon: obscurePasswordCurrent == true
                          ? IconButton(
                              icon: Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  obscurePasswordCurrent =
                                      !obscurePasswordCurrent;
                                });
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  obscurePasswordCurrent =
                                      !obscurePasswordCurrent;
                                });
                              },
                            )),
                  onChanged: (value) {
                    setState(() {
                      currentConfirmed = ((currentController.text ==
                              passwordController.text) ||
                          (currentController.text ==
                              passwordConfirmController.text));
                    });
                  },
                ),
              )
            : Container(),

        // 새로운 비밀번호 입력창
        Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: TextField(
            obscureText: obscurePasswordOne,
            controller: passwordController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '새로운 비밀번호',
                suffixIcon: obscurePasswordOne == true
                    ? IconButton(
                        icon: Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obscurePasswordOne = !obscurePasswordOne;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            obscurePasswordOne = !obscurePasswordOne;
                          });
                        },
                      )),
            onChanged: (value) {
              setState(() {
                passwordValidation = validatePassword(value);
                passwordConfirmed =
                    (passwordController.text == passwordConfirmController.text);
              });
            },
          ),
        ),

        // 비밀번호 유효성 확인
        Container(
            padding: EdgeInsets.fromLTRB(35, 5, 30, 15),
            child: passwordValidation == '올바른 형식으로 입력해주세요.'
                ? Text('$passwordValidation',
                    style: TextStyle(color: Colors.red))
                : Text('$passwordValidation',
                    style: TextStyle(color: Colors.green))
            // child: Text('$passwordValidation'),
            ),

        // 새로운 비밀번호 확인용 입력창
        Container(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: TextField(
            obscureText: obscurePasswordTwo,
            controller: passwordConfirmController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '새로운 비밀번호 확인',
                suffixIcon: obscurePasswordTwo == true
                    ? IconButton(
                        icon: Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obscurePasswordTwo = !obscurePasswordTwo;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            obscurePasswordTwo = !obscurePasswordTwo;
                          });
                        },
                      )),
            onChanged: (value) {
              setState(() {
                passwordConfirmed =
                    (passwordController.text == passwordConfirmController.text);
              });
            },
          ),
        ),

        // 비밀번호 일치 확인
        Container(
          padding: EdgeInsets.fromLTRB(30, 5, 30, 15),
          child: passwordConfirmed
              ? Text(
                  '비밀번호가 일치합니다.',
                  style: TextStyle(color: Colors.green),
                )
              : Text(
                  '비밀번호가 일치하지 않습니다.',
                  style: TextStyle(color: Colors.red),
                ),
        ),
      ],
    )));
  }

  String comparePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value == '') {
      return '알파벳 대,소문자, 숫자, 특수문자를 포함하여 8자 이상';
    } else {
      if (!regex.hasMatch(value)) {
        return '올바른 형식으로 입력해주세요.';
      } else {
        return '올바른 비밀번호입니다.';
      }
    }
  }

  String validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value == '') {
      return '알파벳 대,소문자, 숫자, 특수문자를 포함하여 8자 이상';
    } else {
      if (!regex.hasMatch(value)) {
        return '올바른 형식으로 입력해주세요.';
      } else {
        return '올바른 비밀번호입니다.';
      }
    }
  }
}
