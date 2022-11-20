import 'package:app_footp/components/mainMap/stampList.dart';
import 'package:app_footp/components/msgFoot/normalFoot.dart';
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:app_footp/myPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as DIO;

class StampDetailView extends StatefulWidget {
  const StampDetailView({super.key});

  @override
  State<StampDetailView> createState() => _StampDetailViewState();
}

class _StampDetailViewState extends State<StampDetailView> {
  // JoinStampInfo joinedStamp = Get.put(JoinStampInfo());
  StampMessage stampMessage = Get.put(StampMessage());
  UserData user = Get.put(UserData());
  JoinStampInfo joinedStamp = Get.put(JoinStampInfo());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('============================================');
    print(stampMessage.stampMessage1);
    print(stampMessage.stampMessage2);
    print(stampMessage.stampMessage3);
    print(stampMessage.viewStamp);
    print('===========================================');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset('imgs/logo.png', height: 45),
          elevation: 0,
          leading: BackButton(
            color: Colors.black,
          ),
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
              Container(
                height: 400,
                child: Image.network(
                    'https://image.zdnet.co.kr/2021/01/15/e3b89e63a5a4a7d0bd44e4e9bb06e54c.png'),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Card(
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(
                            children: [
                              SizedBox(height: 12),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  stampMessage.viewStamp["stampboard_title"],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Color.fromARGB(255, 110, 110, 110)),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(color: Colors.black, thickness: 3.0),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    stampMessage.viewStamp[
                                        "stampboard_text"], //100자로 제한
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Color.fromARGB(255, 110, 110, 110)),
                                  )),
                              SizedBox(height: 20),
                            ],
                          )))),
              SizedBox(height: 10),
              NormalFoot(stampMessage.stampMessage1),
              SizedBox(height: 10),
              NormalFoot(stampMessage.stampMessage2),
              SizedBox(height: 10),
              NormalFoot(stampMessage.stampMessage3),
              SizedBox(height: 10),
              // Row(
              //   children: [
              //     joinedStamp.joinedStamp["stampboard_id"] != stampMessage.viewStamp
              //         ? TextButton(
              //             child: Text('참가하기'),
              //             onPressed: () {
              //               print(
              //                   '###########################################');
              //               print(joinedStamp.joinedStampId);
              //               print(stampMessage.viewStamp);
              //               print('######################################');
              //               joinedStamp.joinedStampId = stampMessage.viewStamp;
              //               print(joinedStamp.joinedStampId);
              //             },
              //           )
              //         : TextButton(
              //             child: Text('참가 취소',
              //                 style: TextStyle(color: Colors.red)),
              //             onPressed: () {},
              //           ),
              //   ],
              // )
            ],
          ),
        ));
  }
}
