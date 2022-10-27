import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:app_footp/createFoot.dart';

void main() {
  runApp(const mainMap());
}

class mainMap extends StatelessWidget {
  const mainMap({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pootf',
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


  //목록 
  static List<Widget> widgetOptions = <Widget>[
    //발자국 목록
    DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.2,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Colors.blue[100],
          child: ListView.builder(
            controller: scrollController,
            itemCount: 25,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(title: Text('Item $index'));
            },
          ),
        );
      },
    ),
    //채팅 방
    DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.2,
      maxChildSize: 1,
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:Image.asset('imgs/logo.png',height:45),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions:<Widget>[
          IconButton(
            icon:Icon(
              Icons.account_circle,
              color:Color.fromARGB(255, 153, 181, 229),
              size: 40,
            ),
            padding:const EdgeInsets.only(top:5,right:20.0),
            onPressed:(){},
           ),
        ],
      ),
      body: SizedBox.expand(
          child: Stack(children: <Widget>[
        NaverMap(
          onMapCreated: _onMapCreated,
        ),
        Container(child: widgetOptions.elementAt(_selectedIndex)),
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
          ),
        )
      ])),
    );
  }

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
}

