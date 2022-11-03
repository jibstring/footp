import 'package:flutter/material.dart';
import 'package:app_footp/components/createFoot/footForm.dart';
import 'package:app_footp/components/createFoot/normalForm.dart';
import 'package:app_footp/components/createFoot/quizForm.dart';
import 'package:get/get.dart';

import 'custom_class/store_class/store.dart';

const List<Widget> types = <Widget>[Text('일반'), Text('이벤트')];

class CreateFoot extends StatelessWidget {
  const CreateFoot({super.key});

  static const String _title = 'ToggleButtons Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: ToggleButtonsSample(title: _title),
    );
  }
}

class ToggleButtonsSample extends StatefulWidget {
  const ToggleButtonsSample({super.key, required this.title});

  final String title;

  @override
  State<ToggleButtonsSample> createState() => _ToggleButtonsSampleState();
}

class _ToggleButtonsSampleState extends State<ToggleButtonsSample> {
  final List<bool> _selectedTypes = <bool>[true, false];
  bool vertical = false;
  MyPosition myPosition_main = Get.put(MyPosition());

  @override
  void initState() {
    // TODO: implement initState
    myPosition_main.getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    ModeController modeController1 = Get.put(ModeController());

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(height: 5),
                  ToggleButtons(
                    direction: vertical ? Axis.vertical : Axis.horizontal,
                    onPressed: (int index) {
                      // myPosition_main.getCurrentLocation();
                      setState(() {
                        for (int i = 0; i < _selectedTypes.length; i++) {
                          _selectedTypes[i] = i == index;
                        }
                        modeController1.press(index);
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedBorderColor: Colors.indigo[100],
                    selectedColor: Colors.black,
                    fillColor: Colors.indigo[100],
                    color: Colors.black45,
                    constraints: const BoxConstraints(
                      minHeight: 30.0,
                      minWidth: 80.0,
                    ),
                    isSelected: _selectedTypes,
                    children: types,
                  ),
                  Container(
                      child: _selectedTypes[0] == true
                          ? NormalForm()
                          : QuizForm()),
                ],
              ),
            )));
  }
}
