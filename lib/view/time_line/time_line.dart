import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tttest/utils/firestore/posts.dart';
import 'package:tttest/utils/firestore/users.dart';
import 'package:tttest/view/time_line/post_page.dart';

import '../../model/acount.dart';
import '../../model/post.dart';

class TimeLine extends StatefulWidget {

  const TimeLine({Key? key}) : super(key: key);

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("タイムライン",style: TextStyle(color: Colors.black),)),
        backgroundColor: Theme.of(context).canvasColor,//bodyと同じ変数を指定
        elevation: 1,//濃さ
      ),
      body:StreamBuilder<QuerySnapshot>(
        stream: PostFirestore.posts.snapshots(),
        builder: (context, postSnapshot) {
          if(postSnapshot.hasData){
            List<String> postAcountIds =[];
            postSnapshot.data!.docs.forEach((doc) {
              Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
              if(!postAcountIds.contains(data["post_acount_id"])){//!で意味を否定してる
                postAcountIds.add(data["post_acount_id"]);
              }
            });
            return FutureBuilder<Map<String,Acount>?>(
              future: UserFireStore.getPostUserMap(postAcountIds),
              builder: (context, userSnapshot){
    if(userSnapshot.hasData && userSnapshot.connectionState == ConnectionState.done){
      return ListView.builder( //同じものを何回も繰り返し表示する時とかに使う
        itemCount: postSnapshot.data!.docs.length, //何個表示しますか
        itemBuilder:(context,index){//何を表示しますか
          Map<String,dynamic> data = postSnapshot.data!.docs[index].data() as Map<String,dynamic>;
          Post post = Post(
              id: postSnapshot.data!.docs[index].id,
              content: data["content"],
              postAcountId: data["post_acount_id"],
              createdTime: data["created_time"]);
          Acount postAcount =userSnapshot.data![post.postAcountId]!;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
                border: index == 0 ? Border(
                  top: BorderSide(color: Colors.grey,width: 1),
                  bottom: BorderSide(color: Colors.grey,width: 1),
                ) :Border(bottom: BorderSide(color: Colors.grey,width: 1),)
            ),
            child:   Row(
              children: [
                CircleAvatar(
                  radius:22,
                  foregroundImage: NetworkImage(postAcount.imagePath),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,//縦に要素を並べる
                  children: [
                    Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(postAcount.name,style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(postAcount.userId,style: TextStyle(color: Colors.deepOrange),)
                          ],
                        ),

                        Text(DateFormat('M/d/yy').format(post.createdTime!.toDate()))
                      ],
                    ),
                    Text(post.content),
                  ],
                )
              ],
            ),
          );
        },
      );
    }else{
      return Container();
    }
              }


            );
          }else{
            return Container();
          }

        }
      ),

    );
  }
}

