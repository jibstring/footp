
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

class Notice {
  late StompClient stompClient;

  Notice() {
    stompClient = StompClient(
      config: StompConfig(
        url: "http://k7a108.p.ssafy.io:8080/wss",
        // url: "http://localhost:8080/wss",
        beforeConnect: () async{
          print("알리미 연결중");
        },
        onConnect:(p0) {
          print("알리미 연결 완료");
          stompClient.subscribe(
            destination: '/notice',
            callback: (frame) {
              print("내가 왔다");
            }
          );
        },
      ),
    );
    stompClient.activate();
  }
}