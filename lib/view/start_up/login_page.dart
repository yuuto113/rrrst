

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:tttest/utils/authentication.dart';
import 'package:tttest/utils/firestore/users.dart';
import 'package:tttest/view/acount/edit_pass.dart';
import 'package:tttest/view/screen.dart';
import 'package:tttest/view/start_up/create_acount_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override  //仮引数（BuildContext）値（context）
             //buildメソッドはWidget(クラス)をElment(インスタンス)に変える。線画する
             //BuildContextはElment　contextは現在の場所という意味を持つ。
             //メソッドの中にはWidget(実体化されたパーツ、部品が入ってる、その場所(画面（部品）)ということ)
             //引数の意味は(部品の　場所)という意味
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(

            children: [
              SizedBox(height: 50,),
              Text("twitterデモアプリ",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "メールアドレス"
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: passController,
                  decoration: InputDecoration(
                      hintText: "パスワード"
                  ),
                ),
              ),
              SizedBox(height: 30,),
              RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: "アカウントを作成してない方は"),
                      TextSpan(text: "こちらから",style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap=(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAcountPage()));
                      }
                      ),

                    ]
                  ),
              ),
              SizedBox(height: 70),
              ElevatedButton(
                  onPressed: () async{
                  var result = await  Authentication.emailSignIn(email: emailController.text, pass: passController.text);
                  if(result is UserCredential){
                    var _result = await UserFireStore.getUser(result.user!.uid);
                    if(_result == true){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) =>Screen()));
                    }

                  }
                  },

                  child: Text("emailでログイン")

              ),
              SignInButton(Buttons.Google,

                  onPressed: ()async{
                    var result = await Authentication.signInWithGoogle();
                    if(result is UserCredential){
                      var result = await UserFireStore.getUser(Authentication.currentFirebaseUser!.uid);
                      if(result == true ){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Screen()));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAcountPage()));

                      }
                    }
                  }),
              RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: "パスワードを忘れた方は"),
                      TextSpan(text: "こちら",style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()..onTap=(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditAccount()));
                          }
                      ),

                    ]
                ),
              )


            ],

          ),
        ),
      ),
    );
  }
}
