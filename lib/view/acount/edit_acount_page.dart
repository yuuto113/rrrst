import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tttest/model/acount.dart';
import 'package:tttest/utils/authentication.dart';
import 'package:tttest/utils/firestore/users.dart';
import 'package:tttest/utils/function_utils.dart';
import 'package:tttest/utils/widget_utils.dart';
import 'package:tttest/view/start_up/login_page.dart';

class EditAcountPage extends StatefulWidget {
  const EditAcountPage({Key? key}) : super(key: key);

  @override
  State<EditAcountPage> createState() => _EditAcountPageState();
}

class _EditAcountPageState extends State<EditAcountPage> {
  Acount myAcount = Authentication.myAcount!;
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();

  File? image;

  ImageProvider getImage(){
if(image == null){
return NetworkImage(myAcount.imagePath);
}else{
  return FileImage(image!);
}
}

  @override
  void initState() {
    nameController = TextEditingController(text: myAcount.name);
    userIdController = TextEditingController(text: myAcount.userId);
    selfIntroductionController = TextEditingController(text: myAcount.selfIntroduction);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar("プロフィール編集"),
      body:SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 30,),
              GestureDetector(
                onTap: ()async{
                var result = await  FunctionUtils.getImageFromGallery();
                if(result != null){
                  setState(() {
                    image = File(result.path);
                  });
                }

                },
                child: CircleAvatar(
                  foregroundImage: getImage(),
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

              SizedBox(height: 50,),
              ElevatedButton(onPressed: () async{
                if(nameController.text.isNotEmpty
                    && userIdController.text.isNotEmpty
                    && selfIntroductionController.text.isNotEmpty){
                  String imagePath ="";
                  if(image == null){
                imagePath = myAcount.imagePath;
                  }else{
                    var result = await FunctionUtils.uploadImage(myAcount.id, image!);
                    imagePath = result;
                  }

                  Acount updateAcount = Acount(
                    id: myAcount.id,
                    name:nameController.text,
                    userId: userIdController.text,
                    selfIntroduction: selfIntroductionController.text,
                    imagePath: imagePath
                  );
                  Authentication.myAcount = updateAcount;

                  var result = await UserFireStore.updateUser(updateAcount);
                  if(result == true){
                    Navigator.pop(context,result);
                  }

                }
              }, child: Text("更新")),


              ElevatedButton(onPressed: (){
              Authentication.signOut();
              while(Navigator.canPop(context)){
                Navigator.pop(context);
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              }, child: Text("ログアウト")),
              SizedBox(height: 20,),
              ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.red), onPressed: (){
             Authentication.delet();
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              }, child: Text("アカウント消去"))
            ],
          ),
        ),
      ),
    );
  }
}
