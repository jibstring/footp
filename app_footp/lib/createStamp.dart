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

  List<String> stampSheetName=["기본","맛집","간식","명소","산책","야경","보물"];
  List<String> footImg=["imgs/발자국찍기_b.png","imgs/발자국찍기_g.png","imgs/발자국찍기_o.png"];

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
          title: Image.asset('imgs/로고_기본.png', height: 45),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          // 
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(40,40,40,0),
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              // 제목
              Container(
                child: TextField(
                  maxLength: 30,
                  controller: stampboardTitle,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      hintText: '제목을 입력하세요'),
                ),
              ),
              SizedBox(height: 10),
              // 스탬프지 선택
              Row(
                children: [
                  Text("스탬프지 디자인",style: TextStyle(fontSize: 15),),
                  SizedBox(width: 20,),
                  DropdownButton(
                    icon: Image.asset("./imgs/화살표_o.png",
                                        width: 40,
                                        height:40,
                                      ),
                    value: _selectedValue,
                    items: _valueList.map(
                      (value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(stampSheetName[value-2]),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                  ),
                ],
              ),

              // 스탬프 템플릿 + 내 게시글 끌어다 놓기
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
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
                          // decoration: BoxDecoration(
                          //   shape: BoxShape.circle,
                          //   color: Color.fromARGB(255, 252, 196, 192),
                          //   border: Border.all(color: Colors.black),
                          // ),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: selectedMessage1 == null
                              ? Image.asset('imgs/unknown_print.png')
                              : Image.asset(
                                  footImg[0],
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
                          // decoration: BoxDecoration(
                          //   shape: BoxShape.circle,
                          //   color: Color.fromARGB(255, 252, 196, 192),
                          //   border: Border.all(color: Colors.black),
                          // ),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: selectedMessage2 == null
                              ?
                              // Center(
                              //     child: Text('2번 장소: $selectedMessage2'),
                              //   )
                              Image.asset('imgs/unknown_print.png')
                              : Image.asset(
                                  footImg[1],
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
                          // decoration: BoxDecoration(
                          //   shape: BoxShape.circle,
                          //   color: Color.fromARGB(255, 252, 196, 192),
                          //   border: Border.all(color: Colors.black),
                          // ),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: selectedMessage3 == null
                              ? Image.asset('imgs/unknown_print.png')
                              : Image.asset(
                                  footImg[2],
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
              SizedBox(height: 10),
              SingleChildScrollView(
                child: Column(children: <Widget>[
                  Text('나의 글 목록',
                    style:
                      TextStyle(fontSize: 20),
                  ),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: _myFootList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(height:10),
                            Draggable(
                              data: _myFootList[index]['messageId'],
                              feedback: Container(
                                  // child: Text(_myFootList[index]['messageText']),
                                  // height: 40,
                                  // decoration: BoxDecoration(
                                  //   color: Colors.orange[50],
                                  // ),
                                  child: Image.asset(
                                  'imgs/스탬푸찍기_p.png',
                                // height: 50,
                              )),
                              childWhenDragging:
                                Container(
                                child: Text(_myFootList[index]['messageText'],
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,),
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                ),
                              ),
                              child: Container(
                                padding:EdgeInsets.fromLTRB(0, 0, 2, 0),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width:MediaQuery.of(context).size.width * 0.65,
                                      padding:EdgeInsets.fromLTRB(10, 2, 0, 2),
                                      child: Text(_myFootList[index]['messageText'],
                                        overflow: TextOverflow.clip)
                                    ),
                                    _myFootList[index]['messageId'] == selectedMessage1
                                    ? Align(
                                        alignment: Alignment.centerRight,
                                        child: Image.asset(footImg[0]))
                                    : 
                                    _myFootList[index]['messageId'] == selectedMessage2 
                                    ? Align(
                                        alignment: Alignment.centerRight,
                                      child: Image.asset(footImg[1]))
                                    : 
                                    _myFootList[index]['messageId'] == selectedMessage3
                                    ? Align(
                                        alignment: Alignment.centerRight,
                                      child: Image.asset(footImg[2]))
                                    : Container()
                                  ],
                                ),
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.orange[200],
                                  border: Border.all(color: Colors.black, width: 3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        );
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      child: TextField(
                      maxLines: 5,
                      maxLength: 255,
                      controller: stampboardMessage,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                          
                          hintText: '스탬프에 대해 설명해주세요'),
                    )),
                    IconButton(
                      iconSize: MediaQuery.of(context).size.width * 0.15,
                      onPressed: () {
                        if (createStampValidation() == 1) {
                          stampCreate();
                          Navigator.pop(context);
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
                      icon: Image.asset(
                        'imgs/스탬푸작성_r.png',
                      ))
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
