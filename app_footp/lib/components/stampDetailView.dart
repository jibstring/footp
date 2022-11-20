import 'dart:async';
import 'package:app_footp/components/mainMap/stampList.dart';
import 'package:app_footp/components/msgFoot/normalFoot.dart';
import 'package:app_footp/components/msgFoot/stampFoot.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:app_footp/mainMap.dart';
import 'package:app_footp/myPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:naver_map_plugin/naver_map_plugin.dart';

class StampDetailView extends StatefulWidget {
  const StampDetailView({super.key});

  @override
  State<StampDetailView> createState() => _StampDetailViewState();
}

class _StampDetailViewState extends State<StampDetailView> {
  // JoinStampInfo joinedStamp = Get.put(JoinStampInfo());
  StampMessage stampMessage = Get.put(StampMessage());
  UserData user = Get.put(UserData());
  MyPosition myPosition = Get.put(MyPosition());
  JoinStampInfo joinedStamp = Get.put(JoinStampInfo());
  Completer<NaverMapController> _controller = Completer();
  List<Marker> markers = maindata.markers;
  List<String> _footImg = [
    "imgs/blue_print.png",
    "imgs/gray_print.png",
    "imgs/orange_print.png"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('============================================');
    print(stampMessage.stampMessage1);
    print(stampMessage.stampMessage2);
    print(stampMessage.stampMessage3);
    print(stampMessage.viewStamp);
    print('===========================================');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset('imgs/로고_기본.png', height: 45),
          elevation: 0,
          leading: BackButton(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top) *
                    0.65,
                child: NaverMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          stampMessage.stampMessage1["messageLatitude"],
                          stampMessage.stampMessage1["messageLongitude"]),
                      zoom: 11.0),
                  minZoom: 5.0,
                  locationButtonEnable: true,
                  markers: markers,
                ),
              ),
              SizedBox(height: 20),
              Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 3.3),
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 247, 198, 160)),
                  child: Center(
                    child: Text(stampMessage.viewStamp["stampboard_title"],
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  )),
              SizedBox(height: 30),
              Container(
                  child: Text(stampMessage.viewStamp["stampboard_text"],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black))),
              SizedBox(height: 30),
              Divider(color: Colors.black, thickness: 3.0),
              SizedBox(height: 20),
              Container(
                  child: Text("스탬프 코스 정보",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black))),
              SizedBox(height: 20),
              // Container(
              //   width: 100,
              //       child: Image.asset(_footImg[0])
              // ),
              NormalFoot(stampMessage.stampMessage1),
              SizedBox(height: 10),
              NormalFoot(stampMessage.stampMessage2),
              SizedBox(height: 10),
              NormalFoot(stampMessage.stampMessage3),
              SizedBox(height: 10),
            ],
          ),
        ));
  }
}
