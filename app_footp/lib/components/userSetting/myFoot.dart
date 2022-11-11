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

import 'package:app_footp/signIn.dart';
import 'package:app_footp/myPage.dart';
import 'package:app_footp/createFoot.dart';
import 'package:app_footp/components/mainMap/footList.dart';
import 'package:app_footp/components/mainMap/stampList.dart';
import 'package:app_footp/components/mainMap/chatRoom.dart';
import 'package:app_footp/custom_class/store_class/store.dart';

class MyFootPage extends StatefulWidget {
  List<Marker> _markers = [];
  MyFootPage(this._markers,{Key? key}) : super(key: key);
  @override
  State<MyFootPage> createState() => _MyFootPageState();
}

class _MyFootPageState extends State<MyFootPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<NaverMapController> _controller = Completer();
  dynamic _mycontroller;

//지도 끝점 구하는거
  // void getMapEdge() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _mycontroller.getVisibleRegion().then((value) {
  //       _mapEdge = value;
  //     });
  //   });
  //   // update();
  // }

  void moveMapToMessage(double lat, double lng) {
    CameraPosition cameraPosition =
        CameraPosition(target: LatLng(lat, lng), zoom: 18.0);
    _mycontroller.moveCamera(CameraUpdate.toCameraPosition(cameraPosition));
    // update();
  }

  // 목록
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
          child: Stack(children: <Widget>[
        Container(
            height: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top) *
                0.65,
            child: NaverMap(
                onMapCreated: _onMapCreated,
                //onCameraIdle: getMapEdge,
                minZoom: 5.0,
                markers: widget._markers,
                )),
        DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.5,
      snap: true,
      // controller: listmaker.listcontroller,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            color: Colors.white,
            child: ListView.builder(
                controller: scrollController,
                itemCount: _gatherlistsize+_messagelistsize+1,
                itemBuilder: (BuildContext context, int index) {
                  if (index < _gatherlistsize+_messagelistsize) {
                    return NormalFoot(_dataList["message"][index]);
                  } else {
                    return Container(color: Colors.white, height: 60);
                  }
                }));
      },
    ),
      ]));
  }


  void _onMapCreated(NaverMapController controller) {
    // if (!user.isLogin()) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => const SignIn()),
    //   );
    // }
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
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

  // void initState() {
  //   _getImage();
  //   super.initState();
  //   Timer.periodic(Duration(seconds: 2), (v) {
  //     if (mounted) {
  //       setState(() {
  //         location.getCurrentLocation();
  //         // aLat, aLng는 임의로 생성한 메세지 위치, aDistance는 현재 위치에서 임의 메세지까지의 거리
  //         // double aLat = 37.5015;
  //         // double aLng = 127.0395;
  //         // double aDistance = (6371 *
  //         //     acos(cos(vect.radians(location.latitude)) *
  //         //             cos(vect.radians(aLat)) *
  //         //             cos(vect.radians(aLng) - vect.radians(location.longitude)) +
  //         //         sin(vect.radians(location.latitude)) *
  //         //             sin(vect.radians(aLat))));
  //         // print(
  //         //     "wow ${location.latitude} / ${location.longitude} / ${aDistance}");
  //         if (_mapEdge != null) {
  //             getURL(
  //                 user.userinfo["userId"].toString());
  //         }
  //       });
  //     }
  //   });
  // }

  // void setState(VoidCallback fn) {
  //   super.setState(fn);
  // }
}
