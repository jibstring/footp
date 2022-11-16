// ignore_for_file: unnecessary_this

import 'dart:convert';

import 'package:app_footp/components/createFoot/payweb.dart';
import 'package:app_footp/createFoot.dart';
import 'package:app_footp/createFootMap.dart';
import 'package:app_footp/main.dart';
import 'package:app_footp/myLocation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart' as DIO;
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scaled_list/scaled_list.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:webview_flutter/webview_flutter.dart';

final List<String> imgList = [
  "asset/band.png",
  "asset/band.png",
  "asset/band.png",
  "asset/band.png",
  "asset/band.png",
];

class megaPhoneForm extends StatefulWidget {
  const megaPhoneForm({super.key});

  @override
  State<megaPhoneForm> createState() => _megaPhoneFormState();
}

class _megaPhoneFormState extends State<megaPhoneForm> {
  CreateMarker createMarker = Get.put(CreateMarker());
  String showFileName = "";
  List<String> allowedFileTypes = ['jpg', 'mp3', 'mp4'];
  final myMegaText = TextEditingController();
  FilePickerResult? result;
  String? filePath = '';
  UserData user = Get.put(UserData());
  var _timeresult = "종료 시간 설정";
  var _timeresultindex;
  var _categoryresult = "슬라이드로 카테고리 설정";
  var _categoryindex;
  String _payurl = "";

  addtime() {
    final today = DateTime.now();
    var addDate;
    switch (_timeresultindex) {
      case 0:
        {
          addDate = today.add(const Duration(hours: 1));
          return addDate.toString();
        }
      case 1:
        {
          addDate = today.add(const Duration(hours: 2));
          return addDate.toString();
        }
      case 2:
        {
          addDate = today.add(const Duration(hours: 3));
          return addDate.toString();
        }
      case 3:
        {
          addDate = today.add(const Duration(hours: 6));
          return addDate.toString();
        }
      case 4:
        {
          addDate = today.add(const Duration(hours: 12));
          return addDate.toString();
        }
      case 5:
        {
          addDate = today.add(const Duration(days: 1));
          return addDate.toString();
        }
      case 6:
        {
          addDate = today.add(const Duration(days: 2));
          return addDate.toString();
        }
      case 7:
        {
          addDate = today.add(const Duration(days: 7));
          return addDate.toString();
        }
      case 8:
        {
          addDate = today.add(const Duration(days: 36500));
          return addDate.toString();
        }
    }
  }

  Future<WebView> _paypage(BuildContext context, url) async {
    return WebView(
      initialUrl: url,
    );
  }

  Future<void> _neverSatisfied(BuildContext context) async {
    final _items = [
      "1시간",
      "2시간",
      "3시간",
      "6시간",
      "12시간",
      "하루",
      "이틀",
      "일주일",
      "평생"
    ];
    var result = _items[0]; // 기본값 0
    return showDialog<void>(
        context: context,
        // 사용자가 다이얼로그 바깥을 터치하면 닫히지 않음
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blue[100],
            title: Text(
              "시간 설정",
              style: TextStyle(color: Colors.blue[900]),
            ),
            content: SingleChildScrollView(
              child: Container(
                height: 150.0,
                child: CupertinoPicker(
                  children: _items
                      .map((e) => Text(
                            '$e',
                            style: TextStyle(color: Colors.blue[900]),
                          ))
                      .toList(),
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int value) {
                    result = _items[value];
                    setState(() {
                      _timeresult = result;
                      _timeresultindex = value;
                    });
                  },
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  // 다이얼로그 닫기
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  //돈없음
  Future<void> _NoCash(BuildContext context) async {
    return showDialog<void>(
        context: context,
        // 사용자가 다이얼로그 바깥을 터치하면 닫히지 않음
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("풋포인트 부족"),
            content: Text("충전하시겠습니까?"),
            actions: <Widget>[
              TextButton(
                child: const Text('예'),
                onPressed: () {
                  // 다이얼로그 닫기
                  DoPay();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('아니요'),
                onPressed: () {
                  // 다이얼로그 닫기
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  DoPay() async {
    var url = Uri.parse(
        'http://k7a108.p.ssafy.io:8080/pay/kakaoPay/${user.userinfo['userId']}');

    // var data = DIO.FormData.fromMap({
    //   'messageContent': json.encode(createMarker.newmarker),

    var response = await http.post(url);

    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    print(response);
    print(response.body);
    Map<String, dynamic> result = json.decode(response.body);
    _payurl = result["next_redirect_app_url"];
    print('payurl : $_payurl');
    user.payurlSet(_payurl);

     Navigator.push(context,
                  MaterialPageRoute(builder: (context) => payweb()));
    // final Uri _url = Uri.parse(_payurl);
    // try{
    //   await launchUrlString(_payurl);
    // }catch(e){
    //   print(e.toString());
    // }
    // Uri realUri = await resolveRedirection(url: 'https://www.naver.com/');

    // _paypage(context, "https://www.naver.com/");
    // try {
    //   await launch(_payurl).then((value) => print("@@@@@@@@@@@@@@@@@@@@@@@${value.runtimeType}"));
    // } catch (e) {
    //   print('!@!@!@!@!@!@!@!@!@!@!@!@${e.toString()}');
    // }
    
    // AndroidIntent intent = AndroidIntent(
    //   action: 'action_view',
    //   data: result['next_redirect_app_url'],
    //   arguments: {'txn_id': result['tid']},
    // );
    // print("a2wefkwjahfqwueafdg${intent.data}");
    // await intent.launch().then((velue) => print("aaaaaaaaaaaaa"));
    // print("a2wefkwjahfqwueafdg${intent.data}");
    // print(intent.data);
    // await Navigator.of(context).push(MaterialPageRoute(
    //               builder: (BuildContext context) => Scaffold(
    //                   appBar: AppBar(
    //                     title: Text("PAY"),
    //                   ),
    //                   body: WebView(
    //                     initialUrl: "https://www.naver.com/",
    //                     javascriptMode: JavascriptMode.unrestricted,
    //                   ))));
  }

  Future<Uri> resolveRedirection({String? url}) async {
    Dio dio = new Dio();
    dio.options.followRedirects = true;
    dio.options.responseType = ResponseType.plain;
    DIO.Response response = await dio.get(url.toString());
    return response.realUri;
  }

  GoPayUrl() async {
    final Uri _url = Uri.parse('https://flutter.dev');

    // String payurl = 'https://www.naver.com/';
    try {
      await launchUrlString(_payurl);
    } catch (e) {
      print(e.toString());
    }
  }

  List<BannerModel> listBanners = [
    BannerModel(imagePath: "asset/catagories_band.png", id: "공연"),
    BannerModel(imagePath: "asset/catagories_event.png", id: "행사"),
    BannerModel(imagePath: "asset/catagories_food.png", id: "맛집"),
    BannerModel(imagePath: "asset/catagories_travel.png", id: "관광"),
    BannerModel(imagePath: "asset/catagories_friend.png", id: "친목"),
  ];

  @override
  Widget build(BuildContext context) {
    // ModeController modeController1 = Get.put(ModeController());
    // MyPosition myPosition_main = Get.put(MyPosition());
    // CreateMarker createMarker = Get.put(CreateMarker());
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 20),
        BannerCarousel(
          banners: listBanners,
          customizedIndicators: IndicatorModel.animation(
              width: 20, height: 5, spaceBetween: 2, widthAnimation: 50),
          height: 150,
          activeColor: Colors.blue[200],
          disableColor: Colors.white,
          animation: true,
          borderRadius: 10,
          width: 250,
          indicatorBottom: false,
          onPageChanged: (value) {
            setState(() {
              _categoryindex = value;
              _categoryresult = listBanners[value].id;
            });
          },
        ),

        SizedBox(height: 20),
        Text(
          "$_categoryresult",
          style: TextStyle(fontSize: 20, color: Colors.blue),
        ),
        SizedBox(height: 20),

        TextField(
          maxLines: 6,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            alignLabelWithHint: true,
            hintText: '메세지를 입력하세요',
          ),
          controller: myMegaText,
        ),
        Container(
          height: 120,
          width: 400,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: allowedFileTypes,
                  );
                  if (result != null) {
                    print('########## ${result.files.first}');
                    PlatformFile file = result.files.single;
                    String fileName = result.files.first.name;
                    // Uint8List fileBytes = result.files.first.bytes!;
                    debugPrint(fileName);
                    filePath = result.files.first.path;
                    // var multipartFile = await MultipartFile.fromFile(
                    //   file.path,
                    // );
                    print('-----------------------------------');
                    print(filePath);
                    createMarker.filePath = filePath!;
                    print('--------------------------------------');
                    setState(() {
                      showFileName = "Now File Name: $fileName";
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Find and Upload",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                    Icon(
                      Icons.upload_rounded,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Text(
                "$allowedFileTypes",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                showFileName,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Container(
                  child: TextButton(
                      child: Text(
                        '파일 삭제',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: (() {
                        setState(() {
                          this.filePath = '';
                          this.showFileName = '';
                        });
                      })))
            ],
          ),
        ),
        TextButton(
            onPressed: () async {
              const String _url = 'https://www.naver.com';
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Scaffold(
                      appBar: AppBar(
                        title: Text("PAY"),
                      ),
                      body: Container(
                        child: WebView(
                          initialUrl: "https://www.naver.com/",
                          javascriptMode: JavascriptMode.unrestricted,
                        ),
                      ))));

              // await Navigator.of(context).push<String>(MaterialPageRoute(
              //     builder: (BuildContext context) => Scaffold(
              //         appBar: AppBar(
              //           title: Text("PAY"),
              //         ),
              //         body: WebView(
              //           initialUrl: _url,
              //           javascriptMode: JavascriptMode.unrestricted,
              //         ))));
            },
            child: Text("충전")),
        SizedBox(height: 20),
        CupertinoButton(
          child: Text("$_timeresult"),
          onPressed: () {
            _neverSatisfied(context);
          },
        ),
        // CupertinoButton(
        //   child: Text("$_categoryresult"),
        //   onPressed: () {
        //     _categorieselect(context);
        //   },
        // ),
        // Text("$_timeresult"),
        Container(
            child: IconButton(
          onPressed: () async {
            if (this.filePath == '' && myMegaText.text.trim() == '') {
              final snackBar = SnackBar(
                content: const Text('내용을 입력하거나 파일을 첨부해주세요!'),
                action: SnackBarAction(
                  label: '확인',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (myMegaText.text.length > 255) {
              final snackBar = SnackBar(
                content: const Text('내용은 255자 이하로만 작성 가능합니다.!'),
                action: SnackBarAction(
                  label: '확인',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (_timeresultindex == null) {
              final snackBar = SnackBar(
                content: const Text('종료 시간을 설정해 주세요!'),
                action: SnackBarAction(
                  label: '확인',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (_categoryindex == null) {
              final snackBar = SnackBar(
                content: const Text('카테고리를 설정해 주세요!'),
                action: SnackBarAction(
                  label: '확인',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (user.userinfo['userCash'] < 50000) {
              // _NoCash(context);
              _NoCash(context);
              // GoPayUrl();
            } else {
              createMarker.newmegaphone['gatherText'] = myMegaText.text;

              DIO.MultipartFile? file = this.result != null
                  ? await DIO.MultipartFile.fromFile(this.filePath!)
                  : null;

              createMarker.newmegaphone['userId'] = user.userinfo["userId"];

              String finishdate = addtime();

              var i = finishdate.lastIndexOf(':');
              finishdate = finishdate.substring(0, i);
              finishdate = finishdate.replaceFirst(' ', 'T');

              createMarker.newmegaphone['gatherFinishdate'] = finishdate;

              createMarker.newmegaphone['gatherDesigncode'] = _categoryindex;

              createMarker.file = file;

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateFootMap()));
            }
          },
          icon: Image.asset('asset/megaphone.png'),
          iconSize: 75,
        )),
      ],
    ));
  }
}
