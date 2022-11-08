import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:app_footp/custom_class/store_class/store.dart';

const serverUrl='http://k7a108.p.ssafy.io:8080';

class NicknameSetting extends StatefulWidget {
  const NicknameSetting({super.key});

  @override
  State<NicknameSetting> createState() => _NicknameSettingState();
}

class _NicknameSettingState extends State<NicknameSetting> {
  int background=0;
  final controller = Get.put(UserData());
  final userInput=TextEditingController();

  bool _fail_nickname=false;
  void updateNickname(context) async{
    print('닉네임수정요청');
    
    final uri=Uri.parse(serverUrl+'/user/nickname');
    final bbody=json.encode({
        "userId":controller.userinfo["userId"],
        "userNickname":userInput.text
      });
    
    // print("bbody");
    // print(bbody);

    http.Response response=await http.put(
      uri,
      body:bbody,
      headers: {
        "Accept": "application/json",
        "content-type":"application/json"
      }
    );
    if(response.statusCode==200){
      controller.userinfo["userNickname"]=userInput.text;
      Navigator.of(context).pop();
    }
    else{
      print('닉네임 실패패패패패패ㅐ퍂');
      print(response.statusCode);
      _fail_nickname=true;
    }
  }
    
  Widget build(BuildContext context) {
    return AlertDialog(
      title:Text("닉넴이 정하기"),
      content:SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('닉네임을 입력해주세요(1~10자)'),
            TextField(
              controller: userInput,
              maxLength: 10,
            ),
            Visibility(child: Text("닉네임 변경에 실패했습니다"),visible: _fail_nickname,)
            
          ]),
        ),
        actions:<Widget>[
          TextButton(onPressed: (){
            Navigator.of(context).pop();
            },
          child: Text("취소")),
          TextButton(
            onPressed: (){
              print('인풋 :${userInput.text}');
              userInput.text !="" ?updateNickname(context):background=0;
            },
            child: Text("확인")
          )
          ]

    );
  }
}