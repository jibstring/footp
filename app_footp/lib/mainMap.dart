import 'dart:async';
import 'dart:math';
import 'dart:collection';
import 'dart:io';
import 'dart:convert';

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

MainData maindata = Get.put(MainData());
MyPosition location = Get.put(MyPosition());

class MainData extends GetxController {
  var _dataList;
  int _listsize = 0;
  String _baseURL = 'http://k7a108.p.ssafy.io:8080';
  String _apiKey = '';
  String _filter = 'hot';
  dynamic _mainDataUrl;
  dynamic _mycontroller;
  dynamic _mapEdge;
  List<Marker> _markers = [];
  List<OverlayImage> _footImage = [];

  get dataList => _dataList;
  int get listsize => _listsize;
  String get baseURL => _baseURL;
  String get apiKey => _apiKey;
  String get filter => _filter;
  dynamic get mainDataUrl => _mainDataUrl;
  dynamic get mycontroller => _mycontroller;
  dynamic get mapEdge => _mapEdge;
  List<Marker> get markers => _markers;
  List<OverlayImage> get footImage => _footImage;

  set fixFilter(String filter) {
    _filter = filter;
  }

  set setmycontroller(dynamic mycontroller) {
    _mycontroller = mycontroller;
  }

  void getURL(
      String userid, String lngR, String lngL, String latD, String latU) async {
    _apiKey = '${userid}/${lngR}/${lngL}/${latD}/${latU}';
    _mainDataUrl = Uri.parse('$baseURL/foot/list/$filter/$apiKey');

    _dataList = await getMainData();
    _listsize = await _dataList["message"].length;

    markers.clear();
    for (int i = 0; i < _listsize; i++) {
      // print(dataList["message"][i]);
      createMarker(i);
    }

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

  void createMarker(int idx) {
    int like = dataList["message"][idx]["messageLikenum"];
    int color = 0;

    if (like >= 95) {
      like = 94;
    }

    if (dataList["message"][idx]["isBlurred"] == true) {
      color = 4;
    } else {
      switch (dataList["message"][idx]["messageId"] % 4) {
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
        markerId: dataList["message"][idx]["messageId"].toString(),
        position: LatLng(dataList["message"][idx]["messageLatitude"],
            dataList["message"][idx]["messageLongitude"]),
        icon: _footImage[color],
        width: 5 * (6 + like),
        height: 5 * (6 + like),
        onMarkerTab: (marker, iconSize) {
          print("Hi ${dataList["message"][idx]["messageId"]}");
        },
        infoWindow: dataList["message"][idx]["messageText"]);

    _markers.add(marker);
    update();
  }

  void getMapEdge() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mycontroller.getVisibleRegion().then((value) {
        _mapEdge = value;
      });
    });
    update();
  }

  void moveMapToMessage(double lat, double lng) {
    CameraPosition cameraPosition =
        CameraPosition(target: LatLng(lat, lng), zoom: 21.0);
    _mycontroller.moveCamera(CameraUpdate.toCameraPosition(cameraPosition));
    update();
  }
}

class MainMap extends StatelessWidget {
  const MainMap({super.key});

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
  UserData user = Get.put(UserData());
  int _selectedIndex = 0;
  List<Marker> markers = [];

  // 목록
  static List<Widget> widgetOptions = <Widget>[
    // 발자국 글목록
    FootList(),
    // 실시간 채팅방
    ChatRoom(1, 2, "unknown"),
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
            padding: const EdgeInsets.only(top: 5.0, right: 20.0),
            onPressed: () {
              if (!user.isLogin()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyPage()),
                );
              }
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
                onCameraIdle: maindata.getMapEdge,
                minZoom: 5.0,
                locationButtonEnable: true,
                initLocationTrackingMode: LocationTrackingMode.Follow,
                markers: markers,
                circles: [
                  CircleOverlay(
                      overlayId: "radius25",
                      center: LatLng(location.latitude, location.longitude),
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
            padding: EdgeInsets.only(
                right: 50.0,
                bottom: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top) *
                    0.35),
            onPressed: () {
              if (!user.isLogin()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateFoot()),
                );
              }
            },
          ),
        ),
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
                  icon: Icon(Icons.location_pin),
                  label: 'Alarm',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.linear_scale),
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
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
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
    maindata._mycontroller = controller;
  }

  void _getImage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OverlayImage.fromAssetImage(
        assetName: 'imgs/blue_print.png',
      ).then((image) {
        if (mounted) setState(() => maindata.footImage.add(image));
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/golden_print.png',
      ).then((image) {
        if (mounted) setState(() => maindata.footImage.add(image));
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/orange_print.png',
      ).then((image) {
        if (mounted) setState(() => maindata.footImage.add(image));
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/white_print.png',
      ).then((image) {
        if (mounted) setState(() => maindata.footImage.add(image));
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/gray_print.png',
      ).then((image) {
        if (mounted) setState(() => maindata.footImage.add(image));
      });
    });
  }

  void initState() {
    _getImage();
    super.initState();
    Timer.periodic(Duration(seconds: 2), (v) {
      if (mounted) {
        setState(() {
          location.getCurrentLocation();
          // aLat, aLng는 임의로 생성한 메세지 위치, aDistance는 현재 위치에서 임의 메세지까지의 거리
          // double aLat = 37.5015;
          // double aLng = 127.0395;
          // double aDistance = (6371 *
          //     acos(cos(vect.radians(location.latitude)) *
          //             cos(vect.radians(aLat)) *
          //             cos(vect.radians(aLng) - vect.radians(location.longitude)) +
          //         sin(vect.radians(location.latitude)) *
          //             sin(vect.radians(aLat))));
          // print(
          //     "wow ${location.latitude} / ${location.longitude} / ${aDistance}");
          if (maindata.mapEdge != null) {
            if (!user.isLogin()) {
              // User ID는 null, 추후 수정
              maindata.getURL(
                  "1",
                  maindata.mapEdge.northeast.longitude.toString(),
                  maindata.mapEdge.southwest.longitude.toString(),
                  maindata.mapEdge.southwest.latitude.toString(),
                  maindata.mapEdge.northeast.latitude.toString());
            } else {
              maindata.getURL(
                  user.userinfo["userId"].toString(),
                  maindata.mapEdge.northeast.longitude.toString(),
                  maindata.mapEdge.southwest.longitude.toString(),
                  maindata.mapEdge.southwest.latitude.toString(),
                  maindata.mapEdge.northeast.latitude.toString());
            }
            markers = maindata.markers;
          }
        });
      }
    });
  }

  void setState(VoidCallback fn) {
    super.setState(fn);
  }
}
