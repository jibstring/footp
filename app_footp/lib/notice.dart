import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:app_footp/mainMap.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

Notice notice = Notice();

class Notice extends GetxController {
  late StompClient stompClient;
  late MainData maindata;

  Notice() {
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: "http://k7a108.p.ssafy.io:8080/wss",
        beforeConnect: () async {
          print("알리미 연결중");
        },
        onConnect: (p0) async {
          print("알리미 연결 완료");
          stompClient.subscribe(
              destination: '/notice',
              callback: (frame) {
                Map<String, dynamic> msgMap = jsonDecode(frame.body.toString());
                showToast(msgMap);
              });
        },
      ),
    );
    stompClient.activate();
  }

  Future<void> send(Map<dynamic, dynamic> map) async {
    HapticFeedback.lightImpact();
    if (stompClient.connected) {
      stompClient.send(
        destination: "/app/notice",
        body: jsonEncode(map),
      );
    }
  }

  void showToast(Map<String, dynamic> map) {
    print("999999999999999999999");
    String str = "${map["userId"]} : ${map["gatherText"]}";
    Fluttertoast.showToast(
      msg: str,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.red,
      fontSize: 20.0,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
