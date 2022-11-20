import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:app_footp/setting.dart';
import 'package:app_footp/custom_class/store_class/store.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var url;
  var response;
  bool obscurePasswordOne = true;
  bool obscurePasswordTwo = true;
  String passwordValidation = '알파벳 대,소문자, 숫자, 특수문자를 포함하여 8자 이상';
  bool passwordConfirmed = true;

  UserData user = Get.put(UserData());
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
            "비밀번호 변경을 위해 새로운 비밀번호를 입력해주세요.",
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

        Container(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            height: 50,
            child: ElevatedButton(
              child: const Text(
                '비밀번호 변경',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              onPressed: () async {
                if (passwordController == '' ||
                    passwordConfirmController == '') {
                  Fluttertoast.showToast(
                      msg: "입력하지 않은 값이 있습니다.",
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: const Color(0xff6E6E6E),
                      fontSize: 11,
                      toastLength: Toast.LENGTH_SHORT);
                } else if (passwordConfirmed == false ||
                    passwordValidation != '올바른 비밀번호입니다.') {
                  Fluttertoast.showToast(
                      msg: "비밀번호를 확인해주세요.",
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: const Color(0xff6E6E6E),
                      fontSize: 11,
                      toastLength: Toast.LENGTH_SHORT);
                } else {
                  url =
                      Uri.parse('http://k7a108.p.ssafy.io:8080/user/password');
                  response = await http.put(url,
                      body: json.encode({
                        "userId": user.userinfo["userId"],
                        "userPassword": passwordController.text
                      }),
                      headers: {
                        "Accept": "application/json",
                        "content-type": "application/json"
                      });

                  Fluttertoast.showToast(
                      msg: "비밀번호가 변경되었습니다.",
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: const Color(0xff6E6E6E),
                      fontSize: 11,
                      toastLength: Toast.LENGTH_SHORT);
                  Navigator.of(context).pop();
                }
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 255, 171, 112)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                )),
              ),
            )),
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
