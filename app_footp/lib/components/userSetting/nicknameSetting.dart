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
      title:Text("πλλ€μ μμ π",textAlign: TextAlign.center,),
      content:SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Text('λλ€μμ μλ ₯ν΄μ£ΌμΈμ(1~10μ)'),
            Container(
                  padding: EdgeInsets.fromLTRB(5, 20, 5, 5),
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
                          labelText: 'λλ€μμ μλ ₯νμΈμ',)),
                ),
                _nicknamevalue != true
                              ? Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      checknicknameDuplicate(
                                          nicknameController.text);
                                    },
                                    child: Text('μ€λ³΅νμΈ'),
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
          child: Text("μ·¨μ")),
          TextButton(
            onPressed: (){
              if (_nicknamevalue == false) {
                  _showDialog('λλ€μ μ€λ³΅νμΈμ μλ£ν΄μ£ΌμΈμ.');
              }
              else{    
                print('μΈν :${nicknameController.text}');
                nicknameController.text !="" ?updateNickname(context):background=0;
              }
            },
            child: Text("νμΈ")
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
              child: new Text("νμΈ"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

    //λλ€μμμ μμ²­
  void updateNickname(context) async{
    print('λλ€μμμ μμ²­');
    
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
      print('λλ€μ μ€ν¨ν¨ν¨ν¨ν¨ν¨γν');
      print(response.statusCode);
      _fail_nickname=true;
    }
  }

  Future checknicknameDuplicate(String nickname) async {
    var dio = Dio();
    final response =
        await dio.post('http://k7a108.p.ssafy.io:8080/auth/nickname/$nickname');

    if (response.data == true) {
      _showDialog('μ΄λ―Έ μ¬μ© μ€μΈ λλ€μμλλ€.');
    } else {
      setState(() {
        _nicknamevalue = !_nicknamevalue;
      });
    }
  }
}