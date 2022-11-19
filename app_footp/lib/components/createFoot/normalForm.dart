// ignore_for_file: unnecessary_this

import 'package:app_footp/createFootMap.dart';
import 'package:app_footp/main.dart';
import 'package:app_footp/myLocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart' as DIO;
import 'package:app_footp/custom_class/store_class/store.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:log_print/log_print.dart';
// import 'package:get/get.dart';
// import 'package:get/get.dart';

class NormalForm extends StatefulWidget {
  const NormalForm({super.key});

  @override
  State<NormalForm> createState() => _NormalFormState();
}

enum OpenRange { all, me, blur }

class _NormalFormState extends State<NormalForm> {
  CreateMarker createMarker = Get.put(CreateMarker());
  OpenRange _openRange = OpenRange.all;
  bool _isblurred = false;
  String showFileName = "";
  List<String> allowedFileTypes = ['jpg', 'mp3', 'mp4'];
  final myText = TextEditingController();
  final myBlurredText = TextEditingController();
  FilePickerResult? result;
  String? filePath = '';
  UserData user = Get.put(UserData());
  bool _isopen = true;
  bool _ismyself = false;
  bool _issecret = false;

  @override
  Widget build(BuildContext context) {
    // ModeController modeController1 = Get.put(ModeController());
    // MyPosition myPosition_main = Get.put(MyPosition());
    // CreateMarker createMarker = Get.put(CreateMarker());
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 60),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Expanded(
              //   child: RadioListTile(
              //     title: Image.asset("asset/open.png"),
              //     value: OpenRange.all,
              //     groupValue: _openRange,
              //     onChanged: (value) {
              //       setState(() {
              //         _openRange = value!;
              //         _isblurred = false;
              //       });
              //     },
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: _isopen ? Colors.amber : Colors.white10,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isopen = true;
                      _ismyself = false;
                      _issecret = false;
                      _isblurred = false;
                    });
                  },
                  icon: Image.asset("asset/open.png"),
                  color: _isopen ? Colors.amber : Colors.white,
                  splashColor: Colors.white10,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: _ismyself ? Colors.amber : Colors.white10,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isopen = false;
                      _ismyself = true;
                      _issecret = false;
                      _isblurred = false;
                    });
                  },
                  icon: Image.asset("asset/myself.png"),
                  color: _ismyself ? Colors.amber : Colors.white,
                  splashColor: Colors.white10,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: _issecret ? Colors.amber : Colors.white10,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isopen = false;
                      _ismyself = false;
                      _issecret = true;
                      _isblurred = true;
                    });
                  },
                  icon: Image.asset("asset/question.png"),
                  color: _issecret ? Colors.amber : Colors.white,
                  splashColor: Colors.white10,
                ),
              ),
              // Expanded(
              //   child: RadioListTile(
              //     title: Image.asset("asset/myself.png"),
              //     value: OpenRange.me,
              //     groupValue: _openRange,
              //     onChanged: (value) {
              //       setState(() {
              //         _openRange = value!;
              //         _isblurred = false;
              //       });
              //     },
              //   ),
              // ),
              // Expanded(
              //   child: RadioListTile(
              //     title: Image.asset("asset/question.png"),
              //     value: OpenRange.blur,
              //     groupValue: _openRange,
              //     onChanged: (value) {
              //       setState(() {
              //         _openRange = value!;
              //         _isblurred = true;
              //       });
              //     },
              //   ),
              // ),
            ]),
        SizedBox(
          height: 30,
        ),
        Container(
            height: 250,
            width: 400,
            decoration: BoxDecoration(
              border: Border.all(
                width: 8,
                color: Colors.black,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                _isblurred
                    ? Container(
                        child: Column(
                          children: [
                            TextField(
                              maxLines: 3,
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                hintText: '  메세지를 입력하세요',
                              ),
                              controller: myText,
                            ),
                            TextField(
                              maxLines: 3,
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                hintText: '  멀리서 볼 수 없는 메시지 입니다',
                              ),
                              controller: myBlurredText,
                            ),
                          ],
                        ),
                      )
                    : TextField(
                        maxLines: 7,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          hintText: '  메세지를 입력하세요',
                        ),
                        controller: myText,
                      ),
                SizedBox(height: 20),
                Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: allowedFileTypes,
                          );
                          if (result != null) {
                            print('########## ${result.files.first}');
                            PlatformFile file = result.files.single;
                            String fileName = result.files.first.name;
                            // Uint8List fileBytes = result.files.first.bytes!;
                            debugPrint(fileName);
                            filePath = result.files.first.path;
                            // var multipartFile = await MultipartFile.fromFile(
                            //   file.path,
                            // );
                            print('-----------------------------------');
                            print(filePath);
                            createMarker.filePath = filePath!;
                            print('--------------------------------------');
                            setState(() {
                              showFileName = "Now File Name: $fileName";
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("asset/media.png")
                            // Text(
                            //   "Find and Upload",
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.grey,
                            //     fontSize: 20,
                            //   ),
                            // ),
                            // Icon(
                            //   Icons.upload_rounded,
                            //   // color: Colors.grey,
                            // ),
                          ],
                        ),
                      ),
                      // Text(
                      //   "$allowedFileTypes",
                      //   style: TextStyle(
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: Text(
                          showFileName,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      if (filePath != '')
                        Container(
                            child: TextButton(
                                child: Text(
                                  'X',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: (() {
                                  setState(() {
                                    this.filePath = '';
                                    this.showFileName = '';
                                  });
                                })))
                    ]),
              ],
            )),
        Container(
            decoration: BoxDecoration(),
            child: Column(
              children: [
                SizedBox(height: 10),
              ],
            )),
        SizedBox(height: 30),
        Container(
            child: IconButton(
          onPressed: () async {
            if (this.filePath == '' && myText.text.trim() == '') {
              final snackBar = SnackBar(
                content: const Text('내용을 입력하거나 파일을 첨부해주세요!'),
                action: SnackBarAction(
                  label: '확인',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (myText.text.length > 255) {
              final snackBar = SnackBar(
                content: const Text('내용은 255자 이하로만 작성 가능합니다.!'),
                action: SnackBarAction(
                  label: '확인',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              createMarker.newmarker['messageText'] = myText.text;

              createMarker.newmarker['messageBlurredtext'] = myBlurredText.text;

              if (_isopen == true)
                createMarker.newmarker['isOpentoall'] = true;
              else if (_ismyself == true)
                createMarker.newmarker['isOpentoall'] = false;

              if (_isblurred == true) {
                createMarker.newmarker['isBlurred'] = true;
                createMarker.newmarker['isOpentoall'] = true;
              }

              DIO.MultipartFile? file = this.result != null
                  ? await DIO.MultipartFile.fromFile(this.filePath!)
                  : null;

              createMarker.newmarker['userId'] = user.userinfo["userId"];

              createMarker.file = file;

              // print(formData.fields);
              // print(formData.files);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateFootMap()));
            }
          },
          icon: Image.asset('asset/foot_2.png'),
          iconSize: 75,
        )),
      ],
    ));
  }
}
