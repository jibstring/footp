import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NormalForm extends StatefulWidget {
  const NormalForm({super.key});

  @override
  State<NormalForm> createState() => _NormalFormState();
}

enum OpenRange { all, me }

class _NormalFormState extends State<NormalForm> {
  OpenRange _openRange = OpenRange.all;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          '공개 범위',
          style: TextStyle(fontSize: 15),
          textAlign: TextAlign.start,
        ),
        Row(children: <Widget>[
          Expanded(
            child: RadioListTile(
              title: Text('전체 공개'),
              value: OpenRange.all,
              groupValue: _openRange,
              onChanged: (value) {
                setState(() {
                  _openRange = value!;
                });
              },
            ),
          ),
          Expanded(
            child: RadioListTile(
              title: Text('나만 보기'),
              value: OpenRange.me,
              groupValue: _openRange,
              onChanged: (value) {
                setState(() {
                  _openRange = value!;
                });
              },
            ),
          )
        ]),
      ],
    ));
  }
}
