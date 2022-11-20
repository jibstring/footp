import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:app_footp/setting.dart';
import 'package:app_footp/changePassword.dart';
import 'package:app_footp/custom_class/store_class/store.dart';

class PasswordCertification extends StatefulWidget {
  const PasswordCertification({super.key});

  @override
  State<PasswordCertification> createState() => _PasswordCertificationState();
}

class _PasswordCertificationState extends State<PasswordCertification> {
  var url;
  var response;
  UserData user = Get.put(UserData());
  bool obscurePassword = true;
  TextEditingController passwordController = TextEditingController();

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

          // 현재 비밀번호 입력창
          Container(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
            child: TextField(
              obscureText: obscurePassword,
              controller: passwordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '현재 비밀번호',
                  suffixIcon: obscurePassword == true
                      ? IconButton(
                          icon: Icon(Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.visibility),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        )),
              onChanged: (value) {},
            ),
          ),

          Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              height: 50,
              child: ElevatedButton(
                child: const Text(
                  '다음으로',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                onPressed: () async {
                  if (passwordController == '') {
                    Fluttertoast.showToast(
                        msg: "입력하지 않은 값이 있습니다.",
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: const Color(0xff6E6E6E),
                        fontSize: 11,
                        toastLength: Toast.LENGTH_SHORT);
                  } else {
                    url = Uri.parse(
                        'http://k7a108.p.ssafy.io:8080/auth/reset/${passwordController.text}/${user.userinfo["userId"]}');
                    response = await http.post(url);

                    if (json.decode(response.body) == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChangePassword(passwordController.text)),
                      );
                    } else {
                      Fluttertoast.showToast(
                          msg: "현재 비밀번호가 일치하지 않습니다.",
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: const Color(0xff6E6E6E),
                          fontSize: 11,
                          toastLength: Toast.LENGTH_SHORT);
                    }
                  }
                },
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 164, 185, 237)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )),
                ),
              )),
        ],
      )),
    );
  }
}
