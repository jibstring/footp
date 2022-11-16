
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Agreement extends StatelessWidget {
  const Agreement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.blue[100],
              size: 40,
            ),
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ),
      body: Text("푸프 약관 및 동의사항"),
      
    );
  }
}