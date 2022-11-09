import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:app_footp/components/msgFoot/reportModal.dart';
import 'package:app_footp/custom_class/store_class/store.dart';

const serverUrl='http://k7a108.p.ssafy.io:8080/foot';

class NormalFoot extends StatefulWidget {
  Map<String, dynamic> normalmsg;
  NormalFoot(this.normalmsg, {Key? key}) : super(key: key);

  @override
  State<NormalFoot> createState() => _NormalFootState();
}

class _NormalFootState extends State<NormalFoot> {
  @override
  int heartnum = 0;

  List<String> heartList = ["imgs/heart_empty.png", "imgs/heart_color.png"];
  final controller = Get.put(UserData());

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.62;
    widget.normalmsg["isMylike"] ? heartnum = 1 : heartnum = 0;
    heartCheck();
    //VideoPlayerController _controller;
    // print("메시지 정보보보보");
    // print(widget.normalmsg);
    AudioPlayer player = new AudioPlayer();

    return Card(
        child: Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width:MediaQuery.of(context).size.width*0.5,
                child: Text(
                  widget.normalmsg["userNickname"],
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
              SizedBox(
                width:MediaQuery.of(context).size.width*0.33,
                child: Text(
                  widget.normalmsg["messageWritedate"],
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          //중간
          Container(
              child: (widget.normalmsg["messageFileurl"] != 'empty')
                  ? Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child:((){
                            int flag=fileCheck(widget.normalmsg["messageFileurl"]);
                            if(flag==0){
                              Image.network(widget.normalmsg["messageFileurl"]);
                            }
                            else if(flag==1){
                              //VideoPlayerController.network(widget.normalmsg["messageFileurl"]);
                            }
                            else if(flag==2){
                              //player.play(widget.normalmsg["messageFileurl"]);
                            }
                            
                          })(),
                              
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            width: width,
                            child: Text(
                              widget.normalmsg["messageText"], //100자로 제한
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ))
                      ],
                    )
                  : Row(
                      children: [
                        Container(
                          height: 100,
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            widget.normalmsg["messageText"], //100자로 제한
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        )
                      ],
                    )),
          //하단
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ReportModal(
                            widget.normalmsg["messageId"], controller.userinfo["userId"]);
                      });
                },
                icon: Icon(Icons.more_horiz, size: 30),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Row(children: [
                  InkWell(
                      child: Image.asset(
                        heartList[heartnum],
                        width: 30,
                        height: 30,
                      ),
                      onTap: () {
                        heartChange();
                      }),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 40,
                    //height:30,
                    child: Text(
                      widget.normalmsg["messageLikenum"].toString(),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  )
                ]),
              )
            ],
          )
        ],
      ),
    ));
  }
  int fileCheck(String file){
    //이미지 0 영상 1 음성 2

    print("########파일체크크#####");
    print(file);

    if(file.endsWith('jpg')){
      return 0;
    }
    else if(file.endsWith('mp4')){
      return 1;
    }
    else if(file.endsWith('m4a')){
      return 2;
    }
    return -1;
  }

  void heartRequest(context,var heartInfo) async{
        final uri=Uri.parse(serverUrl+"/"+heartInfo+"/"+widget.normalmsg["messageId"].toString()+"/"+'${controller.userinfo["userId"]}'.toString());

        print("하트하트하트하트");
        print(uri);
        
        http.Response response;

        if(heartInfo=="like"){
          response=await http.post(
          uri );
        }else{
          response=await http.delete(
          uri);
        }

        if(response.statusCode==200){
          var decodedData=jsonDecode(response.body);
          print(decodedData);
        }
        else{
          print('실패패패패패패ㅐ퍂');
          print(response.statusCode);
        }

    }

    void heartCheck(){
        if(widget.normalmsg["isMylike"] == false){
          heartnum=0;
        }
        else{
          heartnum=1;
        }   
    }

  void heartChange() {
    setState(() {
      var heartInfo="";
      if (heartnum==0) {
        heartnum = 1;
        widget.normalmsg["isMylike"] = true;
        widget.normalmsg["messageLikenum"] =
            widget.normalmsg["messageLikenum"] + 1;
        heartInfo="like";
      } else {
        heartnum = 0;
        widget.normalmsg["isMylike"] = false;
        widget.normalmsg["messageLikenum"] =
            widget.normalmsg["messageLikenum"] - 1;
        heartInfo="unlike";
      }
      heartRequest(context,heartInfo);

    });
  }
}
