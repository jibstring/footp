import 'package:app_footp/createFootMap.dart';
import 'package:app_footp/mainMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:app_footp/components/userSetting/agreement.dart';
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
  bool _nicknamevalue = false;
  bool obscurePasswordOne = true;
  bool obscurePasswordTwo = true;
  String passwordValidation = '알파벳 대,소문자, 숫자, 특수문자를 포함하여 8자 이상';
  bool passwordConfirmed = true;
  bool _isCheck = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
                child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                //앱로고
                Container(
                  height: 70,
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
                            //fontWeight: FontWeight.bold,
                            fontSize: 30,
                            //fontFamily: "edu"
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        const Text(
                          '프',
                          style: TextStyle(
                            color: Color.fromARGB(255, 164, 185, 237),
                            //fontWeight: FontWeight.bold,
                            fontSize: 30,
                            //fontFamily: "edu"
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 50,
                ),

                //이메일 입력 창
                Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                  child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _value = false;
                        });
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '이메일 주소',
                          suffixIcon: _value != true
                              ? Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(
                                                  255, 164, 185, 237)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        //side: BorderSide(color: Colors.red) // border line color
                                      )),
                                    ),
                                    onPressed: () {
                                      checkEmailDuplicate(emailController.text);
                                    },
                                    child: Text(
                                      '중복확인',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ))
                              : Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.green,
                                ))),
                ),

                SizedBox(height: 20),
                //비밀번호 입력창
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextField(
                    obscureText: obscurePasswordOne,
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '비밀번호',
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
                Container(
                    padding: EdgeInsets.fromLTRB(35, 5, 30, 15),
                    child: passwordValidation == '올바른 형식으로 입력해주세요.'
                        ? Text('$passwordValidation',
                            style: TextStyle(color: Colors.red))
                        : Text('$passwordValidation',
                            style: TextStyle(color: Colors.green))
                    // child: Text('$passwordValidation'),
                    ),

                // 비밀번호 확인용 입력창
                Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextField(
                    obscureText: obscurePasswordTwo,
                    controller: passwordConfirmController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '비밀번호 확인',
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
                //닉네임 입력
                Container(
                  padding: EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _nicknamevalue = false;
                        });
                      },
                      controller: nicknameController,
                      maxLength: 10,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '닉네임을 입력하세요',
                          suffixIcon: _nicknamevalue != true
                              ? Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(
                                                  255, 164, 185, 237)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        //side: BorderSide(color: Colors.red) // border line color
                                      )),
                                    ),
                                    onPressed: () {
                                      checknicknameDuplicate(
                                          nicknameController.text);
                                    },
                                    child: Text('중복확인',
                                        style: TextStyle(color: Colors.black)),
                                  ))
                              : Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.green,
                                ))),
                ),
                // SizedBox(
                //   height:10
                // ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Agreement()),
                      );
                    },
                    child: Row(
                      children: [
                        Checkbox(
                            value: _isCheck,
                            onChanged: (value) {
                              setState(() {
                                _isCheck = value!;
                              });
                            }),
                        Text(
                          "개인정보 동의 >",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),
                // 가입 버튼
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 255, 171, 112),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          //side: BorderSide(color: Colors.red) // border line color
                        )),
                      ),
                      child: const Text('회원가입',
                          style: TextStyle(color: Colors.black, fontSize: 17)),
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
                        } else if (_nicknamevalue == false) {
                          _showDialog('닉네임 중복확인을 완료해주세요.');
                        } else if (_isCheck == false) {
                          _showDialog('이용약관을 동의해주세요');
                        } else {
                          createAccount();
                        }
                      },
                    )),
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
      'userNickname': nicknameController.text
    };
    final response =
        await dio.post('http://k7a108.p.ssafy.io:8080/auth/signup', data: data);
    print('#################################');
    print(response);
    print('#################################');

    _showDialog('가입 성공! 최초 로그인 시 인증이 필요합니다.');
    Navigator.pop(context);
  }

  Future checknicknameDuplicate(String nickname) async {
    var dio = Dio();
    final response =
        await dio.post('http://k7a108.p.ssafy.io:8080/auth/nickname/$nickname');

    if (response.data == true) {
      _showDialog('이미 사용 중인 닉네임입니다.');
    } else {
      setState(() {
        _nicknamevalue = !_nicknamevalue;
      });
    }
  }
}
