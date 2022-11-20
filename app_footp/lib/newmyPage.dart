import 'package:app_footp/components/userSetting/newmyFoot.dart';
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

class newMyPage extends StatelessWidget {
  const newMyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'newMyPage',
      theme: ThemeData(fontFamily: 'footp'),
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
  bool myfootClick = true;
  bool mystampClick = false;
  int _selectedIndex = 0;
  final controller = Get.put(UserData());

  var dataList;
  var _dataListlen = 0;
  int _messagelistsize = 0;
  int _gatherlistsize = 0;
  String _baseURL = 'http://k7a108.p.ssafy.io:8080';
  String _apiKey = '';
  dynamic _mainDataUrl;
  dynamic _mapEdge;
  List<Marker> markers = [];
  List<OverlayImage> _footImage = [];
  late Future<Map> post;

  Future<Map> getURL() async {
    String userid = controller.userinfo["userId"].toString();
    _mainDataUrl = Uri.parse(_baseURL + '/user/myfoot/' + userid);
    print(_mainDataUrl);

    http.Response response = await http.get(_mainDataUrl);
    if (response.statusCode == 200) {
      dataList = jsonDecode(utf8.decode(response.bodyBytes));
      return dataList;
      // update();
    } else {
      print(response.statusCode);
      throw 'getMainData() error';
    }
  }

  Widget build(BuildContext context) {
    post = getURL();
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
          // leading: IconButton(
          //   icon: Icon(
          //     Icons.keyboard_backspace,
          //     color: Colors.blue[100],
          //     size: 40,
          //   ),
          //   padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
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
                  MaterialPageRoute(builder: (context) => SettingPage()),
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
                  style: TextStyle(fontSize: 32),
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
            SizedBox(height: 25),
            //내글 목록
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.065,
                  child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              myfootClick ? Colors.blue[100] : Colors.white),
                      onPressed: () {
                        setState(() {
                          mystampClick = false;
                          myfootClick = true;
                          getURL();
                        });
                      },
                      child: Text(
                        "내 글 보기",
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.065,
                  child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            mystampClick ? Colors.blue[100] : Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          mystampClick = true;
                          myfootClick = false;
                        });
                      },
                      child: Text(
                        "스탬푸",
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      )),
                ),
              ],
            ),
            Expanded(
                child: myfootClick == true
                    ? FutureBuilder<Map>(
                        future: post,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // print("데이터있데에에에에에");
                            // print(dataList["message"]);
                            return dataList["message"].length != 0
                                ? newMyFootPage(dataList)
                                : Text("발자국을 남겨보세요!");
                          } else if (snapshot.hasError) {
                            return Text(
                              "발자국을 남겨보세요!",
                            );
                          }
                          return SizedBox(
                              height: 100, child: Text("내 글을 불러오는 중입니다"));
                        },
                      )
                    : Text("스탬프모음집")),
          ],
        ),
      ),
    );
  }
}
