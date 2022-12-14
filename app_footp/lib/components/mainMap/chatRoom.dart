import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:app_footp/custom_class/chat_class/msg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:app_footp/mainMap.dart';

class ChatRoom extends StatefulWidget {
  var eventId = 0; //참가하려는 이벤트의 아이디
  var userId = 0; //나의 유저 아이디
  String userNickName = ""; //나의 유저 닉네임
  String category = ""; //카테고리
  late StompClient stompClient;
  bool con = false;
  var chatList = List<Msg>.empty(growable: true); //채팅 리스트
  final textController = TextEditingController();
  FocusNode myFocus = FocusNode();
  ChatRoom(this.eventId, this.userId, this.userNickName, this.category,
      {Key? key})
      : super(key: key);
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  //채팅 메시지를 만드는 함수(자신의 메시지는 파란색, 다른사람의 메시지는 검정색)
  ListTile mkTile(Msg msg) {
    Color tileColor = Colors.black;
    String img = "프로필_g.png";
    if (msg.userId == widget.userId) {
      tileColor = Colors.blue;
      img = "프로필_b.png";
    }
    return ListTile(
      tileColor: tileColor,
      leading: Image.asset(
        "./imgs/$img",
        fit: BoxFit.cover,
      ),
      title: Text(msg.chat),
      subtitle: Text("${msg.userNickName} ${msg.now}"),
    );
  }

  @override
  void initState() {
    if (widget.eventId <= 0) {
      //이벤트 아이디가 유효하지 않은 경우
      // widget.chatList.clear();
      print("유효하지 않은 이벤트");
      widget.chatList.clear();
      Msg msg = Msg(widget.eventId, widget.userId, "이벤트 목록에서 실시간 채팅에 참여해보세요.",
          widget.userNickName, ".");
      widget.chatList.add(msg);
      setState(() {});
    } else if (!widget.con) {
      widget.stompClient = StompClient(
          config: StompConfig.SockJS(
        url: 'http://k7a108.p.ssafy.io:8080/wss',
        beforeConnect: () async {
          print("소켓 연결중");
        },
        onConnect: (p0) async {
          print("연결완료");
          widget.chatList.clear();
          widget.chatList.add(Msg(widget.eventId, widget.userId,
              "채팅방에 입장하였습니다.", widget.userNickName, "."));
          widget.con = true;
          setState(() {});
          widget.stompClient.subscribe(
            destination: '/topic/${widget.eventId}',
            callback: (frame) {
              Map<String, dynamic> msgMap = jsonDecode(frame.body.toString());
              var msg = Msg.fromJson(msgMap);
              widget.chatList.add(Msg(msg.eventId, msg.userId, msg.chat,
                  msg.userNickName, msg.now));
              setState(() {});
            },
          );
        },
      ));
    } // end of if 소켓 연결
    super.initState();
  }

  void showToast(String str) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: str,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.redAccent,
      fontSize: 20.0,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  Future<void> sendMsg(String str) async {
    if (widget.con && widget.stompClient.connected && str.trim() != "") {
      widget.stompClient.send(
          destination: '/app/send',
          body: jsonEncode(Msg(
              widget.eventId, widget.userId, str, widget.userNickName, "")));
      widget.textController.clear();
      widget.myFocus.requestFocus();
    } else {
      showToast(str.trim() == "" ? '빈 메시지는 보낼 수 없습니다.' : '채팅방 연결을 확인하세요.');
    }
    setState(() {});
  }

  void exitRoom(BuildContext pcontext) {
    if (widget.con && widget.stompClient.isActive) {
      widget.stompClient.deactivate();
      widget.chatList.add(Msg(widget.eventId, widget.userId, "채팅방에서 나왔습니다.",
          widget.userNickName, "."));
      widget.con = false;
      widget.eventId = 0;
      setState(() {});
    } else {
      showToast("채팅방에 연결되어있지 않습니다.");
      maindata.setAttendChat = false;
      pcontext.findAncestorStateOfType()?.setState(() {});
    }
  }

  void exitAlert(BuildContext pcontext) {
    if (widget.eventId == 0) {
      return exitRoom(pcontext);
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Column(
              children: const <Widget>[
                Text("채팅방에서 나가시겠습니까?"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  "채팅 기록은 저장되지 않습니다.",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("확인"),
                onPressed: () {
                  exitRoom(pcontext);
                  Navigator.pop(context);
                  maindata.setAttendChat = false;
                  pcontext.findAncestorStateOfType()?.setState(() {});
                },
              ),
              TextButton(
                child: const Text("취소"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Color color() {
    if (widget.con) return Colors.yellow.shade100;
    return Colors.white;
  }

  @override
  Widget build(BuildContext pcontext) {
    if (widget.eventId > 0) {
      widget.stompClient.activate();
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 1,
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: color(),
          child: ListView.builder(
            controller: scrollController,
            itemCount: widget.chatList.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                String temp = "";
                if (widget.eventId == 0) {
                  temp = "    채팅방에 연결되어 있지 않습니다.";
                } else {
                  temp = "    # ${widget.category} 채팅방에 참가중입니다.";
                }
                return Container(
                    color: Colors.grey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              temp,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            )),
                        IconButton(
                          iconSize: 40,
                          onPressed: () => {exitAlert(pcontext)},
                          icon: Image.asset(
                            "./imgs/채팅나가기.png",
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ));
              } else if (index == 1) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                          color: Colors.white,
                          height: 50,
                          child: TextField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '채팅을 입력하세요.'),
                              focusNode: widget.myFocus,
                              controller: widget.textController,
                              onSubmitted: (str) => setState(() {
                                    sendMsg(str);
                                  })),
                        )),
                    IconButton(
                        onPressed: () => setState(() {
                              sendMsg(widget.textController.text);
                            }),
                        iconSize: 40,
                        icon: Image.asset(
                          "./imgs/채팅전송.png",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        )),
                  ],
                );
              } else {
                return Container(
                  padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                  margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: mkTile(
                      widget.chatList[widget.chatList.length - index + 1]),
                );
              }
            },
          ),
        );
      },
    );
  }
}
