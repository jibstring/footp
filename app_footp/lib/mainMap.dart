import 'package:flutter/material.dart';
import 'package:app_footp/createFoot.dart';
import 'package:app_footp/chatTest.dart';

class mainMap extends StatelessWidget {
  const mainMap({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("메인페이지"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              child: Text(""),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateFoot()),
                );
              },
              style: ElevatedButton.styleFrom(primary: Colors.red)),
          ElevatedButton(
              child: Text("채팅이여"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatTest()),
                );
              },
              style: ElevatedButton.styleFrom(primary: Colors.red)),
        ]),
      ),
    );
  }
}
