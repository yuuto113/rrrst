

import 'package:another_flushbar/flushbar.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tttest/utils/authentication.dart';

import 'package:tttest/utils/widget_utils.dart';


class EditAccount extends StatefulWidget {

  const EditAccount({Key? key}) : super(key: key);

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  TextEditingController emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar("新規登録"),

      body:SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 30,),

              Container(
                width: 300,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "email"
                  ),
                ),
              ),


              SizedBox(height: 50,),
              ElevatedButton(onPressed: ()async{
                if(emailController.text.isNotEmpty){
                var result = Authentication.sendPasswordResetEmail(emailController.text);
                if(result == "success" ){
                  Navigator.pop(context);
                } else {
                  Flushbar(
                    message: "メール送信に失敗しました",
                    backgroundColor: Colors.red,
                    margin: EdgeInsets.all(8),
                    duration: Duration(seconds: 3),
                  )..show(context);
                }
                }

              }, child: Text("パスワード変更"))

            ],
          ),
        ),
      ),
    );
  }
}
