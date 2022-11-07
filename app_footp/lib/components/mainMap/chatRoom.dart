import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:app_footp/chat.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatRoom extends StatefulWidget {
  var eventId = 0;
  var userId = 0;
  String userNickName = "";
  var chatList = new List<Chat>.empty(growable: true);
  //STOMP 웹소켓
  StompClient stompClient = StompClient(config: StompConfig.SockJS(url: 'https://k7a108.p.ssafy.io/ws'));
  ChatRoom(this.eventId, this.userId, this.userNickName, {Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  
  //채팅 메시지를 만드는 함수(자신의 메시지는 파란색, 다른사람의 메시지는 검정색)
  Text mkText(Chat chat) {
    if(chat.userId == widget.userId) {
      return Text(
      chat.userNickName + " " + chat.time + "\n" + chat.msg,
      style: TextStyle(color: Colors.blue[900]),
      );  
    }else {
      return Text(
        chat.userNickName + " " + chat.time + "\n" + chat.msg,
        style: TextStyle(color: Colors.black),
      );
    }
  }// end of function mkText

  @override
  Widget build(BuildContext context) {
    var eventId = widget.eventId;
    var userId = widget.userId;
    String userNickName = widget.userNickName;
    if(eventId == 0) {
      Chat chat = Chat(userId, "이벤트 목록에서 실시간 채팅에 참여해보세요.", userNickName, ".");
      widget.chatList.add(chat);
    }else {
      // widget.stompClient = StompClient(
      //   config: StompConfig.SockJS(url: 'https://k7a108.p.ssafy.io/ws',
      //   onConnect: (StompFrame frame) {
      //     setState(() {});
      //     print("소켓 연결 시도 : " + eventId.toString());
      //     widget.stompClient?.subscribe(destination: "/topic/"+eventId.toString(), callback: (frame) {widget.chatList.add(Chat(frame.body., frame.body.msg, frame.body.userNickName, frame.body.time))})
      //   }
      //   )
      // );
      Chat chat = Chat(userId, "실시간 채팅에 입장하였습니다", userNickName, ".");
      widget.chatList.add(chat);
    }
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: [0.65],
      builder: (BuildContext context, ScrollController scrollController) {
        return ListView.builder(
          itemCount: widget.chatList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title:  mkText(widget.chatList[index]),
            );
          },
        );
      },
    );
  }
}