import 'package:flutter/material.dart';

class FootList extends StatefulWidget{
  const FootList({super.key});

  State<FootList> createState()=> _FootListState();
}

class _FootListState extends State<FootList> {

  int _selectedIndex = 0;
  final _valueList=['HOT','좋아요','NEW','EVENT'];
  var _selectedValue="HOT";

  Widget build(BuildContext context){
    return DraggableScrollableSheet(

        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 1,

        snap: true,
        snapSizes: [0.65],
        builder: (BuildContext context, ScrollController scrollController) {
          return Column(
            
      children:<Widget>[
        Container(
          color:Colors.blue[100],
          height: 50,
          child: Row(
            children:<Widget> [
              DropdownButton(
                value:_selectedValue,
                items: _valueList.map(
                (value){
                  return DropdownMenuItem(
                    value:value,
                    child:Text(value)
                  );
                },
              ).toList(),
              onChanged: (value){
                setState((){
                  _selectedValue=value!;
                });
              },
            ),
              IconButton(onPressed:(){}, icon: Icon(Icons.search,size:50))

            ],

      ),
        ), 
          Container(
            color: Colors.blue[100],
            height:MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            child: ListView.builder(
              controller: scrollController,
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text('Item $index'));
              },
            ),
          ),
      ]
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