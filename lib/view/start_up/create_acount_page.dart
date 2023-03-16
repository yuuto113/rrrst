import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tttest/model/account2.dart';
import 'package:tttest/utils/authentication.dart';
import 'package:tttest/utils/firestore/users.dart';
import 'package:tttest/utils/function_utils.dart';
import 'package:tttest/utils/widget_utils.dart';

import '../../model/acount.dart';

class CreateAcountPage extends StatefulWidget {
  const CreateAcountPage({Key? key}) : super(key: key);

  @override
  State<CreateAcountPage> createState() => _CreateAcountPageState();
}

class _CreateAcountPageState extends State<CreateAcountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController syumiController = TextEditingController();

  File? image;


  //画像を取得するメソッド


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: WidgetUtils.createAppBar("新規登録"),

      body:SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 30,),
              GestureDetector(
                onTap: ()async{
                 var result = await FunctionUtils.getImageFromGallery();
                 if(result != null){

                   setState(() {
                   image = File(result.path);
                   });

                 }
                },
                child: CircleAvatar(
                  foregroundImage: image == null? null : FileImage(image!),
                  radius: 40,
                  child: Icon(Icons.add),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "名前"
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: userIdController,
                    decoration: InputDecoration(
                        hintText: "ユーザー名"
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: selfIntroductionController,
                  decoration: InputDecoration(
                      hintText: "自己紹介"
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: passController,
                    decoration: InputDecoration(
                        hintText: "パスワード"
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "メールアドレス"
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: syumiController,
                  decoration: InputDecoration(
                      hintText: "趣味"
                  ),
                ),
              ),
              SizedBox(height: 50,),
              ElevatedButton(onPressed: () async{
                if(nameController.text.isNotEmpty && userIdController.text.isNotEmpty
                && selfIntroductionController.text.isNotEmpty
                && passController.text.isNotEmpty && emailController.text.isNotEmpty && syumiController.text.isNotEmpty
                && image != null){
                var result = await Authentication.signUp(email: emailController.text, pass: passController.text);
                   if(result is UserCredential){
                     String imagepath = await FunctionUtils.uploadImage(result.user!.uid,image!);
                     //上のif文の条件通りだった場合、newAcountというインスタンスを作る
                     Acount newAcount = Acount(
                       id: result.user!.uid,
                       name: nameController.text,
                       userId: userIdController.text,
                       selfIntroduction: selfIntroductionController.text,
                       syumi: syumiController.text,
                       imagePath: imagepath,
                     );
                     //ここでuserscollectionのdocに値をセットするメソッドを呼び出す。引数には上で作成したインスタンス。
                     var _result = await UserFireStore.setUser(newAcount);
                     if(_result == true){
                       Navigator.pop(context);
                     }

                   }

                }
              }, child: Text("アカウントを作成"))
            ],
          ),
        ),
      ),
    );
  }
}
