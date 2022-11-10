import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:app_footp/custom_class/chat_class/msg.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

class ChatRoom extends StatefulWidget {
  var eventId = 0;  //참가하려는 이벤트의 아이디
  var userId = 0;   //나의 유저 아이디
  String userNickName = "";   //나의 유저 닉네임
  late StompClient stompClient;
  bool con = false;
  var chatList = List<Msg>.empty(growable: true);    //채팅 리스트
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
      Msg msg= Msg(widget.eventId, widget.userId, "이벤트 목록에서 실시간 채팅에 참여해보세요.", widget.userNickName, ".");
      widget.chatList.add(msg);
      setState(() {});
    }
    else {
      widget.stompClient = StompClient(
        config: StompConfig.SockJS(
          url: 'http://k7a108.p.ssafy.io/wss',
          beforeConnect: () async{
            print("소켓 연결중");
          },
          onConnect: (p0) async{
            print("연결완료");
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

  void sendMsg(String str) {
    if(widget.con && widget.stompClient.connected) {
      widget.stompClient.send(
        destination: '/app/send',
        body: jsonEncode(Msg(widget.eventId, widget.userId, str, widget.userNickName, ""))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.eventId >= 0) {
      widget.stompClient.activate();
    }
    final textController = TextEditingController();

    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 1,
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return ListView.builder(
          controller: scrollController,
          itemCount: widget.chatList.length+1,
          itemBuilder: (context, index) {
            if(index == 0) {
              return Container(
                height: 40,
                color: Colors.lightBlue,
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.7,
                        height: 35,
                        child: 
                          TextField(
                            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: '채팅을 입력하세요.'),
                            controller: textController,
                          ),
                      ),
                      IconButton(
                        onPressed: ()=>sendMsg(textController.text), 
                        icon: 
                          const Icon(
                            Icons.send,
                            size: 25,
                          )
                      ),
                    ],
                  )
              );
            }
            return ListTile(
              title: mkText(widget.chatList[widget.chatList.length-index]),
            );
          },          
        );
      },
    );
  }
}
