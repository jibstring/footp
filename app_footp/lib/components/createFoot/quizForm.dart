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
  final int _maxValue = 24;
  final int _minValue = 0;
  bool _isChecked = false;
  String showFileName = "";
  List<String> allowedFileTypes = ['jpg', 'mp4', 'txt', 'pdf'];

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
                if (result != null && result.files.isNotEmpty) {
                  String fileName = result.files.first.name;
                  Uint8List fileBytes = result.files.first.bytes!;
                  debugPrint(fileName);
                  setState(() {
                    showFileName = "Now File Name: $fileName";
                  });
                  /*
                do jobs
                 */
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
          });
        },
      )),
      Container(
          child: Column(
        children: <Widget>[
          Text('시간 선택'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('유지 시간: '),
              NumberPicker(
                value: _currentValue,
                minValue: _minValue,
                maxValue: _maxValue,
                step: 1,
                itemHeight: 100,
                axis: Axis.horizontal,
                onChanged: (value) => _currentValue = value,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => setState(() {
                      final newValue = _currentValue - 1;
                      _currentValue = newValue.clamp(_minValue, _maxValue);
                    }),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => setState(() {
                      final newValue = _currentValue + 1;
                      _currentValue = newValue.clamp(_minValue, _maxValue);
                    }),
                  ),
                ],
              )
            ],
          )
        ],
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
                  ),
                  Text(
                    '정답',
                    style: TextStyle(fontSize: 15),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: '정답을 입력하세요'),
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
                        ),
                        Text(
                          '이미지',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();
                              if (result == null) {
                                print("No file selected");
                              } else {
                                print(result.files.single.name);
                              }
                            },
                            child: Text('버튼'))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Container(
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.handshake,
                    size: 24,
                  ))),
        ],
      )
    ]));
  }
}
