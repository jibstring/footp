// import 'dart:async';
// import 'package:flutter/material.dart'; 
// import 'package:get/get.dart';
// import 'package:stomp_dart_client/stomp.dart';
// import 'package:stomp_dart_client/stomp_config.dart';

// Stomp stomp = Get.put(Stomp());

// class Stomp extends GetxController{
//   late StompClient stompClient;
//   var isConnect = false;
  
//   Stomp() {
//     stompClient = StompClient(
//       config: StompConfig(
//         url: 'http://localhost:8080/ws',
//         onConnect: (p0) {
//           print('소켓연결 성공');
//           stompClient.activate();
//           isConnect = true;
//         },
//       )
//     );
    
//   }

//   void sub(var eventId) {
//     stompClient.subscribe(
//       destination: '/topic/event/$eventId', 
//       callback: (p0) {
//         print("구독성공");
//       },
//     );
//   }
// }