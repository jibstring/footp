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
  var eventId = 0;  //참가하려는 이벤트의 아이디
  var userId = 0;   //나의 유저 아이디
  String userNickName = "";   //나의 유저 닉네임
  var chatList = List<Chat>.empty(growable: true);    //채팅 리스트
  StompClient stompClient = StompClient(config: StompConfig.SockJS(url: 'http://localhost:8080/ws'));
  ChatRoom(this.eventId, this.userId, this.userNickName, {Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  //소켓 연결
  

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
    if(widget.eventId <= 0) { //이벤트 아이디가 유효하지 않은 경우
      Chat chat = Chat(widget.userId, "이벤트 목록에서 실시간 채팅에 참여해보세요.", widget.userNickName, ".");
      widget.chatList.add(chat);
    }else {
      print("구독 시작");
      //해당이벤트의 채팅 구독
      widget.stompClient = StompClient(
        config: StompConfig.SockJS(
          url: 'http://localhost:8080/ws',
          onConnect: (StompFrame frame) {
            print("소켓 연결 시도 : " + widget.eventId.toString());
            widget.stompClient.subscribe(
              destination: '/app/${widget.eventId}',
              callback: (frame) {
                print("성공!");
              }
            );
            widget.chatList.add(Chat(widget.userId, "실시간 채팅에 입장하였습니다", widget.userNickName, "."));
          }
        )
      );
      widget.stompClient.activate();
    }// end of if 소켓 연결
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