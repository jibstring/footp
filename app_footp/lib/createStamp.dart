import 'package:app_footp/myPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CreateStamp extends StatelessWidget {
  const CreateStamp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      home: CreateStampForm(),
    );
  }
}

class CreateStampForm extends StatefulWidget {
  const CreateStampForm({super.key});

  @override
  State<CreateStampForm> createState() => _CreateStampFormState();
}

class _CreateStampFormState extends State<CreateStampForm> {
  final _valueList = [1, 2];
  int _selectedValue = 1;

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
        body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              // 제목
              Container(
                child: TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: '제목을 입력하세요'),
                ),
              ),
              SizedBox(height: 20),
              // 스탬프지 선택
              DropdownButton(
                value: _selectedValue,
                items: _valueList.map(
                  (value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value.toString()),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                  });
                },
              ),

              // 스탬프 템플릿
              Container(
                child: Image.asset('asset/templates/$_selectedValue.jpg'),
              ),

              // 나의 게시글 목록
              SizedBox(height: 50),
              SingleChildScrollView(
                  child: Column(children: <Widget>[
                Text('나의 글 목록'),
                Container(
                  height: 200,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                              height: 50,
                              color: Colors.amber[600],
                              child: const Center(child: Text('11111'))),
                          Container(
                              height: 50,
                              color: Colors.amber[500],
                              child: const Center(child: Text('22222'))),
                          Container(
                              height: 50,
                              color: Colors.amber[400],
                              child: const Center(child: Text('33333'))),
                          Container(
                              height: 50,
                              color: Colors.amber[600],
                              child: const Center(child: Text('11111'))),
                          Container(
                              height: 50,
                              color: Colors.amber[500],
                              child: const Center(child: Text('22222'))),
                          Container(
                              height: 50,
                              color: Colors.amber[400],
                              child: const Center(child: Text('33333'))),
                          Container(
                              height: 50,
                              color: Colors.amber[600],
                              child: const Center(child: Text('11111'))),
                          Container(
                              height: 50,
                              color: Colors.amber[500],
                              child: const Center(child: Text('22222'))),
                          Container(
                              height: 50,
                              color: Colors.amber[400],
                              child: const Center(child: Text('33333'))),
                          Container(
                              height: 50,
                              color: Colors.amber[600],
                              child: const Center(child: Text('11111'))),
                          Container(
                              height: 50,
                              color: Colors.amber[500],
                              child: const Center(child: Text('22222'))),
                          Container(
                              height: 50,
                              color: Colors.amber[400],
                              child: const Center(child: Text('33333'))),
                        ],
                      )),
                ),
                SizedBox(height: 20),
                Container(
                    child: TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: '스탬프에 대해 설명해주세요'),
                )),
                ElevatedButton(onPressed: () {}, child: Text('작성'))
              ])),
            ]))));
  }
}
