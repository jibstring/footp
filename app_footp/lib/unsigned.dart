import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:app_footp/signIn.dart';
import 'package:app_footp/custom_class/store_class/store.dart';

class Unsigned extends StatefulWidget {
  const Unsigned({super.key});

  @override
  State<Unsigned> createState() => _UnsignedState();
}

class _UnsignedState extends State<Unsigned> {
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          bool result = onWillPop();
          return await Future.value(result);
        },
        child: Scaffold(
          body: SizedBox.expand(
              child: ListView(
            children: <Widget>[
              Center(
                  child: Container(
                padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: Text(
                  "회원 탈퇴가 완료되었습니다.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              )),
              Center(
                  child: Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text(
                  "앞으로도 더욱 노력하는 푸프가 되겠습니다.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              )),
              Center(
                  child: Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text(
                  "지금까지 푸프를 이용해주셔서 감사합니다!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ))
            ],
          )),
        ));
  }

  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "뒤로가기 버튼을 한번 더 누르면 종료됩니다.",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xff6E6E6E),
          fontSize: 11,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    SystemNavigator.pop();
    return true;
  }
}
