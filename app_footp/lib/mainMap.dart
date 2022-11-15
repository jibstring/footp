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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vector_math/vector_math.dart' as vect;
import 'package:http/http.dart' as http;

import 'package:app_footp/signIn.dart';
import 'package:app_footp/myPage.dart';
import 'package:app_footp/newmyPage.dart';
import 'package:app_footp/createFoot.dart';
import 'package:app_footp/components/mainMap/footList.dart';
import 'package:app_footp/components/mainMap/stampList.dart';
import 'package:app_footp/components/mainMap/chatRoom.dart';
import 'package:app_footp/custom_class/store_class/store.dart';

MainData maindata = Get.put(MainData());
MyPosition location = Get.put(MyPosition());

class MainData extends GetxController {
  var _dataList;
  int _count = 0;
  int _listsize = 0;
  String _baseURL = 'http://k7a108.p.ssafy.io:8080';
  String _apiKey = '';
  String _filter = 'hot';
  String _markerString = '';
  dynamic _mainDataUrl;
  dynamic _mycontroller;
  dynamic _mapEdge;
  List<Marker> _markers = [];
  List<OverlayImage> _footImage = [];
  Map<int, double> _distances = {};
  Map<int, String> _address = {};
  Map<int, String> _hiddenMessage = {};

  get dataList => _dataList;
  int get count => _count;
  int get listsize => _listsize;
  String get baseURL => _baseURL;
  String get apiKey => _apiKey;
  String get filter => _filter;
  String get markerString => _markerString;
  dynamic get mainDataUrl => _mainDataUrl;
  dynamic get mycontroller => _mycontroller;
  dynamic get mapEdge => _mapEdge;
  List<Marker> get markers => _markers;
  List<OverlayImage> get footImage => _footImage;
  Map<int, double> get distances => _distances;
  Map<int, String> get address => _address;
  Map<int, String> get hiddenMessage => _hiddenMessage;

  set fixFilter(String filter) {
    _filter = filter;
  }

  set setmycontroller(dynamic mycontroller) {
    _mycontroller = mycontroller;
  }

  void getURL(
      String userid, String lngR, String lngL, String latD, String latU) async {
    if (count > 30) {
      markers.clear();
      // address.clear();
      sleep(const Duration(milliseconds: 500));
      _count = 0;
    }
    _apiKey = '${userid}/${lngR}/${lngL}/${latD}/${latU}';
    _mainDataUrl = Uri.parse('$baseURL/foot/list/$filter/$apiKey');

    _dataList = await getMainData();
    _listsize = await _dataList["message"].length;

    for (int i = 0; i < _listsize; i++) {
      if (_dataList["message"][i]["isBlurred"] == true) {
        getDistance(i);
      }
      getAddress(i);
      createMarker(i);
    }

    _count++;
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

  void getDistance(int idx) {
    double messageLat = dataList["message"][idx]["messageLatitude"];
    double messageLng = dataList["message"][idx]["messageLongitude"];

    double distance = (6371 *
        acos(cos(vect.radians(location.latitude)) *
                cos(vect.radians(messageLat)) *
                cos(vect.radians(messageLng) -
                    vect.radians(location.longitude)) +
            sin(vect.radians(location.latitude)) *
                sin(vect.radians(messageLat))));

    _distances[dataList["message"][idx]["messageId"]] = distance;
    if (distance < 0.025) {
      _hiddenMessage[dataList["message"][idx]["messageId"]] =
          dataList["message"][idx]["messageBlurredtext"];
    } else {
      _hiddenMessage[dataList["message"][idx]["messageId"]] = "";
    }
    update();
  }

  void getAddress(int idx) async {
    String lat = dataList["message"][idx]["messageLatitude"].toString();
    String lng = dataList["message"][idx]["messageLongitude"].toString();

    Map<String, String> clientkey = {
      "X-NCP-APIGW-API-KEY-ID": "9foipum14s",
      "X-NCP-APIGW-API-KEY": "scvqRxQKoZo5vULsFL1vrE56tqKcOl7u1z16iWz2"
    };

    http.Response response = await http.get(
        Uri.parse(
            "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=${lng},${lat}&sourcecrs=epsg:4326&orders=addr,roadaddr&output=json"),
        headers: clientkey);
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsondata["status"]["code"] == 0) {
        if (jsondata["results"].length > 1) {
          _address[dataList["message"][idx]["messageId"]] =
              "${jsondata["results"][1]["region"]["area1"]["name"]} ${jsondata["results"][1]["region"]["area2"]["name"]} ${jsondata["results"][1]["land"]["name"]} ${jsondata["results"][1]["land"]["number1"]} ${jsondata["results"][1]["land"]["addition0"]["value"]}";
        } else {
          _address[dataList["message"][idx]["messageId"]] =
              "${jsondata["results"][0]["region"]["area1"]["name"]} ${jsondata["results"][0]["region"]["area2"]["name"]} ${jsondata["results"][0]["region"]["area3"]["name"]} ${jsondata["results"][0]["region"]["area4"]["name"]} ${jsondata["results"][0]["land"]["type"] == "1" ? "" : "산"} ${jsondata["results"][0]["land"]["number1"]}-${jsondata["results"][0]["land"]["number2"]}";
        }
      } else {
        _address[dataList["message"][idx]["messageId"]] = "";
      }
      update();
    } else {
      print(response.statusCode);
      throw 'getAddress() error';
    }
  }

  String changeDate(String date) {
    String newDate = "";
    newDate = date.replaceAll('T', "  ");

    return newDate;
  }

  void createMarker(int idx) {
    int like = (dataList["message"][idx]["messageLikenum"] / 5).toInt();
    int color = 0;
    _markerString =
        "${dataList["message"][idx]["userNickname"]}      \u{2764} ${dataList["message"][idx]["messageLikenum"].toString()}\n${dataList["message"][idx]["messageText"]}\n${hiddenMessage[dataList["message"][idx]["messageId"]] ??= ""}\n${address[dataList["message"][idx]["messageId"]] ??= ""}\n${changeDate(dataList["message"][idx]["messageWritedate"])}";

    if (like >= 45) {
      like = 44;
    }

    if (dataList["message"][idx]["isBlurred"] == true) {
      if ((distances[dataList["message"][idx]["messageId"]] ??= 1) < 0.025) {
        color = 8;
      } else {
        color = 7;
      }
    } else {
      color = dataList["message"][idx]["messageId"] % 7;
    }

    Marker marker = Marker(
        markerId: dataList["message"][idx]["messageId"].toString(),
        position: LatLng(dataList["message"][idx]["messageLatitude"],
            dataList["message"][idx]["messageLongitude"]),
        icon: _footImage[color],
        width: 5 * (6 + like),
        height: 5 * (6 + like),
        onMarkerTab: (marker, iconSize) {
          // print("Hi ${dataList["message"][idx]["messageId"]}");
        },
        infoWindow: markerString);

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
  DateTime? currentBackPressTime;

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
    return WillPopScope(
        onWillPop: () async {
          bool result = onWillPop();
          return await Future.value(result);
        },
        child: Scaffold(
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
                      MaterialPageRoute(
                          builder: (context) => const CreateFoot()),
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
        ));
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
        assetName: 'imgs/purple_print.png',
      ).then((image) {
        if (mounted) setState(() => maindata.footImage.add(image));
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/pink_print.png',
      ).then((image) {
        if (mounted) setState(() => maindata.footImage.add(image));
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/red_print.png',
      ).then((image) {
        if (mounted) setState(() => maindata.footImage.add(image));
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/orange_print.png',
      ).then((image) {
        if (mounted) setState(() => maindata.footImage.add(image));
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/yellow_print.png',
      ).then((image) {
        if (mounted) setState(() => maindata.footImage.add(image));
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/green_print.png',
      ).then((image) {
        if (mounted) setState(() => maindata.footImage.add(image));
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/unknown_print.png',
      ).then((image) {
        if (mounted) setState(() => maindata.footImage.add(image));
      });

      OverlayImage.fromAssetImage(
        assetName: 'imgs/known_print.png',
      ).then((image) {
        if (mounted) setState(() => maindata.footImage.add(image));
      });
    });
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
          fontSize: 10,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    return true;
  }

  void initState() {
    _getImage();
    super.initState();
    Timer.periodic(Duration(seconds: 1), (v) {
      if (mounted) {
        setState(() {
          location.getCurrentLocation();
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
            switch (_selectedIndex) {
              case 0:
                markers = maindata.markers;
                break;
              case 1:
                markers = maindata.markers;
                break;
              case 2:
                markers = maindata.markers;
                break;
              default:
                markers = maindata.markers;
            }
          }
        });
      }
    });
  }

  void setState(VoidCallback fn) {
    super.setState(fn);
  }
}
