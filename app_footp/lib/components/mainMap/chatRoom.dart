import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:app_footp/custom_class/chat_class/msg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

class ChatRoom extends StatefulWidget {
  var eventId = 0;  //참가하려는 이벤트의 아이디
  var userId = 0;   //나의 유저 아이디
  String userNickName = "";   //나의 유저 닉네임
  late StompClient stompClient;
  bool con = false;
  var chatList = List<Msg>.empty(growable: true);    //채팅 리스트
  final textController = TextEditingController();
  ChatRoom(this.eventId, this.userId, this.userNickName, {Key? key}) : super(key: key);
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  //채팅 메시지를 만드는 함수(자신의 메시지는 파란색, 다른사람의 메시지는 검정색)
  Text mkText(Msg msg) {
    if (msg.userId == widget.userId) {
      return Text(
        "${msg.userNickName} ${msg.now}\n${msg.chat}",
        style: TextStyle(color: Colors.blue[900]),
      );
    } else {
      return Text(
        "${msg.userNickName} ${msg.now}\n${msg.chat}",
        style: TextStyle(color: Colors.black),
      );
    }
  } // end of function mkText

  @override
  void initState() {
    if(widget.eventId <= 0) { //이벤트 아이디가 유효하지 않은 경우
      // widget.chatList.clear();
      print("유효하지 않은 이벤트");
      widget.chatList.clear();
      Msg msg= Msg(widget.eventId, widget.userId, "이벤트 목록에서 실시간 채팅에 참여해보세요.", widget.userNickName, ".");
      widget.chatList.add(msg);
      setState(() {});
    }
    else if(!widget.con){
      widget.stompClient = StompClient(
        config: StompConfig.SockJS(
          url: 'http://k7a108.p.ssafy.io:8080/wss',
          beforeConnect: () async{
            print("소켓 연결중");
          },
          onConnect: (p0) async{
            print("연결완료");
            widget.chatList.clear();
            widget.chatList.add(Msg(widget.eventId, widget.userId, "채팅방에 입장하였습니다.", widget.userNickName, "."));
            widget.con = true;
            setState(() {});
            widget.stompClient.subscribe(
              destination: '/topic/${widget.eventId}',
              callback: (frame) {
                Map<String, dynamic> msgMap = jsonDecode(frame.body.toString());
                var msg = Msg.fromJson(msgMap);
                widget.chatList.add(Msg(msg.eventId, msg.userId, msg.chat, msg.userNickName, msg.now));
                setState(() {});
              },
            );
          },
        )
      );
    }// end of if 소켓 연결
    super.initState();
  }

  void showToast(String str) {
    Fluttertoast.showToast(msg: str,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.redAccent,
        fontSize: 20.0,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT
      ); 
  }

  void sendMsg(String str) {
    if(widget.con && widget.stompClient.connected && str.trim() != "") {
      widget.textController.text = "";
      widget.stompClient.send(
        destination: '/app/send',
        body: jsonEncode(Msg(widget.eventId, widget.userId, str, widget.userNickName, ""))
      );
    }else {
      showToast(str.trim()==""? '빈 메시지는 보낼 수 없습니다.':'채팅방 연결을 확인하세요.');
    }
    setState(() {});
  }

  void exitRoom() {
    if(widget.con && widget.stompClient.isActive) {
      widget.stompClient.deactivate();
      widget.chatList.add(Msg(widget.eventId, widget.userId, "채팅방에서 나왔습니다.", widget.userNickName, "."));
      widget.con = false;
      widget.eventId = 0;
      setState(() {});
    }else {
      showToast("채팅방에 연결되어있지 않습니다.");
    }
  }

  Color color() {
    if(widget.con) return Colors.lightGreenAccent;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.eventId > 0) {
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
          child: 
            ListView.builder(
            controller: scrollController,
            itemCount: widget.chatList.length+1,
            itemBuilder: (context, index) {
              if(index == 0) {
                return Flexible(
                  child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          color: Colors.lightBlueAccent,
                          child: 
                            TextField(
                              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: '채팅을 입력하세요.'),
                              controller: widget.textController,
                              onSubmitted: (str)=>sendMsg(str),
                            ),
                        ),
                        IconButton(
                          onPressed: ()=>sendMsg(widget.textController.text), 
                          icon: 
                            const Icon(
                              Icons.send,
                              size: 25,
                            )
                        ),
                        IconButton(
                          onPressed: ()=>{exitRoom()}, 
                          icon: const Icon(
                            Icons.exit_to_app,
                            color: Colors.red,
                            size: 25
                            )
                        )
                      ],
                    )
                );
              }
              return ListTile(
                title: mkText(widget.chatList[widget.chatList.length-index]),
              );
            },          
          ),
        );
      },
    );
  }
}
