import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const serverUrl='http://k7a108.p.ssafy.io:8080/foot';


class ReportModal extends StatelessWidget {
  int msgId;
  int userId;
  ReportModal(this.msgId,this.userId,{Key? key}):super(key:key);

  void reportSpam(context) async{
  final uri=Uri.parse(serverUrl+'/spam/'+'$msgId'+"/"+'$userId');
  http.Response response=await http.post(
    uri
  );
  print(uri);
  if(response.statusCode==200){
    var decodedData=jsonDecode(response.body);
    print(decodedData);
  }
  else{
    print('실패패패패패패ㅐ퍂');
    print(response.statusCode);

    throw 'sendReport() error';
  }
}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:Text("신고하기"),
      content:SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('신고하시겠습니까?')
          ]),
        ),
        actions:<Widget>[
          TextButton(
            
            onPressed: (){
              reportSpam(context);
              Navigator.of(context).pop();
            },
            child: Text("신고")
          ),
          TextButton(onPressed: (){
            Navigator.of(context).pop();
            },
          child: Text("취소"))
          ]
    );
  }
}