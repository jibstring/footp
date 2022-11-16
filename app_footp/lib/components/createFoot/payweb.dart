import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
// import 'src/web_view_stack.dart';


void main() {
  runApp(
    const MaterialApp(
      home: payweb(),
    ),
  );
}

class payweb extends StatefulWidget {
  const payweb({Key? key}) : super(key: key);

  @override
  State<payweb> createState() => _paywebState();
}

class _paywebState extends State<payweb> {

  UserData user = Get.put(UserData());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Flutter WebView'),
      // ),
      body: WebView(
        initialUrl: "https://m.naver.com",
        // javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
      ),
    );
  }
}