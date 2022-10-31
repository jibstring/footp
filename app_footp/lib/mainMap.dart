import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_footp/createFoot.dart';
import 'package:app_footp/location.dart';
import 'package:app_footp/components/mainMap/footList.dart';

void main() {
  runApp(const mainMap());
}

class mainMap extends StatelessWidget {
  const mainMap({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FootP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Footp Main Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // 목록
  static List<Widget> widgetOptions = <Widget>[
    // 발자국 글목록
    FootList(),
    // 채팅방
    DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 1,
      snap: true,
      snapSizes: [0.65],
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Colors.red[100],
          child: ListView.builder(
            controller: scrollController,
            itemCount: 25,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(title: Text('Item $index'));
            },
          ),
        );
      },
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<NaverMapController> _controller = Completer();

  Location location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('imgs/logo.png', height: 45),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Color.fromARGB(255, 153, 181, 229),
              size: 40,
            ),
            padding: const EdgeInsets.only(top: 5, right: 20.0),
            onPressed: () {},
          ),
        ],
      ),
      body: SizedBox.expand(
          child: Stack(children: <Widget>[
        Container(
            height: (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top) *
                0.65,
            child: NaverMap(
              onMapCreated: _onMapCreated,
              minZoom: 15.0,
              maxZoom: 21.0,
              locationButtonEnable: true,
              initLocationTrackingMode: LocationTrackingMode.Follow,
              circles: [
                CircleOverlay(
                    overlayId: "radius25",
                    center: location.lng,
                    radius: 25,
                    color: Colors.transparent,
                    outlineColor: Colors.orangeAccent,
                    outlineWidth: 1),
                CircleOverlay(
                    overlayId: "radius250",
                    center: location.lng,
                    radius: 250,
                    color: Colors.transparent,
                    outlineColor: Colors.lightBlueAccent,
                    outlineWidth: 1)
              ],
            )),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Color.fromARGB(255, 153, 181, 229),
              size: 55,
            ),
            padding: EdgeInsets.fromLTRB(0, 0, 50, 300),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateFoot()),
              );
            },
          ),
        ),
        widgetOptions.elementAt(_selectedIndex),
        Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'List',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chat',
                )
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            )),
      ])),
    );
  }

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 2), (v) {
      setState(() {
        location.getCurrentLocation();
        print("wow ${location.latitude} / ${location.longitude}");
      });
    });
  }

  void setState(VoidCallback fn) {
    super.setState(fn);
  }
}
