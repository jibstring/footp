
import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'MyPage',
      home: const MyHompageState(),
    
    );
  }
}
class MyHompageState extends StatefulWidget {
  const MyHompageState({super.key});

  @override
  State<MyHompageState> createState() => _MyHompageStateState();
}

class _MyHompageStateState extends State<MyHompageState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("마이페이지"

      ),
    );
  }
}