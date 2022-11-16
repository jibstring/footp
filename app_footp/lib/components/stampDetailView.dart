import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:app_footp/myPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class StampDetailView extends StatefulWidget {
  const StampDetailView({super.key});

  @override
  State<StampDetailView> createState() => _StampDetailViewState();
}

class _StampDetailViewState extends State<StampDetailView> {
  JoinStampInfo joinedStamp = Get.put(JoinStampInfo());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset('imgs/logo.png', height: 45),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: Color.fromARGB(255, 153, 181, 229),
                size: 40,
              ),
              padding: const EdgeInsets.only(top: 5, right: 20.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyPage()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back))
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  height: 400,
                  child: Center(
                    child: Text('지도들어가요'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                  ),
                  child: Text(joinedStamp.message1["messageText"]),
                ),
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                ),
                child: Text(joinedStamp.message2["messageText"]),
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                ),
                child: Text(joinedStamp.message3["messageText"]),
              ),
              Row(
                children: [TextButton(onPressed: () {}, child: Text('참가하기'))],
              )
            ],
          ),
        ));
  }
}
