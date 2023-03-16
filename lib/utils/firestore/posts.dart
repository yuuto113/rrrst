import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/post.dart';

class PostFirestore{
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference posts = _firestoreInstance.collection("posts");

  //setpostみたいなもん
  static Future<dynamic> addPost(Post newPost)async{
try{
  //usersコレクションのドキュメントにサブコレクションを追加
final CollectionReference _userPosts = _firestoreInstance.collection("users").doc(newPost.postAcountId).collection("my_posts");
//addでpostコレクションのdocを自動生成
var result = await posts.add({
  "content":newPost.content,
  "post_acount_id": newPost.postAcountId,
  "created_time":Timestamp.now()
});
//addで自動生成されたドキュメントにset
_userPosts.doc(result.id).set({
  "post_id":result.id,
  "created_time":Timestamp.now()
});
print("投稿完了");
return true;
}on FirebaseException catch(e){
print("投稿失敗:$e");
return false;
}
  }
  //postsからデータをgetしてくる
  static Future<List<Post>?> getPostsFromIds(List<String> ids)async{
    List<Post> postList = [];
    try{
  await Future.forEach(ids, (String id) async{
    var doc = await posts.doc(id).get();
    Map<String,dynamic> data = doc.data() as Map<String, dynamic>;//キャストしてる型変換、 　T はオブジェクト型、遡れば　T data()なの　
Post post = Post(
  id:doc.id,//doc.get(ドキュメントリファレンス)してきた,参照id
  content: data["content"],
  postAcountId: data["post_acount_id"],
  createdTime: data["created_time"]
);
postList.add(post);
  });
  print("自分の投稿を取得完了");
  return postList;
    } on FirebaseException catch(e){
print("自分の投稿取得失敗:$e");
return null;
    }
  }

  static Future<dynamic> deletePosts(String PostId)async{
    posts.doc(PostId).delete();
  }

}