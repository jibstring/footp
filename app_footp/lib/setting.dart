import 'package:app_footp/mainMap.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app_footp/myPage.dart';
import 'package:app_footp/changePassword.dart';
import 'package:app_footp/passwordCertification.dart';
import 'package:app_footp/unsigned.dart';
import 'package:app_footp/components/userSetting/agreement.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:get/get.dart';
import 'package:log_print/log_print.dart';

import 'custom_class/store_class/store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});
  final controller = Get.put(UserData());
  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';

  Future<void> _checkUnsign(BuildContext context) async {
    return showDialog<void>(
        context: context,
        // 사용자가 다이얼로그 바깥을 터치하면 닫히지 않음
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("정말로 탈퇴하시겠습니까?"),
            actions: <Widget>[
              TextButton(
                child: const Text('예'),
                onPressed: () {
                  // 다이얼로그 닫기
                  removeUser();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Unsigned()));
                },
              ),
              TextButton(
                child: const Text('아니요'),
                onPressed: () {
                  // 다이얼로그 닫기
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> _checkLogout(BuildContext context) async {
    return showDialog<void>(
        context: context,
        // 사용자가 다이얼로그 바깥을 터치하면 닫히지 않음
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("로그아웃 하시겠습니까?"),
            actions: <Widget>[
              TextButton(
                child: const Text('예'),
                onPressed: () {
                  // 다이얼로그 닫기
                  LogOut();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('아니요'),
                onPressed: () {
                  // 다이얼로그 닫기
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.blue[100],
            size: 40,
          ),
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.notifications,
                  color: Colors.grey[850]), // 좌측기준 스위프트에서 leading
              onTap: () {
                // 탭 이벤트 처
                print('알림설정');
              },
              title: Text('알림설정'),
            ),
            ListTile(
              leading: Icon(Icons.lock, color: Colors.grey[850]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PasswordCertification()),
                );
              },
              title: Text('비밀번호 변경'),
            ),
            ListTile(
              leading: Icon(Icons.description, color: Colors.grey[850]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Agreement()),
                );
              },
              title: Text('푸프 약관 및 동의사항'),
            ),
            ListTile(
              leading: Icon(Icons.list, color: Colors.grey[850]),
              onTap: () {
                print('notice');
              },
              title: Text('공지사항'),
            ),
            ListTile(
              leading: Icon(Icons.list, color: Colors.grey[850]),
              onTap: () {
                _checkUnsign(context);
              },
              title: Text('회원탈퇴'),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.grey[850]),
              title: Text("로그아웃"),
              onTap: () {
                _checkLogout(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Future removeUser() async {
    var dio = Dio();
    int userId = controller.userinfo["userId"];
    final response =
        await dio.delete('http://k7a108.p.ssafy.io:8080/user/unsign/${userId}');

    if (response.data == "success") {
      Fluttertoast.showToast(
          msg: "회원 탈퇴가 완료되었습니다.",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xff6E6E6E),
          fontSize: 11,
          toastLength: Toast.LENGTH_SHORT);
      return 1;
    } else {
      Fluttertoast.showToast(
          msg: "오류로 인해 탈퇴에 실패하였습니다.",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xff6E6E6E),
          fontSize: 11,
          toastLength: Toast.LENGTH_SHORT);
      return 0;
    }
  }

  LogOut() async {
    await storage.delete(key: 'login');
    LogPrint("로그아웃");
    // Navigator.pushNamed(context, '/');
    controller.logout();
  }
}
