import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tttest/utils/authentication.dart';
import 'package:tttest/utils/firestore/posts.dart';

import '../../model/post.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新規投稿",style: TextStyle(color: Colors.black),),
backgroundColor: Colors.deepOrange,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
             controller: contentController,
            ),//入力欄
            SizedBox(height: 20,),
            ElevatedButton(onPressed:()async{
            if(contentController.text.isNotEmpty){
            Post newPost = Post(
              content: contentController.text,
              postAcountId: Authentication.myAcount!.id,//今ログインしてるユーザーの（uid）
            );
            var result = await PostFirestore.addPost(newPost);
            if(result == true){
              Navigator.pop(context);
            }
            }
            }, child: Text("投稿"))

          ],
        ),
      ),

    );
  }
}
