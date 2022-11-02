import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class ModeController extends GetxController {
  int _mode = 0;

  int get mode => _mode;

  void press(int index) {
    _mode = index;
    update();
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

  Marker _marker = Marker(markerId: 'marker1', position: LatLng(0, 0),width: 40,height: 40);

  void tapped(double a, double b) {
    _latitude = a;
    _longitude = b;
    Marker temp = _marker;
    temp.position = (LatLng(a, b));
    // _list.add(Marker(markerId: '$a', position: LatLng(a,b)));
    _list.insert(0, temp);
    update();
    // print('@@@@$_list)');
  }

  Future<void> createImage(BuildContext context, int i) async {
    if (i == 0) {
      _marker.icon = await OverlayImage.fromAssetImage(
          assetName: "asset/normalfoot.png");
    } else {
      _marker.icon = await OverlayImage.fromAssetImage(
          assetName: "asset/eventfoot.png");
    }
    update();
  }
}

class Data{

  int ?type; //0 == 노멀, 1 == 이벤트

  LatLng ?location;

}