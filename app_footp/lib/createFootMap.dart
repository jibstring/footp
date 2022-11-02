// ignore_for_file: import_of_legacy_library_into_null_safe, unused_import, prefer_final_fields

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class MyNaverMap extends StatefulWidget {
  CreateMarker image = Get.put(CreateMarker());
  @override
  State<MyNaverMap> createState() => _MyNaverMapState();
}

class _MyNaverMapState extends State<MyNaverMap> {
  MapType _mapType = MapType.Basic;
  ModeController modeController2 = Get.put(ModeController());
  MyPosition myPosition_map = Get.put(MyPosition());
  CreateMarker createMarker = Get.put(CreateMarker());
  List png = ['asset/normalfoot.png', 'asset/eventfoot.png'];
  Marker marker = Marker(markerId: '0', position: LatLng(0, 0));
  onpress() {}

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!this.mounted) return;
      createMarker.createImage(context, modeController2.mode);
    });
    createMarker.list.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // createMarker.createImage(context);
    return Scaffold(
        appBar: AppBar(title: Text("map")),
        body: Center(
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              GetBuilder<CreateMarker>(
                builder: (_) => Container(
                  child: NaverMap(
                    onMapTap: (latLng) => {
                      // Fluttertoast.showToast(msg: '$latLng'),
                      // createMarker.createImage(context),
                      createMarker.tapped(latLng.latitude, latLng.longitude),
                    },
                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                            myPosition_map.latitude, myPosition_map.longitude),
                        zoom: 18),
                    mapType: _mapType,
                    scrollGestureEnable: false,
                    zoomGestureEnable: false,
                    markers: createMarker.list,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 100),
                width: 300,
                height: 100,
                color: Colors.white70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(png[modeController2.mode]),
                    ),
                    Text("지도를 탭하여 \n발자국을 찍으세요!",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    ElevatedButton(
                      onPressed: onpress(),
                      child: Text("쿵!"),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.deepPurple[100])),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
