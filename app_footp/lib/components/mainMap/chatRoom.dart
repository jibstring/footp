import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:app_footp/custom_class/chat_class/chat.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../../custom_class/chat_class/stomp.dart';

class ChatRoom extends StatefulWidget {
  var eventId = 0;  //참가하려는 이벤트의 아이디
  var userId = 0;   //나의 유저 아이디
  String userNickName = "";   //나의 유저 닉네임
  var chatList = List<Chat>.empty(growable: true);    //채팅 리스트
  ChatRoom(this.eventId, this.userId, this.userNickName, {Key? key}) : super(key: key);
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  //채팅 메시지를 만드는 함수(자신의 메시지는 파란색, 다른사람의 메시지는 검정색)
  Text mkText(Chat chat) {
    if (chat.userId == widget.userId) {
      return Text(
        chat.userNickName + " " + chat.time + "\n" + chat.msg,
        style: TextStyle(color: Colors.blue[900]),
      );
    } else {
      return Text(
        chat.userNickName + " " + chat.time + "\n" + chat.msg,
        style: TextStyle(color: Colors.black),
      );
    }
  } // end of function mkText

  @override
  void initState() {
    if(widget.eventId <= 0) { //이벤트 아이디가 유효하지 않은 경우
      // widget.chatList.clear();
      Chat chat = Chat(widget.userId, "이벤트 목록에서 실시간 채팅에 참여해보세요.", widget.userNickName, ".");
      widget.chatList.add(chat);
    }else {
        print('스톰프 시작');
        stomp.sub(widget.eventId);
        // Chat chat = Chat(widget.userId, "이벤트 목록에서 실시간 채팅에 참여해보세요.", widget.userNickName, ".");
        // widget.chatList.add(chat);
    }// end of if 소켓 연결
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
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
              title: mkText(widget.chatList[index]),
            );
          },          
        );
      },
    );
  }
}
