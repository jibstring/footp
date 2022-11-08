import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class StampList extends StatefulWidget {
  const StampList({super.key});

  @override
  State<StampList> createState() => _StampListState();
}

class _StampListState extends State<StampList> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        // return Container(
        //   color: Colors.red[100],
        //   child: ListView.builder(
        //     controller: scrollController,
        //     itemCount: 25,
        //     itemBuilder: (BuildContext context, int index) {
        //       return ListTile(title: Text('Item $index'));
        //     },
        //   ),
        // );
        return Text("스탬푸페이지");
      },
    );
  }
}
