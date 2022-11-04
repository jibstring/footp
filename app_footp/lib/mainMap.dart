import 'dart:async';
import 'dart:math';
import 'dart:collection';
import 'dart:io';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vector_math/vector_math.dart' as vect;
import 'package:http/http.dart' as http;

import 'package:app_footp/myPage.dart';
import 'package:app_footp/location.dart';
import 'package:app_footp/createFoot.dart';
import 'package:app_footp/components/mainMap/footList.dart';
import 'package:app_footp/components/mainMap/stampList.dart';

MainData maindata = Get.put(MainData());
void main() {
  runApp(const mainMap());
}

// class User{
//   String usernickname="";
//   User(this.usernickname);

//   get user{
//     return user;
//   }

//   set SetUserNickname(nickname){
//     usernickname=nickname;
//   }
// }

class MainData extends GetxController {
  var _dataList;

  String _baseURL = 'http://k7a108.p.ssafy.io:8080';
  String _apiKey = '';
  dynamic _mainDataUrl;

  get dataList => _dataList;

  String get baseURL => _baseURL;
  String get apiKey => _apiKey;
  dynamic get mainDataUrl => _mainDataUrl;

  void getURL(String userid, String lat, String lng) async {
    _apiKey = '/${userid}/${lat}/${lng}';
    _mainDataUrl = Uri.parse('$baseURL/foot/main$apiKey');
    _dataList = await getMainData();
    update();
  }

  Future getMainData() async {
    http.Response response = await http.get(_mainDataUrl);
    if (response.statusCode == 200) {
      _dataList = jsonDecode(utf8.decode(response.bodyBytes));
      update();
      return _dataList;
    } else {
      print(response.statusCode);
      throw 'getMainData() error';
    }
  }
}

class mainMap extends StatelessWidget {
  const mainMap({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FootP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Footp Main Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<NaverMapController> _controller = Completer();

  int _selectedIndex = 0;

  Location location = Location();

  late OverlayImage _commonFoot;
  late OverlayImage _eventFoot;
  late OverlayImage _disabledFoot;
  late OverlayImage _myFoot;
  late OverlayImage _tempFoot;

  late NaverMapController mycontroller;
  late LatLngBounds _mapEdge;

  // 목록
  static List<Widget> widgetOptions = <Widget>[
    // 발자국 글목록
    FootList(),
    // 스탬프 글목록
    StampList()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('imgs/logo.png', height: 45),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Color.fromARGB(255, 153, 181, 229),
              size: 40,
            ),
            padding: const EdgeInsets.only(top: 5, right: 20.0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyPage()),
              );
            },
          ),
        ],
      ),
      body: SizedBox.expand(
          child: Stack(children: <Widget>[
        Container(
            height: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top) *
                0.65,
            child: NaverMap(
                onMapCreated: _onMapCreated,
                onCameraIdle: _getMapEdge,
                minZoom: 5.0,
                locationButtonEnable: true,
                initLocationTrackingMode: LocationTrackingMode.Follow,
                markers: [
                  Marker(
                      markerId: "marker1",
                      position: LatLng(37.5013, 127.0397),
                      icon: _commonFoot,
                      width: 30,
                      height: 30),
                  Marker(
                      markerId: "marker2",
                      position: LatLng(37.5005, 127.0371),
                      icon: _eventFoot,
                      width: 30,
                      height: 30),
                  Marker(
                      markerId: "marker3",
                      position: LatLng(37.5015, 127.0385),
                      icon: _disabledFoot,
                      width: 30,
                      height: 30),
                  Marker(
                      markerId: "marker4",
                      position: LatLng(37.5009, 127.0379),
                      icon: _myFoot,
                      width: 30,
                      height: 30),
                  Marker(
                      markerId: "marker5",
                      position: LatLng(37.5011, 127.0389),
                      icon: _tempFoot,
                      width: 30,
                      height: 30)
                ],
                circles: [
                  CircleOverlay(
                      overlayId: "radius25",
                      center: location.lng,
                      radius: 25,
                      color: Colors.transparent,
                      outlineColor: Colors.orangeAccent,
                      outlineWidth: 1)
                ])),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Color.fromARGB(255, 153, 181, 229),
              size: 55,
            ),
            padding: EdgeInsets.fromLTRB(0, 0, 50, 300),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateFoot()),
              );
            },
          ),
        ),
        //새로고침
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.refresh,
                        //color: Color.fromARGB(255, 228, 229, 160),
                        size: 40,
                      ),
                      padding: EdgeInsets.fromLTRB(0, 0, 100, 295),
                      onPressed: () {
                        maindata.getURL(
            '1', location.longitude.toString(), location.latitude.toString());

                      },
                    ),
                  )
        ,
        widgetOptions.elementAt(_selectedIndex),
        Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'List',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Stamp',
                )
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            )),
      ])),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
    mycontroller = controller;
  }

  void _getMapEdge() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mycontroller.getVisibleRegion().then((value) {
        _mapEdge = value;
      });
    });
  }

  void _getImage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OverlayImage.fromAssetImage(
        assetName: 'imgs/blue_print.png',
      ).then((image) {
        if (mounted) setState(() => _commonFoot = image);
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/golden_print.png',
      ).then((image) {
        if (mounted) setState(() => _eventFoot = image);
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/gray_print.png',
      ).then((image) {
        if (mounted) setState(() => _disabledFoot = image);
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/orange_print.png',
      ).then((image) {
        if (mounted) setState(() => _myFoot = image);
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/white_print.png',
      ).then((image) {
        if (mounted) setState(() => _tempFoot = image);
      });
    });
  }

  void initState() {
    _getImage();
    super.initState();
    Timer.periodic(Duration(seconds: 2), (v) {
      setState(() {
        location.getCurrentLocation();
        // aLat, aLng는 임의로 생성한 메세지 위치, aDistance는 현재 위치에서 임의 메세지까지의 거리
        double aLat = 37.5015;
        double aLng = 127.0395;
        double aDistance = (6371 *
            acos(cos(vect.radians(location.latitude)) *
                    cos(vect.radians(aLat)) *
                    cos(vect.radians(aLng) - vect.radians(location.longitude)) +
                sin(vect.radians(location.latitude)) *
                    sin(vect.radians(aLat))));
        print(
            "wow ${location.latitude} / ${location.longitude} / ${aDistance}");
        print(
            "${_mapEdge.northeast.latitude} / ${_mapEdge.northeast.longitude} / ${_mapEdge.southwest.latitude} / ${_mapEdge.southwest.longitude}");

        maindata.getURL(
            '1', location.longitude.toString(), location.latitude.toString());

        // 이 부분은 2차 배포때 수정할 예정
        // maindata.getURL(
        //     '/${_mapEdge.northeast.longitude}/${_mapEdge.southwest.longitude}/${_mapEdge.southwest.latitude}/${_mapEdge.northeast.latitude}');
      });
    });
  }

  void setState(VoidCallback fn) {
    super.setState(fn);
  }
}
