import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app_footp/components/msgFoot/reportModal.dart';

class NormalFoot extends StatefulWidget {
  Map<String, dynamic> normalmsg;
  NormalFoot(this.normalmsg, {Key? key}) : super(key: key);

  @override
  State<NormalFoot> createState() => _NormalFootState();
}

class _NormalFootState extends State<NormalFoot> {
  @override
  int userId = 123;

  int heartnum = 0;
  List<String> heartList = ["imgs/heart_empty.png", "imgs/heart_color.png"];

  void heartChange() {
    setState(() {
      if (heartnum == 0) {
        heartnum = 1;
        widget.normalmsg["isMylike"] = true;
        widget.normalmsg["messageLikenum"] =
            widget.normalmsg["messageLikenum"] + 1;
      } else {
        heartnum = 0;
        widget.normalmsg["isMylike"] = false;
        widget.normalmsg["messageLikenum"] =
            widget.normalmsg["messageLikenum"] - 1;
      }
    });
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.62;
    widget.normalmsg["isMylike"] ? heartnum = 1 : heartnum = 0;

    return Card(
        child: Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.normalmsg["userNickname"],
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              Text(
                widget.normalmsg["messageWritedate"],
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          //중간
          Container(
              child: (widget.normalmsg["messageFileurl"] != 'empty')
                  ? Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child:
                              Image.network(widget.normalmsg["messageFileurl"]),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            width: width,
                            child: Text(
                              widget.normalmsg["messageText"], //100자로 제한
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ))
                      ],
                    )
                  : Container(
                    height:100,
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Text(
                        widget.normalmsg["messageText"], //100자로 제한
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                  )),
          //하단
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ReportModal(
                            widget.normalmsg["messageId"], userId);
                      });
                },
                icon: Icon(Icons.more_horiz, size: 30),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Row(children: [
                  InkWell(
                      child: Image.asset(
                        heartList[heartnum],
                        width: 30,
                        height: 30,
                      ),
                      onTap: () {
                        heartChange();
                      }),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 40,
                    //height:30,
                    child: Text(
                      widget.normalmsg["messageLikenum"].toString(),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  )
                ]),
              )
            ],
          )
        ],
      ),
    ));
  }
}
