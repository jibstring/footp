import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dio/dio.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

final formKey = GlobalKey<FormState>();

class _SignUpState extends State<SignUp> {
  final myEmail = TextEditingController();
  bool _value = false;
  bool obscurePasswordOne = true;
  bool obscurePasswordTwo = true;
  String? passwordConfirm;
  String? passwordValidation;
  bool passwordConfirmed = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                // 앱 이름
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'FootP',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),

                //회원가입 글자
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 20),
                    )),

                //이메일 입력 창
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _value = false;
                        });
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'User Email',
                          suffixIcon: _value != true
                              ? Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      checkEmailDuplicate(emailController.text);
                                    },
                                    child: Text('중복확인'),
                                  ))
                              : Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.green,
                                ))),
                ),

                //비밀번호 입력창
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TextField(
                    obscureText: obscurePasswordOne,
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
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
                        passwordConfirmed = (passwordController.text ==
                            passwordConfirmController.text);
                      });
                    },
                  ),
                ),

                // 비밀번호 유효성 확인
                Text('$passwordValidation'),

                // 비밀번호 확인용 입력창
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TextField(
                    obscureText: obscurePasswordTwo,
                    controller: passwordConfirmController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password Confirm',
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
                        passwordConfirmed = (passwordController.text ==
                            passwordConfirmController.text);
                      });
                    },
                  ),
                ),

                Text('$passwordConfirmed'),
                Text('${emailController.text == ''}'),

                // 가입 버튼
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Sign Up'),
                      onPressed: () {
                        if (emailController == '' ||
                            passwordController == '' ||
                            passwordConfirmController == '') {
                          _showDialog('입력하지 않은 값이 있습니다.');
                        } else if (_value == false) {
                          _showDialog('이메일 중복확인을 완료해주세요.');
                        } else if (passwordConfirmed == false ||
                            passwordValidation != '올바른 비밀번호입니다.') {
                          _showDialog('비밀번호를 확인해주세요.');
                        } else {
                          createAccount();
                        }
                      },
                    )),
              ],
            )));
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

  String? validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return '알파벳 대,소문자, 숫자, 특수문자를 포함하여 8자 이상';
    } else {
      if (!regex.hasMatch(value)) {
        return '올바른 형식으로 입력해주세요';
      } else {
        return '올바른 비밀번호입니다.';
      }
    }
  }

  bool? validateEmail(String value) {
    bool regex = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    return regex;
  }

  Future checkEmailDuplicate(String email) async {
    var dio = Dio();
    final response =
        await dio.post('http://k7a108.p.ssafy.io:8080/auth/duplicate/$email');

    if (validateEmail(email) == false) {
      _showDialog('형식이 올바르지 않습니다.');
    } else if (response.data == true) {
      _showDialog('이미 사용 중인 이메일입니다.');
    } else {
      setState(() {
        _value = !_value;
      });
    }
  }

  Future createAccount() async {
    var dio = Dio();
    var data = {
      'userEmail': emailController.text,
      'userPassword': passwordController.text,
    };
    final response =
        await dio.post('http://k7a108.p.ssafy.io:8080/auth/signup', data: data);
    print('#################################');
    print(response);
    print('#################################');

    _showDialog('가입 성공!');
  }
}