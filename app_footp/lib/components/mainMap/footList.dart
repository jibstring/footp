import 'package:flutter/material.dart';

class FootList extends StatefulWidget{
  const FootList({super.key});

  State<FootList> createState()=> _FootListState();
}

class _FootListState extends State<FootList> {

  int _selectedIndex = 0;

  Widget build(BuildContext context){
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 1,
      snap: true,
      snapSizes: [0.65],
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
    );

  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
}