import 'dart:async';
import 'dart:math';
import 'dart:collection';
import 'dart:io';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:log_print/log_print.dart';
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
import 'package:app_footp/components/mainMap/gatherList.dart';
import 'package:app_footp/components/mainMap/stampList.dart';
import 'package:app_footp/components/mainMap/chatRoom.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:app_footp/createStamp.dart';
import 'package:app_footp/components/joinStampDetail.dart';
import 'package:app_footp/components/stampDetailView.dart';

MainData maindata = Get.put(MainData());
MyPosition location = Get.put(MyPosition());

class MainData extends GetxController {
  var _dataList;
  int _count = 0;
  int _listsize = 0;
  int _selectedIndex = 0;
  bool _attendChat = false;
  bool _searchFlag = false;
  String _baseURL = 'http://k7a108.p.ssafy.io:8080';
  String _apiKey = '';
  String _filter = 'hot';
  String _markerString = '';
  String _searchKeyword = '';
  dynamic _mainDataUrl;
  dynamic _mycontroller;
  dynamic _mapEdge;
  ChatRoom _chatRoom = ChatRoom(0, 0, "", "");
  List<Marker> _markers = [];
  List<OverlayImage> _footImage = [];
  Map<int, double> _distances = {};
  Map<int, String> _address = {};
  Map<int, String> _hiddenMessage = {};

  get dataList => _dataList;
  int get count => _count;
  int get listsize => _listsize;
  int get selectedIndex => _selectedIndex;
  bool get attendChat => _attendChat;
  bool get searchFlag => _searchFlag;
  String get baseURL => _baseURL;
  String get apiKey => _apiKey;
  String get filter => _filter;
  String get searchKeyword => _searchKeyword;
  String get markerString => _markerString;
  dynamic get mainDataUrl => _mainDataUrl;
  dynamic get mycontroller => _mycontroller;
  dynamic get mapEdge => _mapEdge;
  ChatRoom get chatRoom => _chatRoom;
  List<Marker> get markers => _markers;
  List<OverlayImage> get footImage => _footImage;
  Map<int, double> get distances => _distances;
  Map<int, String> get address => _address;
  Map<int, String> get hiddenMessage => _hiddenMessage;

  set setChatRoom(ChatRoom cr) {
    _chatRoom = cr;
  }

  set setSearchFlag(bool searchflag) {
    _searchFlag = searchflag;
  }

  set fixFilter(String filter) {
    _filter = filter;
  }

  set setMyController(dynamic mycontroller) {
    _mycontroller = mycontroller;
  }

  set setAttendChat(bool attend) {
    _attendChat = attend;
  }

  set setListClean(bool clear) {
    _dataList.clear();
    _markers.clear();
  }

  set setSearchKeyword(String keyword) {
    _searchKeyword = keyword;
  }

  void getURL(
      String userid, String lngR, String lngL, String latD, String latU) async {
    _apiKey = '${userid}/${lngR}/${lngL}/${latD}/${latU}';

    switch (selectedIndex) {
      case 0:
        _mainDataUrl = Uri.parse('$baseURL/foot/list/$filter/$apiKey');
        _dataList = await getMainData();

        try {
          _listsize = await _dataList["message"].length;
        } catch (e) {
          _listsize = 0;
        }

        for (int i = 0; i < _listsize; i++) {
          if (_dataList["message"][i]["isBlurred"] == true) {
            getDistance(i);
          }
          getAddress(i);
          createMarker(i);
        }

        break;

      case 1:
        _mainDataUrl = Uri.parse('$baseURL/gather/list/$filter/$apiKey');
        _dataList = await getMainData();

        try {
          _listsize = await _dataList["gather"].length;
        } catch (e) {
          _listsize = 0;
        }

        for (int i = 0; i < _listsize; i++) {
          getAddress(i);
          createMarker(i);
        }

        break;

      // case 2:
      //   break;

      default:
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
    String messageType = "";
    String id = "";
    String latitude = "";
    String longitude = "";

    switch (selectedIndex) {
      case 0:
        messageType = "message";
        id = "messageId";
        latitude = "messageLatitude";
        longitude = "messageLongitude";
        break;

      case 1:
        messageType = "gather";
        id = "gatherId";
        latitude = "gatherLatitude";
        longitude = "gatherLongitude";
        break;

      // case 2:
      //   break;

      default:
        messageType = "message";
        id = "messageId";
        latitude = "messageLatitude";
        longitude = "messageLongitude";
    }

    String lat = dataList[messageType][idx][latitude].toString();
    String lng = dataList[messageType][idx][longitude].toString();

    Map<String, String> clientkey = {
      "X-NCP-APIGW-API-KEY-ID": "9foipum14s",
      "X-NCP-APIGW-API-KEY": "scvqRxQKoZo5vULsFL1vrE56tqKcOl7u1z16iWz2"
    };

    if (address.containsKey(dataList[messageType][idx][id])) {
      // print("continue");
    } else {
      http.Response response = await http.get(
          Uri.parse(
              "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=${lng},${lat}&sourcecrs=epsg:4326&orders=addr,roadaddr&output=json"),
          headers: clientkey);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(utf8.decode(response.bodyBytes));
        if (jsondata["status"]["code"] == 0) {
          if (jsondata["results"].length > 1) {
            _address[dataList[messageType][idx][id]] =
                "${jsondata["results"][1]["region"]["area1"]["name"]} ${jsondata["results"][1]["region"]["area2"]["name"]} ${jsondata["results"][1]["land"]["name"]} ${jsondata["results"][1]["land"]["number1"]} ${jsondata["results"][1]["land"]["addition0"]["value"]}";
          } else {
            _address[dataList[messageType][idx][id]] =
                "${jsondata["results"][0]["region"]["area1"]["name"]} ${jsondata["results"][0]["region"]["area2"]["name"]} ${jsondata["results"][0]["region"]["area3"]["name"]} ${jsondata["results"][0]["region"]["area4"]["name"]} ${jsondata["results"][0]["land"]["type"] == "1" ? "" : "산"} ${jsondata["results"][0]["land"]["number1"]}-${jsondata["results"][0]["land"]["number2"]}";
          }
        } else {
          _address[dataList[messageType][idx][id]] = "";
        }
        update();
      } else {
        print(response.statusCode);
        throw 'getAddress() error';
      }
    }
  }

  String changeDate(String date) {
    String newDate = "";
    newDate = date.replaceAll('T', "  ");

    return newDate;
  }

  void createMarker(int idx) {
    String messageType = "";
    String id = "";
    String nickname = "";
    String text = "";
    String latitude = "";
    String longitude = "";
    String likenum = "";
    String writedate = "";

    switch (selectedIndex) {
      case 0:
        messageType = "message";
        id = "messageId";
        nickname = "userNickname";
        text = "messageText";
        latitude = "messageLatitude";
        longitude = "messageLongitude";
        likenum = "messageLikenum";
        writedate = "messageWritedate";
        break;

      case 1:
        messageType = "gather";
        id = "gatherId";
        nickname = "userNickname";
        text = "gatherText";
        latitude = "gatherLatitude";
        longitude = "gatherLongitude";
        likenum = "gatherLikenum";
        writedate = "gatherWritedate";
        break;

      // case 2:
      //   break;

      default:
        messageType = "message";
        id = "messageId";
        nickname = "userNickname";
        text = "messageText";
        latitude = "messageLatitude";
        longitude = "messageLongitude";
        likenum = "messageLikenum";
        writedate = "messageWritedate";
    }

    int like = (dataList[messageType][idx][likenum] / 5).toInt();
    int color = 0;
    _markerString =
        "${dataList[messageType][idx][nickname]}      \u{2764} ${dataList[messageType][idx][likenum].toString()}\n${dataList[messageType][idx][text]}\n${hiddenMessage[dataList[messageType][idx][id]] ??= ""}\n${address[dataList[messageType][idx][id]] ??= ""}\n${changeDate(dataList[messageType][idx][writedate])}";

    if (like >= 45) {
      like = 44;
    }

    switch (selectedIndex) {
      case 0:
        if (dataList["message"][idx]["isBlurred"] == true) {
          if ((distances[dataList["message"][idx]["messageId"]] ??= 1) <
              0.025) {
            color = 8;
          } else {
            color = 7;
          }
        } else {
          color = dataList[messageType][idx][id] % 7;
        }
        break;

      case 1:
        color = 9;
        break;

      // case 2:
      //   break;

      default:
    }

    Marker marker = Marker(
        markerId: dataList[messageType][idx][id].toString(),
        position: LatLng(dataList[messageType][idx][latitude],
            dataList[messageType][idx][longitude]),
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
    if (count > 30) {
      markers.clear();
      // address.clear();
      sleep(const Duration(milliseconds: 500));
      _count = 0;
    }
    _count++;

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

  void moveMapTogather(gathermsg, gathermsg2) {}

  void getSearch(String userid, String lng, String lat) async {
    _apiKey = '${userid}/${lng}/${lat}';

    switch (selectedIndex) {
      case 0:
        _mainDataUrl = Uri.parse('$baseURL/foot/search/$apiKey');

        // print(_mainDataUrl);
        _dataList = await getSearchData();

        try {
          _listsize = await _dataList["message"].length;
        } catch (e) {
          _listsize = 0;
        }

        for (int i = 0; i < _listsize; i++) {
          if (_dataList["message"][i]["isBlurred"] == true) {
            getDistance(i);
          }
          getAddress(i);
          createMarker(i);
        }

        break;

      case 1:
        _mainDataUrl = Uri.parse('$baseURL/gather/search/$apiKey');
        _dataList = await getSearchData();

        try {
          _listsize = await _dataList["gather"].length;
        } catch (e) {
          _listsize = 0;
        }

        for (int i = 0; i < _listsize; i++) {
          getAddress(i);
          createMarker(i);
        }

        break;

      // case 2:
      //   break;

      default:
    }

    update();
  }

  Future getSearchData() async {
    // print(searchKeyword);

    var body = jsonEncode({"keyword": searchKeyword});
    http.Response response = await http.post(_mainDataUrl,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: body);
    if (response.statusCode == 200) {
      _dataList = jsonDecode(utf8.decode(response.bodyBytes));
      // print(_dataList);
      update();
      return _dataList;
    } else {
      print(response.statusCode);
      throw 'getSearchData() error';
    }
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
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'footp'),
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
  int selectedIndex = maindata.selectedIndex;
  List<Marker> markers = [];
  DateTime? currentBackPressTime;
  static final storage = new FlutterSecureStorage();
  dynamic loginInfo = '';

  // 목록
  static List<Widget> widgetOptions = <Widget>[
    // 발자국 글목록
    FootList(),
    // 실시간 채팅방
    gatherList(),
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
            title: Image.asset('imgs/로고_기본.png', height: 50),
            backgroundColor: Colors.white, //Color.fromARGB(255, 255, 253, 241),
            centerTitle: true,
            elevation: 2,
            actions: <Widget>[
              IconButton(
                iconSize: 50,
                icon: Image.asset(
                  'imgs/프로필_b.png',
                ),
                // padding: const EdgeInsets.only(top: 5.0, right: 20.0),
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
                          builder: (context) => const newMyPage()),
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
                          outlineWidth: 5)
                    ])),
            Align(
              alignment: Alignment(0.9, 0.3),
              child: Container(
                height: 75,
                width: 75,
                child: selectedIndex != 2
                    ? IconButton(
                        icon: Image.asset(
                          'imgs/글쓰기_o.png',
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        onPressed: () {
                          if (!user.isLogin()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignIn()),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreateFoot()),
                            );
                          }
                        },
                      )
                    : IconButton(
                        icon: Image.asset('imgs/글쓰기_o.png', height: 50),
                        onPressed: () {
                          if (!user.isLogin()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignIn()),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreateStamp()),
                            ).then((value) {});
                          }
                        },
                      ),
              ),
            ),
            widgetOptions.elementAt(selectedIndex),
            Align(
                alignment: Alignment.bottomCenter,
                child: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Image.asset(
                          "./imgs/하단바-메세지_b_off.png",
                          width: 45,
                          height: 45,
                        ),
                        activeIcon: Image.asset(
                          "./imgs/하단바-메세지_b.png",
                          width: 45,
                          height: 45,
                        ),
                        label: ''),
                    BottomNavigationBarItem(
                        icon: Image.asset(
                          "./imgs/하단바-확성기_o_off.png",
                          width: 45,
                          height: 45,
                        ),
                        activeIcon: Image.asset(
                          "./imgs/하단바-확성기_o.png",
                          width: 45,
                          height: 45,
                        ),
                        label: ''),
                    BottomNavigationBarItem(
                        icon: Image.asset(
                          "./imgs/하단바-스탬푸_p_off.png",
                          width: 45,
                          height: 45,
                        ),
                        activeIcon: Image.asset(
                          "./imgs/하단바-스탬푸_p.png",
                          width: 45,
                          height: 45,
                        ),
                        label: '')
                  ],
                  currentIndex: selectedIndex,
                  onTap: _onItemTapped,
                )),
          ])),
        ));
  }

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        selectedIndex = index;
        maindata._selectedIndex = index;

        markers.clear();
        maindata.setListClean = true;
        maindata._address.clear();
        maindata.setSearchFlag = false;
        maindata.setSearchKeyword = "";
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

      OverlayImage.fromAssetImage(
        assetName: 'imgs/megaphone.png',
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
          fontSize: 11,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    return true;
  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    loginInfo = await storage.read(key: 'login');

    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    // if (userInfo != null) {
    //   Navigator.pushNamed(context, '/main');
    // } else {
    //   print('로그인이 필요합니다');
    // }
    if (loginInfo != null) {
      LogPrint("$loginInfo");
      var url =
          Uri.parse('http://k7a108.p.ssafy.io:8080/auth/info/${loginInfo}');
      print(url);
      var response = await http.post(url);
      var qqqqq = json.decode(response.body);
      user.login("자동로그인");
      user.userinfoSet(qqqqq["userInfo"]);
    }
  }

  void initState() {
    _getImage();
    super.initState();
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
    Timer.periodic(Duration(seconds: 2), (v) {
      if (mounted) {
        setState(() {
          location.getCurrentLocation();
          if (maindata.mapEdge != null) {
            if (maindata.searchFlag == false) {
              if (!user.isLogin()) {
                // 비회원일 경우 userId = 1
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
            } else {
              // print(maindata.searchKeyword);
              if (maindata.searchKeyword != "") {
                if (!user.isLogin()) {
                  maindata.getSearch(
                      "1",
                      ((maindata.mapEdge.northeast.longitude +
                                  maindata.mapEdge.southwest.longitude) /
                              2)
                          .toString(),
                      ((maindata.mapEdge.southwest.latitude +
                                  maindata.mapEdge.northeast.latitude) /
                              2)
                          .toString());
                } else {
                  maindata.getSearch(
                      user.userinfo["userId"].toString(),
                      ((maindata.mapEdge.northeast.longitude +
                                  maindata.mapEdge.southwest.longitude) /
                              2)
                          .toString(),
                      ((maindata.mapEdge.southwest.latitude +
                                  maindata.mapEdge.northeast.latitude) /
                              2)
                          .toString());
                }
              } else {
                maindata.setListClean = true;
              }
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
