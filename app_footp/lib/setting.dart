import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app_footp/myPage.dart';
import 'package:app_footp/components/userSetting/agreement.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:get/get.dart';

import 'custom_class/store_class/store.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});
  final controller = Get.put(UserData());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,       
        elevation: 0,
        leading:IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color : Colors.blue[100],
            size:40,
          ),
          padding: const EdgeInsets.fromLTRB(10,0,0,0),
          onPressed:(){
            Navigator.pop(context);
          },
          ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.grey[850]), // 좌측기준 스위프트에서 leading
              onTap: () { // 탭 이벤트 처
                print('알림설정');
              }, 
              title: Text('알림설정'),
            ),
            ListTile(
              leading: Icon(Icons.lock, color: Colors.grey[850]),
              onTap: () {
                print('');
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
                print('회원탈퇴');
                removeUser();
              },
              title: Text('회원탈퇴'),
            )
          ],
        ),
      ),
    );
  }
  void removeUser()async{
    var dio = Dio();
    String userId=controller.userinfo["userNickname"];
    final response_login =
        await dio.delete('http://k7a108.p.ssafy.io:8080/user/leave/${userId}');

    if (response_login.data['message'] == 'fail') {
      print('회원탈퇴 실패');
    } else {
      print('####################################');
      print(response_login.data);
      print('####################################');
    }
  }
}