import 'dart:convert';

import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:app_footp/mainMap.dart';
import 'package:app_footp/myPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CreateStamp extends StatelessWidget {
  const CreateStamp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      home: CreateStampForm(),
    );
  }
}

class CreateStampForm extends StatefulWidget {
  const CreateStampForm({super.key});

  @override
  State<CreateStampForm> createState() => _CreateStampFormState();
}

class _CreateStampFormState extends State<CreateStampForm> {
  UserData user = Get.put(UserData());
  final _valueList = [2, 3, 4, 5, 6, 7, 8];
  int _selectedValue = 2;
  List _myFootList = [];
  TextEditingController stampboardTitle = TextEditingController();
  TextEditingController stampboardMessage = TextEditingController();
  int? selectedMessage1;
  int? selectedMessage2;
  int? selectedMessage3;
  Map validationMessage = {
    1: '',
    2: '제목을 입력해주세요.',
    3: '설명을 입력해주세요.',
    4: '누락된 장소가 있습니다.',
    5: '중복된 장소가 있습니다.',
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMyFoot();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset('imgs/logo.png', height: 45),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
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
        body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              // 제목
              Container(
                child: TextField(
                  maxLength: 30,
                  controller: stampboardTitle,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: '제목을 입력하세요'),
                ),
              ),
              SizedBox(height: 20),

              // 스탬프지 선택
              DropdownButton(
                value: _selectedValue,
                items: _valueList.map(
                  (value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value.toString()),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                  });
                },
              ),

              // 스탬프 템플릿 + 내 게시글 끌어다 놓기
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://s3.ap-northeast-2.amazonaws.com/footp-bucket/stampboard/frame$_selectedValue.png'),
                  ),
                ),
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DragTarget<int>(
                      builder: (
                        BuildContext context,
                        List<dynamic> accepted,
                        List<dynamic> rejected,
                      ) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 252, 196, 192),
                            border: Border.all(color: Colors.black),
                          ),
                          height: 100.0,
                          width: 100.0,
                          child: Center(
                            child: Text('1번 장소: $selectedMessage1'),
                          ),
                        );
                      },
                      onAccept: (int data) {
                        setState(() {
                          selectedMessage1 = data;
                        });
                      },
                    ),
                    DragTarget<int>(
                      builder: (
                        BuildContext context,
                        List<dynamic> accepted,
                        List<dynamic> rejected,
                      ) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 252, 196, 192),
                            border: Border.all(color: Colors.black),
                          ),
                          height: 100.0,
                          width: 100.0,
                          child: Center(
                            child: Text('2번 장소: $selectedMessage2'),
                          ),
                        );
                      },
                      onAccept: (int data) {
                        setState(() {
                          selectedMessage2 = data;
                        });
                      },
                    ),
                    DragTarget<int>(
                      builder: (
                        BuildContext context,
                        List<dynamic> accepted,
                        List<dynamic> rejected,
                      ) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 252, 196, 192),
                            border: Border.all(color: Colors.black),
                          ),
                          height: 100.0,
                          width: 100.0,
                          child: Center(
                            child: Text('3번 장소: $selectedMessage3'),
                          ),
                        );
                      },
                      onAccept: (int data) {
                        setState(() {
                          selectedMessage3 = data;
                        });
                      },
                    ),
                  ],
                )),
              ),

              // 나의 게시글 목록
              SizedBox(height: 50),
              SingleChildScrollView(
                  child: Column(children: <Widget>[
                Text('나의 글 목록'),
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _myFootList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Draggable(
                            data: _myFootList[index]['messageId'],
                            feedback: Container(
                              child: Text(_myFootList[index]['messageText']),
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                              ),
                            ),
                            childWhenDragging: Container(
                              child: Text(_myFootList[index]['messageText']),
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                              ),
                            ),
                            child: Container(
                              child: Text(_myFootList[index]['messageText']),
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.orange[200],
                              ),
                            ),
                          ));
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    child: TextField(
                  maxLines: 5,
                  maxLength: 255,
                  controller: stampboardMessage,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: '스탬프에 대해 설명해주세요'),
                )),
                ElevatedButton(
                    onPressed: () {
                      if (createStampValidation() == 1) {
                        stampCreate();
                      } else {
                        Fluttertoast.showToast(
                            msg: validationMessage[createStampValidation()],
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.redAccent,
                            fontSize: 20.0,
                            textColor: Colors.white,
                            toastLength: Toast.LENGTH_SHORT);
                      }
                    },
                    child: Text('작성'))
              ])),
            ]))));
  }

  void loadMyFoot() async {
    var dio = DIO.Dio();
    var response = await dio.get(
        'http://k7a108.p.ssafy.io:8080/user/myfoot/${user.userinfo["userId"]}');
    print("####################################");
    print(response.data['message']);
    print("######################################");
    setState(() {
      _myFootList = response.data['message'];
    });
  }

  void stampCreate() async {
    var dio = DIO.Dio();
    var url = Uri.parse('http://k7a108.p.ssafy.io:8080/stamp/create');

    dio.options.contentType = 'multipart/form-data';
    dio.options.maxRedirects.isFinite;
    var stampboardContent = {
      "userId": user.userinfo["userId"],
      "stampboardTitle": stampboardTitle.text,
      "stampboardText": stampboardMessage.text,
      "stampboardMessage1": selectedMessage1,
      "stampboardMessage2": selectedMessage2,
      "stampboardMessage3": selectedMessage3,
      "stampboardDesigncode": _selectedValue,
    };
    DIO.FormData formData = DIO.FormData.fromMap({
      "stampboardContent": json.encode(stampboardContent),
    });

    var response = await dio.post(url.toString(), data: formData);

    print('################################################');
    print(formData.fields);
    print(response);
    print('##############################################');
    await Fluttertoast.showToast(
        msg: '새로운 스탬푸 시트가 작성되었습니다.',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.lightGreenAccent,
        fontSize: 20.0,
        textColor: Colors.black,
        toastLength: Toast.LENGTH_SHORT);
    Navigator.push(context, MaterialPageRoute(builder: (context) => MainMap()));
  }

  // 유효성 검사
  int createStampValidation() {
    /*
    1: 올바른 형식
    2: 제목 미입력
    3: 내용 미입력
    4: 장소 누락
    5: 장소 중복 
    */
    if (stampboardTitle.text.trim() == '') {
      return 2;
    } else if (stampboardMessage.text.trim() == '') {
      return 3;
    } else if (selectedMessage1 == null ||
        selectedMessage2 == null ||
        selectedMessage3 == null) {
      return 4;
    } else if ((selectedMessage1 == selectedMessage2) ||
        (selectedMessage1 == selectedMessage3) ||
        (selectedMessage2 == selectedMessage3)) {
      return 5;
    } else {
      return 1;
    }
  }
}
