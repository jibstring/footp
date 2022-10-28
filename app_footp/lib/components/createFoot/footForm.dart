import 'package:flutter/material.dart';

class FootForm extends StatefulWidget {
  const FootForm({super.key});

  @override
  State<FootForm> createState() => _FootFormState();
}

class _FootFormState extends State<FootForm> {
  final myText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 10,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
        hintText: '메세지를 입력하세요',
      ),
    );
  }
}
