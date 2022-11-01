import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

final formKey = GlobalKey<FormState>();

class _SignUpState extends State<SignUp> {
  final myEmail = TextEditingController();
  final passwordOne = TextEditingController();
  final passwordTwo = TextEditingController();
  bool _value = false;
  bool obscurePasswordOne = false;
  bool obscurePasswordTwo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: formKey,
      child: Center(
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    children: <Widget>[
                      EmailInputForm(TextInputType.emailAddress, '이 메일'),
                      PasswordOneInputForm(passwordOne),
                      PasswordTwoInputForm(passwordTwo),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(176, 179, 223, 1),
                          ),
                          onPressed: () {},
                          child: Text('가입 버튼',
                              style: TextStyle(color: Colors.white))),
                      Text('하이'),
                      Text('$obscurePasswordOne'),
                      Text('$obscurePasswordTwo'),
                    ],
                  )))),
    ));
  }

  Widget TextFormFieldComponent(bool obscureText, TextInputType keyboardType,
      String hintText, int maxSize, String errorMessage) {
    return Container(
        child: TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.blue),
        ),
        hintText: hintText,
      ),
      validator: (value) {
        if (value!.length < maxSize) {
          return errorMessage;
        }
      },
    ));
  }

  // Future<void> _submit() async {
  //   if (formKey.currentState!.validate() == false) {
  //     return;
  //   } else {
  //     formKey.currentState!.save();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('가입이 완료되었습니다.'),
  //         duration: Duration(seconds: 1),
  //       ),
  //     );
  //     Navigator.of(context).pop();
  //   }
  // }

  Widget EmailInputForm(TextInputType keyboardType, String hintText) {
    return Container(
        child: TextFormField(
      controller: myEmail,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.blue),
          ),
          suffixIcon: _value != true
              ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _value = !_value;
                    });
                  },
                  child: Text('인증'),
                )
              : Icon(
                  Icons.check_box_outlined,
                  color: Colors.green,
                )),
      onChanged: (value) {
        setState(() {
          _value = false;
        });
      },
    ));
  }

  Widget PasswordOneInputForm(TextEditingController controller) {
    return Container(
        child: TextFormField(
            obscureText: obscurePasswordOne,
            controller: controller,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                suffixIcon: obscurePasswordOne == true
                    ? IconButton(
                        icon: Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obscurePasswordOne = !obscurePasswordOne;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            obscurePasswordOne = !obscurePasswordOne;
                          });
                        },
                      ))));
  }

  Widget PasswordTwoInputForm(TextEditingController controller) {
    return Container(
        child: TextFormField(
            obscureText: obscurePasswordTwo,
            controller: controller,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                suffixIcon: obscurePasswordTwo == true
                    ? IconButton(
                        icon: Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obscurePasswordTwo = !obscurePasswordTwo;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            obscurePasswordTwo = !obscurePasswordTwo;
                          });
                        },
                      ))));
  }
}
