import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tttest/utils/authentication.dart';
import 'package:tttest/utils/firestore/posts.dart';
import 'package:tttest/utils/firestore/users.dart';
import 'package:tttest/view/acount/edit_acount_page.dart';

import '../../model/acount.dart';
import '../../model/post.dart';

class AcountPage extends StatefulWidget {
  const AcountPage({Key? key}) : super(key: key);

  @override
  State<AcountPage> createState() => _AcountPageState();
}

class _AcountPageState extends State<AcountPage> {
  Acount myAcount = Authentication.myAcount!;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
         Container(
           padding: EdgeInsets.only(right: 15,left: 15,top: 20),
           color: Colors.red,
           height: 200,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Row(
                     children: [
                       CircleAvatar(
                         radius: 32,
                         foregroundImage: NetworkImage(myAcount.imagePath),
                       ),
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(myAcount.name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                           Text('@${myAcount.userId}',style: TextStyle(color: Colors.grey),)
                         ],
                       )
                     ],
                   ),
                   OutlinedButton(onPressed: ()async{
                  var result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> EditAcountPage()));
                  if(result == true){
                   setState(() {
                     myAcount = Authentication.myAcount!;
                   });
                  }
                   }, child: Text("編集"))
                 ],
               ),
               SizedBox(height: 15),
               Text(myAcount.selfIntroduction)
             ],

           ),
         ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(
                  color: Colors.cyan,width: 3
                )),
              ),
              child: Text("投稿",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold))
            ),

            //投稿view
            Expanded(child: StreamBuilder<QuerySnapshot>(
              stream: UserFireStore.users.doc(myAcount.id).collection("my_posts").orderBy("created_time",descending: true).snapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  List<String> myPostIds = List.generate(snapshot.data!.docs.length, (index) {
                 return snapshot.data!.docs[index].id;
            });

                  return FutureBuilder<List<Post>?>(
                    future: PostFirestore.getPostsFromIds(myPostIds),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){

                        return ListView.builder(
                            itemCount:snapshot.data!.length,
                            itemBuilder: (context, index){
                              Post post = snapshot.data![index];
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
                                      foregroundImage: NetworkImage(myAcount.imagePath),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,//縦に要素を並べる
                                      children: [
                                        Row(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(myAcount.name,style: TextStyle(fontWeight: FontWeight.bold),),
                                                Text(myAcount.userId,style: TextStyle(color: Colors.deepOrange),)
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
                            });
                      }else{
                        return Container();
                      }

                    }
                  );
                } else{
                  return Container();
                }

              }
            )

            )
          ],

        ),
      ),
    );
  }
}
