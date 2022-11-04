import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const serverUrl='http://k7a108.p.ssafy.io:8080/foot';

class NicknameSetting extends StatefulWidget {
  const NicknameSetting({super.key});

  @override
  State<NicknameSetting> createState() => _NicknameSettingState();
}

class _NicknameSettingState extends State<NicknameSetting> {
  final userInput=TextEditingController();
  void updateNickname(context) async{
    print('되라라라ㅏㅏㅏㅏ1');
    int userId=1223;
    
    final uri=Uri.parse(serverUrl+'/user/nickname');
    
    http.Response response=await http.put(
      uri,
      body:json.encode({
        'userId':userId,
        'userNickname':userInput.text
      })
    );
    
    print('2되라라라ㅏㅏㅏㅏ2');
    print(uri);
    if(response.statusCode==200){
      var decodedData=jsonDecode(response.body);
      print(decodedData);
    }
    else{
      print('닉네임 실패패패패패패ㅐ퍂');
      print(response.statusCode);

      throw 'sendReport() error';
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
              maxLength: 20,
            )
          ]),
        ),
        actions:<Widget>[
          TextButton(onPressed: (){
            Navigator.of(context).pop();
            },
          child: Text("취소")),
          TextButton(
            onPressed: (){
              updateNickname(context);
              Navigator.of(context).pop();
            },
            child: Text("확인")
          )
          ]

    );
  }
}