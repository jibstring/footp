import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:dio/dio.dart';

class QuizForm extends StatefulWidget {
  const QuizForm({super.key});

  @override
  State<QuizForm> createState() => _QuizFormState();
}

class _QuizFormState extends State<QuizForm> {
  int _currentValue = 0;
  final int _maxValue = 24;
  final int _minValue = 0;

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
      Container(
        decoration: BoxDecoration(
            border: Border.all(), color: Color.fromARGB(255, 194, 223, 237)),
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
          ],
        ),
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
            border: Border.all(), color: Color.fromARGB(255, 194, 223, 237)),
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
                  border: OutlineInputBorder(), hintText: '해설을 입력하세요'),
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
    ]));
  }
}
