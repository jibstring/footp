import 'package:geolocator/geolocator.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:get/get.dart';

Location location = Get.put(Location());

class Location extends GetxController{
  double latitude = 0;
  double longitude = 0;
  LatLng lng = LatLng(0, 0);
  Location() {
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    // print(permission);
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
      lng = LatLng(latitude, longitude);
    } catch (e) {
      print(e);
    }
  }
}
