import 'package:app_footp/components/userSetting/myFoot.dart';
import 'package:app_footp/components/userSetting/nicknameSetting.dart';
import 'package:app_footp/mainMap.dart';
import 'package:flutter/material.dart';
import 'package:app_footp/setting.dart';
import 'package:app_footp/signIn.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:get/get.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPage',
      debugShowCheckedModeBanner: false,
      home: const MyHompageState(),
    );
  }
}

class MyHompageState extends StatefulWidget {
  const MyHompageState({super.key});

  @override
  State<MyHompageState> createState() => _MyHompageStateState();
}

class _MyHompageStateState extends State<MyHompageState> {
  @override
  bool myfootClick=true;
  bool mystampClick=false;
  int _selectedIndex = 0;
  final controller = Get.put(UserData());

  var _dataList;
  int _messagelistsize = 0;
  int _gatherlistsize=0;
  String _baseURL = 'http://k7a108.p.ssafy.io:8080';
  String _apiKey = '';
  dynamic _mainDataUrl;
  dynamic _mapEdge;
  List<Marker> markers = [];
  List<OverlayImage> _footImage = [];

  void getURL(
    String userid) async {
    _mainDataUrl = Uri.parse(_baseURL+'/user/myfoot/{$userid}');
    print(_mainDataUrl);

    _dataList = await getMainData();
    try{
      _messagelistsize = await _dataList["message"].length;
    }
    catch(e){
      _messagelistsize=0;
    }
    try{
      _gatherlistsize=await _dataList["gather"].length;
    }
    catch(e){
      _gatherlistsize=0;
    }
  
    markers.clear();
    for (int i = 0; i < _messagelistsize+_gatherlistsize; i++) {
      print(_dataList["message"][i]);
      createMarker(i);
    }

    // update();
  }

  Future getMainData() async {
    http.Response response = await http.get(_mainDataUrl);
    if (response.statusCode == 200) {
      _dataList = jsonDecode(utf8.decode(response.bodyBytes));
      print("데이터리스트트트트ㅡ트트틑");
      print(_dataList);
      // update();
      return _dataList;
    } else {
      print(response.statusCode);
      throw 'getMainData() error';
    }
  }

  void createMarker(int idx) {
    int like = _dataList["message"][idx]["messageLikenum"];
    int color = 0;

    if (like >= 95) {
      like = 94;
    }

    if (_dataList["message"][idx]["isBlurred"] == true) {
      color = 4;
    } else {
      switch (_dataList["message"][idx]["messageId"] % 4) {
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
        markerId: _dataList["message"][idx]["messageId"].toString(),
        position: LatLng(_dataList["message"][idx]["messageLatitude"],
            _dataList["message"][idx]["messageLongitude"]),
        icon: _footImage[color],
        width: 5 * (6 + like),
        height: 5 * (6 + like),
        onMarkerTab: (marker, iconSize) {
          print("Hi ${_dataList["message"][idx]["messageId"]}");
        },
        infoWindow: _dataList["message"][idx]["messageText"]);

    markers.add(marker);
    // update();
  }

  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.blue[100],
              size: 40,
            ),
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainMap()),
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.blue[100],
                size: 40,
              ),
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingPage()),
                );
              },
            )
          ]),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            //닉네임
            Row(children: [
              SizedBox(
                width: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  '${controller.userinfo["userNickname"]}',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Color.fromARGB(255, 174, 174, 174),
                  size: 30,
                ),
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                onPressed: () {
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const NicknameSetting();
                        });
                  });
                },
              )
            ]),
            SizedBox(height:25),
          //내글 목록
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width*0.5,
                height:MediaQuery.of(context).size.height*0.065,
                child: TextButton(
                  style:TextButton.styleFrom(backgroundColor : myfootClick?Colors.blue[100]:Colors.white), 
                  onPressed: (){
                    setState(() {
                      mystampClick=false;
                    myfootClick=true;
                    getURL(controller.userinfo["userId"].toString());
                    });                
                },
                  child: Text(
                    "내 글 보기",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20),)),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.5,
                height:MediaQuery.of(context).size.height*0.065,
                child: TextButton(
                  style:TextButton.styleFrom(
                    backgroundColor : mystampClick?Colors.blue[100]:Colors.white,), 
                  onPressed: (){
                    setState(() {
                      mystampClick=true;
                      myfootClick=false;
                      
                    });
                },
                  child: Text(
                    "스탬푸",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20),)),
              ),
            ],
          ),
          Container(
            height:MediaQuery.of(context).size.height*0.5,
            child: MyFootPage(markers),
          )
          ],
        ),
      ),
    );
  }
  void initState() {
    getURL(controller.userinfo["userId"].toString());
    super.initState();
  }
}
