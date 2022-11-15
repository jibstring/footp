import 'dart:async';
import 'dart:math';
import 'dart:collection';
import 'dart:io';
import 'dart:convert';

import 'package:app_footp/components/msgFoot/normalFoot.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:vector_math/vector_math.dart' as vect;
import 'package:http/http.dart' as http;
import 'package:app_footp/mainMap.dart';

class newMyFootPage extends StatefulWidget {
  var _jsonData = {};

  newMyFootPage(this._jsonData, {Key? key}) : super(key: key);
  @override
  State<newMyFootPage> createState() => newMyFootPageState();
}

class newMyFootPageState extends State<newMyFootPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<NaverMapController> _controller = Completer();
  //dynamic _mycontroller;
  List<dynamic> _myfootData = [];
  int _messagelen = 0;
  String markerString = '';
  List<OverlayImage> _footImage = [];
  List<Marker> markers = [];

  void readFile() {
    // print("여기여이거ㅏ이거ㅣㅑㅕㄱ이겨 myFootData");
    // print(widget._jsonData);

    try {
      _messagelen = widget._jsonData["message"].length;
    } catch (e) {
      _messagelen = 0;
    }

    markers.clear();

    for (int i = 0; i < _messagelen; i++) {
      if (_myfootData.length <= i) {
        _myfootData.add(widget._jsonData["message"][i]);
      } else {
        _myfootData[i] = widget._jsonData["message"][i];
      }
    }
  }

  String changeDate(String date) {
    String newDate = "";
    newDate = date.replaceAll('T', "  ");

    return newDate;
  }
  // 목록
  @override
  Widget build(BuildContext context) {
    _getImage();
    readFile();
    return SizedBox.expand(
      child: Container(
            color: Colors.white,
            child: ListView.builder(
                itemCount: _messagelen + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= _messagelen) {
                    return Container(color: Colors.white, height: 60);
                  } else {
                    return NormalFoot(_myfootData[index]);
                  }
                })),

    );
  }

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
    maindata.setmycontroller = controller;
  }

  void _getImage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OverlayImage.fromAssetImage(
        assetName: 'imgs/blue_print.png',
      ).then((image) {
        if (mounted) setState(() => _footImage.add(image));
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/golden_print.png',
      ).then((image) {
        if (mounted) setState(() => _footImage.add(image));
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/orange_print.png',
      ).then((image) {
        if (mounted) setState(() => _footImage.add(image));
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/white_print.png',
      ).then((image) {
        if (mounted) setState(() => _footImage.add(image));
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/gray_print.png',
      ).then((image) {
        if (mounted) setState(() => _footImage.add(image));
      });
    });
  }
}
