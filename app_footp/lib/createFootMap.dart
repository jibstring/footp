// ignore_for_file: import_of_legacy_library_into_null_safe, unused_import, prefer_final_fields

import 'dart:async';
import 'dart:convert';
import 'package:app_footp/mainMap.dart';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as DIO;

class MyNaverMap extends StatefulWidget {
  CreateMarker image = Get.put(CreateMarker());
  @override
  State<MyNaverMap> createState() => _MyNaverMapState();
}

class _MyNaverMapState extends State<MyNaverMap> {
  MapType _mapType = MapType.Basic;
  ModeController modeController2 = Get.put(ModeController());
  MyPosition myPosition_map = Get.put(MyPosition());
  CreateMarker createMarker = Get.put(CreateMarker());
  List png = ['asset/normalfoot.png', 'asset/megaphone.png'];
  Marker marker = Marker(markerId: '0', position: LatLng(0, 0));

  bool isTapped = false;

  onpress() {
    // setState(() {
    //   isTapped = !isTapped;
    // });
    print('hello');
    if(modeController2.mode==0)
      _callFootPOST();
    if(modeController2.mode==1)
      _callMegaPOST();
    Navigator.push(context, MaterialPageRoute(builder: (context) => mainMap()));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!this.mounted) return;
      createMarker.createImage(context, modeController2.mode);
    });
    createMarker.list.clear();
    super.initState();
  }

  void _callFootPOST() async {
    var url = Uri.parse('http://k7a108.p.ssafy.io:8080/foot/write');

    var data = DIO.FormData.fromMap({
      'messageContent': json.encode(createMarker.newmarker),
    });

    if (createMarker.filePath != '') {
      data.files.addAll([
        MapEntry('messageFile',
            await DIO.MultipartFile.fromFile(createMarker.filePath))
      ]);
    } else {}
    ;

    // var response = await http.post(url,
    //     headers: {"Content-Type": "multipart/form-data"}, data: data);

    var dio = DIO.Dio();
    dio.options.contentType = 'multipart/form-data';
    dio.options.maxRedirects.isFinite;
    print('******************************');
    print(data);
    print(data.fields);
    print(data.files);
    print('***********************************');
    var response = await dio.post(url.toString(), data: data);

    print('############################################');
    print(response.statusCode);
    print(response);
    print(data.fields);
    print(createMarker.filePath);
    print('########################################');
    Fluttertoast.showToast(msg: "발자국을 찍었습니다");

    // Map marker = {
    //   "isOpentoall": true,
    //   "messageFileurl":
    //       "https://mblogthumb-phinf.pstatic.net/MjAxOTEyMTdfMjM5/MDAxNTc2NTgwNjQxMzIw.UIw2A-EU9OUtt5FQ_6iRP2QJQS-aFE7L_EkI_VK6ED0g.dGYlktZJPVI8Jn9z6czNo1FmNIKqNk6ap1tODyDVmswg.JPEG.ideaeditor_lee/officialDobes.jpg?type=w800",
    //   "messageId": 1,
    //   "messageLatitude": 37.72479485462167,
    //   "messageLikenum": 0,
    //   "messageLongitude": 128.71639982661415,
    //   "messageSpamnum": 0,
    //   "messageText": "test",
    //   "messageWritedate": "2022-11-03T03:52:19.705Z",
    //   "userId": 5
    // };
  }

  void _callMegaPOST() async {
    var url = Uri.parse('http://k7a108.p.ssafy.io:8080/gather/write');

    var data = DIO.FormData.fromMap({
      'gatherContent': json.encode(createMarker.newmegaphone),
    });

    if (createMarker.filePath != '') {
      data.files.addAll([
        MapEntry('gatherFile',
            await DIO.MultipartFile.fromFile(createMarker.filePath))
      ]);
    } else {}
    ;

    // var response = await http.post(url,
    //     headers: {"Content-Type": "multipart/form-data"}, data: data);

    var dio = DIO.Dio();
    dio.options.contentType = 'multipart/form-data';
    dio.options.maxRedirects.isFinite;
    print('******************************');
    print(data);
    print(data.fields);
    print(data.files);
    print('***********************************');
    var response = await dio.post(url.toString(), data: data);

    print('############################################');
    print(response.statusCode);
    print(response);
    print(data.fields);
    print(createMarker.filePath);
    print('########################################');
    Fluttertoast.showToast(msg: "확성기를 설치했습니다");

    // Map marker = {
    //   "isOpentoall": true,
    //   "messageFileurl":
    //       "https://mblogthumb-phinf.pstatic.net/MjAxOTEyMTdfMjM5/MDAxNTc2NTgwNjQxMzIw.UIw2A-EU9OUtt5FQ_6iRP2QJQS-aFE7L_EkI_VK6ED0g.dGYlktZJPVI8Jn9z6czNo1FmNIKqNk6ap1tODyDVmswg.JPEG.ideaeditor_lee/officialDobes.jpg?type=w800",
    //   "messageId": 1,
    //   "messageLatitude": 37.72479485462167,
    //   "messageLikenum": 0,
    //   "messageLongitude": 128.71639982661415,
    //   "messageSpamnum": 0,
    //   "messageText": "test",
    //   "messageWritedate": "2022-11-03T03:52:19.705Z",
    //   "userId": 5
    // };
  }

  @override
  Widget build(BuildContext context) {
    // createMarker.createImage(context);
    return Scaffold(
      appBar: AppBar(title: Text("map")),
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            GetBuilder<CreateMarker>(
              builder: (_) => Container(
                child: NaverMap(
                  onMapTap: (latLng) => {
                    // Fluttertoast.showToast(msg: '$latLng'),
                    // createMarker.createImage(context),
                    createMarker.tapped(latLng.latitude, latLng.longitude),
                  },
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          myPosition_map.latitude, myPosition_map.longitude),
                      zoom: 18),
                  mapType: _mapType,
                  scrollGestureEnable: false,
                  zoomGestureEnable: false,
                  markers: createMarker.list,
                ),
              ),
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     InkWell(
            //       highlightColor: Colors.transparent,
            //       splashColor: Colors.transparent,
            //       child: AnimatedContainer(
            //         margin: EdgeInsets.only(bottom: isTapped ? 200 : 800),
            //         duration: Duration(seconds: 1),
            //         curve: isTapped ? Curves.bounceOut : Curves.ease,
            //         height: 250,
            //         width: 240,
            //         child: Center(
            //             child: Text(
            //           "쿵!",
            //           style: TextStyle(fontSize: 200),
            //         )),
            //       ),
            //     ),
            //   ],
            // ),
            Container(
              margin: EdgeInsets.only(top: 100),
              width: 300,
              height: 100,
              color: Colors.white70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(png[modeController2.mode]),
                  ),
                  Text("지도를 탭하여 \n발자국을 찍으세요!",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  ElevatedButton(
                    onPressed: onpress,
                    child: Text("쿵!"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurple[100])),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
