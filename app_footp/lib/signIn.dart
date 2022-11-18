import 'dart:convert';

import 'package:app_footp/createFoot.dart';
import 'package:app_footp/mainMap.dart';
import 'package:app_footp/signUp.dart';
import 'package:app_footp/mailCertification.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dio/dio.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool obscurePassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserData user = Get.put(UserData());
  bool? _isAutoLogin = false;

  Future signIn() async {
    var dio = Dio();
    var data = {
      'userEmail': emailController.text,
      'userPassword': passwordController.text,
      'userAutologin': _isAutoLogin,
    };

    final response_login =
        await dio.post('http://k7a108.p.ssafy.io:8080/auth/signin', data: data);

    print('####################################');
    print(response_login.data);
    print('####################################');

    if (response_login.data['message'] == 'fail') {
      _showDialog('로그인 실패');
    } else {
      user.login(response_login.data["Authorization"]); //토큰 저장
      String temp = user.Token;
      Map<String, dynamic>? decoded_payload = user.decoding_payload(temp);
      var aa = decoded_payload?["userid"];

      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@라라라$temp");
      print(
          "#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@decoded_payload@@@@@@@@@@${decoded_payload?["userid"]}");

      final snackBar = SnackBar(
        content: Text('로그인 성공!', style: TextStyle(color: Colors.green)),
        action: SnackBarAction(
          label: '확인',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      //userinfo Get
      var url = Uri.parse(
          'http://k7a108.p.ssafy.io:8080/auth/info/${decoded_payload?["userid"]}');
      print(url);
      var response = await http.post(url);
      var qqqqq = json.decode(response.body);
      //user.userinfoSet(response.body);
      user.userinfoSet(qqqqq["userInfo"]);
      print("@@@@@@@@@@#################@@@@@@@@@@@${user.userinfo}");

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => mainMap()));

      if (identical(user.userinfo["userEmailKey"], "Y")) {
        Navigator.pop(context);
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MailCertification()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, //fromARGB(245,239, 240, 253),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
            child: Center(
                child: ListView(
              children: <Widget>[
                //앱로고
                Container(
                  height: 130,
                  child: Image.asset("./imgs/logo.png"),
                ),
                // 앱 이름
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '푸',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 171, 112),
                            // fontWeight: FontWeight.bold,
                            fontSize: 40,
                            // fontFamily: "edu"
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        const Text(
                          '프',
                          style: TextStyle(
                            color: Color.fromARGB(255, 164, 185, 237),
                            // fontWeight: FontWeight.bold,
                            fontSize: 40,
                            // fontFamily: "edu"
                          ),
                        ),
                      ],
                    )),

                //로그인 글자
                SizedBox(
                  height: 50,
                ),

                //이메일 입력 창
                Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '이메일',
                      )),
                ),
                //비밀번호 입력창
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                  child: TextField(
                    obscureText: obscurePassword,
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '비밀번호',
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
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                //자동 로그인
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Checkbox(
                        value: _isAutoLogin,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onChanged: (Value) {
                          setState(() {
                            _isAutoLogin = Value;
                          });
                        }),
                    Text("로그인 상태 유지"),
                  ],
                ),

                // 로그인 버튼
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  height: 80, //버튼의 세로 길이
                  child: ElevatedButton(
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                    onPressed: () {
                      signIn();
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 164, 185, 237)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        //side: BorderSide(color: Colors.red) // border line color
                      )),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                  height: 70, //버튼의 세로 길이
                  child: ElevatedButton(
                    child: const Text(
                      '회원가입',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 255, 171, 112)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        //side: BorderSide(color: Colors.red) // border line color
                      )),
                    ),
                  ),
                ),
                // Container(
                //     padding: const EdgeInsets.fromLTRB(30, 0, 30,0),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: <Widget>[
                //         Text('아직 계정이 없으신가요?'),
                //         TextButton(
                //           child: Text('회원가입 하기'),
                //           onPressed: () {
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => SignUp()));
                //           },
                //         ),
                //       ],
                //     )),
              ],
            ))));
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            new ElevatedButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
