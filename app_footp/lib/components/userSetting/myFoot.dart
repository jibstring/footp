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


class MyFootPage extends StatefulWidget {
  var _jsonData = {};
  
  MyFootPage(this._jsonData,{Key? key}) : super(key: key);
  @override
  State<MyFootPage> createState() => MyFootPageState();
}

class MyFootPageState extends State<MyFootPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<NaverMapController> _controller = Completer();
  //dynamic _mycontroller;
  List<dynamic> _myfootData = [];
  int _messagelen = 0;
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
      createMarker(i);
    }
  }

  void createMarker(int idx) {
    int like = widget._jsonData["message"][idx]["messageLikenum"];
    int color = 0;

    if (like >= 95) {
      like = 94;
    }

    if (widget._jsonData["message"][idx]["isBlurred"] == true) {
      color = 4;
    } else {
      switch (widget._jsonData["message"][idx]["messageId"] % 4) {
        case 0:
          color = 0;
          break;
        case 1:
          color = 1;
          break;
        case 2:
          color = 2;
          break;
        case 3:
          color = 3;
          break;
        default:
          color = 0;
      }
    }

    Marker marker = Marker(
        markerId: widget._jsonData["message"][idx]["messageId"].toString(),
        position: LatLng(widget._jsonData["message"][idx]["messageLatitude"],
            widget._jsonData["message"][idx]["messageLongitude"]),
        icon: _footImage[color],
        width: 5 * (6 + like),
        height: 5 * (6 + like),
        onMarkerTab: (marker, iconSize) {
          print("Hi ${widget._jsonData["message"][idx]["messageId"]}");
        },
        infoWindow: widget._jsonData["message"][idx]["messageText"]);

    markers.add(marker);
    // update();
  }

  // void moveMapToMessage(double lat, double lng) {
  //   CameraPosition cameraPosition =
  //       CameraPosition(target: LatLng(lat, lng), zoom: 18.0);
  //   _mycontroller.moveCamera(CameraUpdate.toCameraPosition(cameraPosition));
  //   // update();
  // }

  // 목록
  @override
  Widget build(BuildContext context) {
    _getImage();
    readFile();
    return SizedBox.expand(
          child: Stack(children: <Widget>[
        Container(
            height: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top) *
                0.65,
            child: NaverMap(
                onMapCreated: onMapCreated,
                //onCameraIdle: getMapEdge,
                minZoom: 5.0,
                markers: markers,
                )),
        DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 1,
      snap: true,
      // controller: listmaker.listcontroller,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            color: Colors.white,
            child: ListView.builder(
                controller: scrollController,
                itemCount: _messagelen,
                itemBuilder: (BuildContext context, int index) {
                  if (index < _messagelen) {
                    return NormalFoot(_myfootData[index]);
                  } else {  
                    return Container(color: Colors.white, height: 60);
                  }
                }));
      },
    ),
      ]));
  }


  void onMapCreated(NaverMapController controller) {

    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
    maindata.setmycontroller =controller;
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
