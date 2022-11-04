import 'package:app_footp/components/userSetting/nicknameSetting.dart';
import 'package:app_footp/mainMap.dart';
import 'package:flutter/material.dart';
import 'package:app_footp/setting.dart';

class MyPage extends StatelessWidget {
  const MyPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'MyPage',
      debugShowCheckedModeBanner: false,
      home: const MyHompageState(),
    
    );
  }
}
class MyHompageState extends StatefulWidget {
  const MyHompageState({super.key});

  @override
  State<MyHompageState> createState() => _MyHompageStateState();
}

class _MyHompageStateState extends State<MyHompageState> {
  String userName="역삼요정";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,       
        elevation: 0,
        leading:IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color : Colors.blue[100],
            size:40,
          ),
          padding: const EdgeInsets.fromLTRB(10,0,0,0),
          onPressed:(){
            Navigator.push(
              context,
              MaterialPageRoute(builder:  (context) => const mainMap()),
            );
          },
          ),
        actions:[
          IconButton(
          icon: Icon(
            Icons.settings,
            color : Colors.blue[100],
            size:40,
          ),
          padding: const EdgeInsets.fromLTRB(0,0,10,0),
          onPressed:(){
            Navigator.push(
              context,
              MaterialPageRoute(builder:  (context) => const SettingPage()),
            );
          },
          ) 
        ]
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            //닉네임
            Row(
              children: [
                SizedBox(width: 20,),
                Text(
                  userName,
                  style: TextStyle(
                     fontSize: 30
                    ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color : Color.fromARGB(255, 174, 174, 174),
                    size:30,
                  ),
                  padding: const EdgeInsets.fromLTRB(0,0,10,0),
                  onPressed:(){
                    setState(() {
                      showDialog(context: context, builder: (context){
                      return const NicknameSetting();
                    });
                    
                  });
                  },
                )
              ]
            ),

          ],
        ),
      ),
    );
  }
}