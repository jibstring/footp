import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class ModeController extends GetxController {
  int _mode = 0;

  int get mode => _mode;

  void press(int index) {
    _mode = index;
  }
}

class MyPosition extends GetxController {
  double _latitude = 37.566570;
  double _longitude = 126.978442;

  double get latitude => _latitude;
  double get longitude => _longitude;

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // Fluttertoast.showToast(msg: '$position')
    _latitude = position.latitude;
    _longitude = position.longitude;
    update();
  }
}

class CreateMarker extends GetxController {
  double _latitude = 37.566570;
  double _longitude = 126.978442;

  double get latitude => _latitude;
  double get longitude => _longitude;

  List<Marker> _list = [];
  List<Marker> get list => _list;

  // Marker _marker =Marker(markerId: '0', position: LatLng(_latitude, _longitude))

  // Marker tapped_marker = Marker(markerId: markerId, position: LatLng(,_longitude));

  void tapped(double a, double b) {
    _latitude = a;
    _longitude = b;
    Marker marker = Marker(markerId: 'marker1', position: LatLng(a, b));
    _list.add(marker);
    update();
  }

  // static List<CreateMarker> myMarkers(){
  //   List<CreateMarker> _list = [];
  //   // PracticeData.myStores.forEach((StoreType st) => _list.add(CustomMarker.fromMyStores(st)));

  //   return _list;
  // }
  // Future<void> createImage(BuildContext context, double a, double b) async {
  //   Marker marker = Marker(
  //       markerId: 'marker1',
  //       position: LatLng(a, b),
  //       icon: await OverlayImage.fromAssetImage(
  //           assetName: '/assets/normalfoot.png', context: context));
  //   _list.add(marker);
  //   update();
  //   // this.icon = await OverlayImage.fromAssetImage(assetName: '/assets/normalfoot.png', context: context);
  // }
}

// class MyMarker extends Marker {
//   List<Marker>? _markers;
// }

// class PracticeData {
//   static final List<dataType> myStores = [
//     mark(
//       snsLink: "http://www.instagram.com/little_victory_sweets",
//       phoneNumber: "0507-1408-1429",
//       address: "서울 마포구 연희로1길 41",
//       detailInfo: "파티쉐와 요리사부부가 운영하는 연남동에 위치한 작은 디저트카페입니다.",
//       uid: "1",
//       storeName: "리틀빅토리",
//       location: LatLng(37.560746, 126.925701),
//     ),
//   ];

//   static List<CreateMarker> myMarkers(){
//     List<CreateMarker> _list = [];
//     PracticeData.myStores.forEach((StoreType st) => _list.add(CustomMarker.fromMyStores(st)));
//     return _list;
//   }

