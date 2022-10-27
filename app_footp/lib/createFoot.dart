import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ToggleButtons with a single selection.
            const SizedBox(height: 5),
            ToggleButtons(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < _selectedTypes.length; i++) {
                    _selectedTypes[i] = i == index;
                  }
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
          ],
        ),
      ),
    );
  }
}
