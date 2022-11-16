import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
// import 'src/web_view_stack.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:log_print/log_print.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

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
  static const platform = MethodChannel('fcm_default_channel');

  Future<void> paySuccessMessage(BuildContext context) async {
    return showDialog<void>(
        context: context,
        // 사용자가 다이얼로그 바깥을 터치하면 닫히지 않음
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("풋포인트 충전 완료"),
            actions: <Widget>[
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  // 다이얼로그 닫기
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future getAppUrl(String url) async {
    await platform.invokeMethod('getAppUrl', <String, Object>{'url': url}).then(
        (value) async {
      LogPrint('paring url : $value');

      if (value.toString().startsWith('ispmobile://')) {
        await platform.invokeMethod(
            'startAct', <String, Object>{'url': url}).then((value) {
          LogPrint('parsing url : $value');

          return;
        });
      }

      try {
        await launch(value.toString());

        return;
      } catch (e) {
        // showNotiDialog(context, '해당 앱 설치 후 이용바랍니다.');
        Fluttertoast.showToast(msg: "해당 앱 설치 후 이용바랍니다.");
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: user.Mypayurl,
        onWebResourceError: (error) => {
          LogPrint("${error.description}"),
          Navigator.of(context).pop(),
          paySuccessMessage(context),
          user.paySuccess()
        },
        navigationDelegate: (request) async {
          LogPrint('navigate url : ${request.url}');

          if (request.url.indexOf("pg_token") != -1) {
            LogPrint("pg");
            var uri =
                Uri.dataFromString(request.url); //converts string to a uri
            Map<String, String> params =
                uri.queryParameters; // query parameters automatically populated
            String? pgToken = params['pg_token'];
            LogPrint("$pgToken");

            var url = Uri.http("k7a108.p.ssafy.io:8080", "/pay/kakaoPaySuccess",
                {"pg_token": "$pgToken"});

            // LogPrint("${url.toString()}");
            final response = await http.get(url);
          } else {
            // 2 채널이용
            if (!request.url.startsWith('http') &&
                !request.url.startsWith('https')) {
              if (Platform.isAndroid) {
                getAppUrl(request.url.toString());

                return NavigationDecision.prevent;
              } else if (Platform.isIOS) {
                if (await canLaunchUrl(Uri.parse(request.url))) {
                  LogPrint('navigate url : ${request.url}');

                  await launchUrl(
                    Uri.parse(request.url),
                  );

                  return NavigationDecision.prevent;
                }
              }
            }
          }

          return NavigationDecision.navigate;
        },
        gestureNavigationEnabled: true,
      ),
    );
  }
}
