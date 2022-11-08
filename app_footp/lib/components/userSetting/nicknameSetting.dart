import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:dio/dio.dart';

const serverUrl='http://k7a108.p.ssafy.io:8080';

class NicknameSetting extends StatefulWidget {
  const NicknameSetting({super.key});

  @override
  State<NicknameSetting> createState() => _NicknameSettingState();
}

class _NicknameSettingState extends State<NicknameSetting> {
  int background=0;
  final controller = Get.put(UserData());
  TextEditingController nicknameController = TextEditingController();
  bool _nicknamevalue = false;

  bool _fail_nickname=false;
    
  Widget build(BuildContext context) {
    return AlertDialog(
      title:Text("👑닉네임 수정👑",textAlign: TextAlign.center,),
      content:SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Text('닉네임을 입력해주세요(1~10자)'),
            Container(
                  padding: EdgeInsets.fromLTRB(5, 20, 5, 5),
                  child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _nicknamevalue = false;
                        });
                      },
                      controller: nicknameController,
                      maxLength: 15,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '닉네임을 입력하세요',)),
                ),
                _nicknamevalue != true
                              ? Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      checknicknameDuplicate(
                                          nicknameController.text);
                                    },
                                    child: Text('중복확인'),
                                  ))
                              : Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.green,
                                ),
          ]),
        ),
        actions:<Widget>[
          TextButton(onPressed: (){
            Navigator.of(context).pop();
            },
          child: Text("취소")),
          TextButton(
            onPressed: (){
              if (_nicknamevalue == false) {
                  _showDialog('닉네임 중복확인을 완료해주세요.');
              }
              else{    
                print('인풋 :${nicknameController.text}');
                nicknameController.text !="" ?updateNickname(context):background=0;
              }
            },
            child: Text("확인")
          )
          ]

    );
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

    //닉네임수정요청
  void updateNickname(context) async{
    print('닉네임수정요청');
    
    final uri=Uri.parse(serverUrl+'/user/nickname');
    final bbody=json.encode({
        "userId":controller.userinfo["userId"],
        "userNickname":nicknameController.text
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
      controller.userinfo["userNickname"]=nicknameController.text;
      Navigator.of(context).pop();
    }
    else{
      print('닉네임 실패패패패패패ㅐ퍂');
      print(response.statusCode);
      _fail_nickname=true;
    }
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