import 'package:app_footp/createFootMap.dart';
import 'package:app_footp/myLocation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class QuizForm extends StatefulWidget {
  const QuizForm({super.key});

  @override
  State<QuizForm> createState() => _QuizFormState();
}

class _QuizFormState extends State<QuizForm> {
  int _currentValue = 0;
  final int _maxValue = 48;
  final int _minValue = 0;
  bool _isChecked = false;
  String showFileName = "";
  String showEventFileName = "";
  List<String> allowedFileTypes = [
    'jpg',
    'mp4',
    'txt',
    'pdf',
  ];
  List<String> allowedEventFileTypes = [
    'jpg',
  ];
  final myText = TextEditingController();
  FilePickerResult? result;
  FilePickerResult? eventResult;
  String? messageFilePath = '';
  String? eventFilePath = '';
  final myQuestion = TextEditingController();
  final myAnswer = TextEditingController();
  final eventExplain = TextEditingController();

  void getHttp() async {
    try {
      var response = await Dio().get('http://www.google.com');
      print(response);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      TextField(
        maxLines: 10,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          alignLabelWithHint: true,
          hintText: '메세지를 입력하세요',
        ),
        controller: myText,
      ),
      Container(
        height: 200,
        width: 400,
        decoration: BoxDecoration(
          border: Border.all(
            width: 5,
            color: Colors.grey,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: allowedFileTypes,
                );
                if (result != null) {
                  print('########## ${result.files.first}');
                  PlatformFile file = result.files.single;
                  String fileName = result.files.first.name;
                  // Uint8List fileBytes = result.files.first.bytes!;
                  debugPrint(fileName);
                  this.messageFilePath = result.files.single.path;
                  print('name: ${messageFilePath}');
                  // var multipartFile = await MultipartFile.fromFile(
                  //   file.path,
                  // );
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
          ],
        ),
      ),
      Container(
          child: CheckboxListTile(
        title: Text('퀴즈 내기'),
        value: _isChecked,
        onChanged: (value) {
          setState(() {
            _isChecked = value!;
            myQuestion.clear();
            myAnswer.clear();
            eventExplain.clear();
          });
        },
      )),
      Container(
          child: Column(
              // children: <Widget>[
              //   Text('시간 선택'),
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       Text('유지 시간: '),
              //       NumberPicker(
              //         value: _currentValue,
              //         minValue: _minValue,
              //         maxValue: _maxValue,
              //         step: 1,
              //         itemHeight: 100,
              //         axis: Axis.horizontal,
              //         onChanged: (value) => _currentValue = value,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           IconButton(
              //             icon: Icon(Icons.remove),
              //             onPressed: () => setState(() {
              //               final newValue = _currentValue - 1;
              //               _currentValue = newValue.clamp(_minValue, _maxValue);
              //             }),
              //           ),
              //           IconButton(
              //             icon: Icon(Icons.add),
              //             onPressed: () => setState(() {
              //               final newValue = _currentValue + 1;
              //               _currentValue = newValue.clamp(_minValue, _maxValue);
              //             }),
              //           ),
              //         ],
              //       )
              //     ],
              //   )
              // ],
              )),
      Column(
        children: <Widget>[
          if (_isChecked == true)
            Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  color: Color.fromARGB(255, 194, 223, 237)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    '퀴즈',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    '문제',
                    style: TextStyle(fontSize: 15),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: '문제를 입력하세요'),
                    maxLines: 5,
                    controller: myQuestion,
                  ),
                  Text(
                    '정답',
                    style: TextStyle(fontSize: 15),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: '정답을 입력하세요'),
                    controller: myAnswer,
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        color: Color.fromARGB(255, 194, 223, 237)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '해설',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '글',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: '해설을 입력하세요'),
                          maxLines: 5,
                          controller: eventExplain,
                        ),
                        Text(
                          '이미지',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15),
                        ),
                        Container(
                          height: 200,
                          width: 400,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 5,
                              color: Colors.grey,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  FilePickerResult? eventResult =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: allowedEventFileTypes,
                                  );
                                  if (eventResult != null) {
                                    print(
                                        '########## ${eventResult.files.first}');
                                    String eventFileName =
                                        eventResult.files.first.name;
                                    // Uint8List fileBytes = result.files.first.bytes!;
                                    debugPrint(eventFileName);
                                    this.eventFilePath =
                                        eventResult.files.single.path;
                                    print('name: ${eventFilePath}');
                                    // var multipartFile = await MultipartFile.fromFile(
                                    //   file.path,
                                    // );
                                    setState(() {
                                      showEventFileName =
                                          "Now File Name: $eventFileName";
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
                                "$allowedEventFileTypes",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                showEventFileName,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Container(
              child: IconButton(
                  onPressed: () async {
                    if (_isChecked == false) {
                      if (myText.text == '' && messageFilePath == '') {
                        final snackBar = SnackBar(
                          content: const Text('메세지 내용을 입력해주세요!'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (myText.text.length > 255) {
                        final snackBar = SnackBar(
                          content: const Text('내용은 255자 이하로 입력해주세요!'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        print(this.messageFilePath.runtimeType);
                        print('#########################');
                        var formData = FormData.fromMap({
                          'messageText': myText.text,
                          'messageFileurl': this.messageFilePath != ''
                              ? await MultipartFile.fromFile(
                                  this.messageFilePath!)
                              : '',
                          'messageLongtitude': 37.60251338193296,
                          'messageLatitude': 127.12306290392186,
                          'isQuiz': _isChecked,
                          'eventQuestion': myQuestion.text,
                          'eventAnswer': myAnswer.text,
                          'eventExplain': eventExplain.text,
                          'eventExplainurl': this.eventFilePath != ''
                              ? await MultipartFile.fromFile(
                                  this.eventFilePath!)
                              : '',
                        });
                        print('*******************************************');
                        print(formData.fields);
                        print(formData.files);
                        print(
                            '***********************************************');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateFootMap()));
                      }
                    } else {
                      if (myText.text == '' && messageFilePath == '') {
                        final snackBar = SnackBar(
                          content: const Text('메세지 내용을 입력해주세요!'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (myText.text.length > 255) {
                        final snackBar = SnackBar(
                          content: const Text('내용은 255자 이하로만 작성 가능합니다!'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (myQuestion.text == '' ||
                          myAnswer == '' ||
                          eventExplain.text == '') {
                        final snackBar = SnackBar(
                          content: const Text('퀴즈 정보를 입력해주세요!'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        print(this.messageFilePath.runtimeType);
                        print('#########################');
                        var formData = FormData.fromMap({
                          'messageText': myText.text,
                          'messageFileurl': this.messageFilePath != ''
                              ? await MultipartFile.fromFile(
                                  this.messageFilePath!)
                              : '',
                          'messageLongtitude': 37.60251338193296,
                          'messageLatitude': 127.12306290392186,
                          'isQuiz': _isChecked,
                          'eventQuestion': myQuestion.text,
                          'eventAnswer': myAnswer.text,
                          'eventExplain': eventExplain.text,
                          'eventExplainurl': this.eventFilePath != ''
                              ? await MultipartFile.fromFile(
                                  this.eventFilePath!)
                              : '',
                        });
                        print('*******************************************');
                        print(formData.fields);
                        print(formData.files);
                        print(
                            '***********************************************');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateFootMap()));
                      }
                    }
                  },
                  icon: Icon(
                    Icons.handshake,
                    size: 24,
                  ))),
          Container(
              child: ElevatedButton(
                  child: Text('메세지 파일 삭제'),
                  onPressed: (() {
                    setState(() {
                      this.messageFilePath = '';
                      this.showFileName = '';
                    });
                  }))),
          Container(
              child: ElevatedButton(
                  child: Text('퀴즈 파일 삭제'),
                  onPressed: (() {
                    setState(() {
                      this.eventFilePath = '';
                      this.showEventFileName = '';
                    });
                  })))
        ],
      )
    ]));
  }
}
