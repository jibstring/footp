import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NormalForm extends StatefulWidget {
  const NormalForm({super.key});

  @override
  State<NormalForm> createState() => _NormalFormState();
}

class _NormalFormState extends State<NormalForm> {
  @override
  Widget build(BuildContext context) {
    return Text('노말이면 공개범위 선택');
  }
}
