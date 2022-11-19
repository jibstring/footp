import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import 'package:app_footp/signIn.dart';
import 'package:app_footp/mainMap.dart';
import 'package:app_footp/components/mainMap/footList.dart' as footlist;
import 'package:app_footp/components/msgFoot/reportModal.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:app_footp/components/userSetting/myFoot.dart';
import 'package:app_footp/components/mainMap/chatRoom.dart';


const serverUrl = 'http://k7a108.p.ssafy.io:8080/';

class EventFoot extends StatefulWidget {
  Map<String, dynamic> gathermsg;
  EventFoot(this.gathermsg, {Key? key}) : super(key: key);

  @override
  State<EventFoot> createState() => _EventFootState();
}

class _EventFootState extends State<EventFoot> {
  @override
  int heartnum = 0;

  late VideoPlayerController _videocontroller;

  late Future<void> _initializeVideoPlayerFuture;

  List<String> heartList = ["imgs/heart_empty.png", "imgs/heart_color.png"];
  UserData user = Get.put(UserData());

  bool click_play = false;
  final _player = AudioPlayer();
  List<String> _category=['공연','행사','맛집','관광','친목'];
  List<Color> _colorSelect=[Color.fromARGB(255, 190, 223, 178),Color.fromARGB(255, 255, 234, 246),Color.fromARGB(255, 164, 185, 237),Color.fromARGB(255, 182, 114, 205),Color.fromARGB(255, 252, 169, 45),Color.fromARGB(255, 20, 98, 186)];


  void initState() {
    _videocontroller = VideoPlayerController.network(
      widget.gathermsg["gatherFileurl"],
    );

    _initializeVideoPlayerFuture = _videocontroller.initialize();

    super.initState();
  }

  void dispose() {
    _videocontroller.dispose();
    super.dispose();
  }

  Widget build(BuildContext pcontext) {
    //VideoPlayerController _videocontroller;
    footlist.ListMaker listmaker = footlist.listmaker;
    MyFootPageState myfoot;

    double width = MediaQuery.of(context).size.width * 0.62;
    widget.gathermsg["isMylike"] ? heartnum = 1 : heartnum = 0;
    heartCheck();

    // print("메시지 정보보보보");
    // print(widget.gathermsg);

    //AudioPlayer player = new AudioPlayer();

    return GestureDetector(
        onTap: () {
          maindata.moveMapToMessage(widget.gathermsg["gatherLatitude"],
              widget.gathermsg["gatherLongitude"]);
          // listmaker.listcontroller.reset();
          listmaker.refresh();
        },
        child: Card(
            child: Container(
              
              // height: 40,
                    decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 3),
                                    borderRadius: BorderRadius.circular(20),
                                    ),
              
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Text("# ${_category[widget.gathermsg["gatherDesigncode"]]}"),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      widget.gathermsg["userNickname"],
                      style: const TextStyle(
                          fontSize:20,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 110, 110, 110)),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      changeDate(widget.gathermsg["gatherWritedate"]),
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 110, 110, 110)),
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.black, thickness: 3.0),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 9, 0),
                alignment: Alignment.centerRight,
                child: Text("종료시간 :  "+changeDate(widget.gathermsg["gatherFinishdate"]),
                  style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 43, 55, 123))),
              ),
              SizedBox(
                height: 10,
              ),
              //중간
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 15, 0),
                  child: (widget.gathermsg["gatherFileurl"] != 'empty')
                      ? Row(
                          children: [
                            fileCheck(widget.gathermsg["gatherFileurl"]) != -1
                                ? SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.3,
                                    height: MediaQuery.of(context).size.width * 0.3,
                                    child: (() {
                                      int flag = fileCheck(
                                          widget.gathermsg["gatherFileurl"]);
                                      if (flag == 0) {
                                        //이미지
                                        return Image.network(
                                            widget.gathermsg["gatherFileurl"]);
                                      } else if (flag == 1) {
                                        //비디오
                                        // print("비디오");
                                        // print(_videocontroller);
                                        return FutureBuilder(
                                            future:
                                                _initializeVideoPlayerFuture,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                return AspectRatio(
                                                  aspectRatio: _videocontroller
                                                      .value.aspectRatio,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        print(_videocontroller
                                                            .value.isPlaying);
                                                        if (_videocontroller
                                                            .value.isPlaying) {
                                                          print("중지");
                                                          _videocontroller
                                                              .pause();
                                                        } else {
                                                          print("시작");
                                                          print(
                                                              _videocontroller);
                                                          _videocontroller
                                                              .play();
                                                        }
                                                      });
                                                    },
                                                    child: VideoPlayer(
                                                        _videocontroller),
                                                  ),
                                                );
                                              } else {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                            });
                                      } else if (flag == 2) {
                                        //오디오
                                        return click_play == false
                                            ? IconButton(
                                                icon: Icon(Icons.play_arrow,
                                                    size: 30),
                                                onPressed: () {
                                                  _player.stop();
                                                  // print("재생!!");

                                                  click_play = true;
                                                  _player.setUrl(
                                                      widget.gathermsg[
                                                          "gatherFileurl"]);
                                                  _player.play();

                                                  print(click_play);
                                                },
                                              )
                                            : IconButton(
                                                icon:
                                                    Icon(Icons.pause, size: 30),
                                                onPressed: () {
                                                  _player.stop();
                                                  // print("멈춰!!");
                                                  click_play = false;
                                                  print(click_play);
                                                },
                                              );
                                      }
                                    })(),
                                  )
                                : Text(""),
                            Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  widget.gathermsg["gatherText"], //100자로 제한
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 110, 110, 110)),
                                ))
                          ],
                        )
                      : Container(
                        // height: 100,
                        alignment: Alignment.centerLeft,
                        // padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                        child: Text(
                          widget.gathermsg["gatherText"], //100자로 제한
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 110, 110, 110)),
                        ),
                      )),
              SizedBox(height:20),         // 주소
              Container(
                  height: 30,
                  // padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  //width: width,
                  child: Text(
                    maindata.address[widget.gathermsg["gatherId"]] ??= "",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 110, 110, 110)),
                  )),
              //하단
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (!user.isLogin()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignIn()),
                        );
                      } else {
                         showDialog(
                            context: context,
                            builder: (context) {
                              return widget.gathermsg["userNickname"]==user.userinfo["userNickname"]?
                          AlertDialog(
                            title:Text("확성기 삭제하기"),
                            content:SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('삭제하시겠습니까??')
                                ]),
                              ),
                              actions:<Widget>[
                                TextButton(
                                  onPressed: (){
                                    deleteGather(widget.gathermsg["gatherId"]);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("삭제")
                                ),
                                TextButton(onPressed: (){
                                  Navigator.of(context).pop();
                                  },
                                child: Text("취소"))
                                ]
                          ):
                            ReportModal(widget.gathermsg["gatherId"],
                                  user.userinfo["userId"]);
                            });
                      }
                    },
                    icon: Icon(Icons.more_horiz, size: 30),
                  ),
                  // Text("# ${_category[widget.gathermsg["gatherDesigncode"]]}",style: const TextStyle(
                  //         fontSize: 15,
                  //         fontWeight: FontWeight.w500,
                  //         color: Color.fromARGB(255, 110, 110, 110))
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 3),
                                    borderRadius: BorderRadius.circular(20),
                                    ),
                    child: ElevatedButton(
                                    style: ButtonStyle(
                                      foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                          _colorSelect[widget.gathermsg["gatherDesigncode"]]),
                                      shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius:
                                        BorderRadius.circular(20.0),
                                      )),
                                    ),
                                    onPressed: () {  },
                                    child: Text("# ${_category[widget.gathermsg["gatherDesigncode"]]}",
                                    style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      ),
                  ),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 3),
                                    borderRadius: BorderRadius.circular(20),
                                    ),
                    child: ElevatedButton(style: ButtonStyle(
                                      foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 206, 233, 255)),
                                      shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius:
                                        BorderRadius.circular(20.0),
                                      )),
                                    ),
                      onPressed: (){
                        setState(() {});
                        if (!user.isLogin()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignIn()),
                          );
                        }
                        else{
                          maindata.setChatRoom=ChatRoom(widget.gathermsg["gatherId"],user.userinfo["userId"],user.userinfo["userNickname"]);
                          maindata.setAttendChat=true;
                          pcontext.findAncestorStateOfType()?.context.findAncestorStateOfType()?.context.findAncestorStateOfType()?.context.findAncestorStateOfType()?.context.findAncestorStateOfType()?.context.findAncestorStateOfType()?.context.findAncestorStateOfType()?.setState(() {});
                        }

                      },
                      child: Text("채팅방참가", style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),),
                  )
                  ,
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Row(children: [
                      InkWell(
                          child: Image.asset(
                            heartList[heartnum],
                            width: 30,
                            height: 30,
                          ),
                          onTap: () {
                            if (!user.isLogin()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignIn()),
                              );
                            } else {
                              heartChange();
                            }
                          }),
                      SizedBox(width: 10),
                      SizedBox(
                        width: 40,
                        //height:30,
                        child: Text(
                          widget.gathermsg["gatherLikenum"].toString(),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      )
                    ]),
                  )
                ],
              )
            ],
          ),
        )));
  }

  int fileCheck(String file) {
    //이미지 0 영상 1 음성 2
    // print("########파일체크크#####");
    // print(file);

    if (file.endsWith('jpg')) {
      return 0;
    } else if (file.endsWith('mp4')) {
      return 1;
    } else if (file.endsWith('mp3')) {
      return 2;
    }
    return -1;
  }

  String changeDate(String date) {
    String newDate = "";

    newDate = date.replaceAll('T', "  ");

    return newDate;
  }
  void heartRequest(context, var heartInfo) async {
    final uri = Uri.parse(serverUrl +
        "gather/" +
        heartInfo +
        "/" +
        widget.gathermsg["gatherId"].toString() +
        "/" +
        '${user.userinfo["userId"]}'.toString());

    print("하트하트하트하트");
    print(uri);

    http.Response response;

    if (heartInfo == "like") {
      response = await http.post(uri);
    } else {
      response = await http.delete(uri);
    }

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      print(decodedData);
    } else {
      print(response.statusCode);
    }
  }

  void heartCheck() {
    if (widget.gathermsg["isMylike"] == false) {
      heartnum = 0;
    } else {
      heartnum = 1;
    }
  }

  void heartChange() {
    setState(() {
      var heartInfo = "";
      if (heartnum == 0) {
        heartnum = 1;
        widget.gathermsg["isMylike"] = true;
        widget.gathermsg["gatherLikenum"] =
            widget.gathermsg["gatherLikenum"] + 1;
        heartInfo = "like";
      } else {
        heartnum = 0;
        widget.gathermsg["isMylike"] = false;
        widget.gathermsg["gatherLikenum"] =
            widget.gathermsg["gatherLikenum"] - 1;
        heartInfo = "unlike";
      }
      heartRequest(context, heartInfo);
    });
  }
  void deleteGather(int gatherId)async{
   
    final uri=Uri.parse(serverUrl+'user/gather/'+'$gatherId');

    print("확성기 삭제");
    print(uri);
    http.Response response=await http.delete(
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
    }
  }
}
