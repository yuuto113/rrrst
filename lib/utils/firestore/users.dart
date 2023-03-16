

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tttest/model/account2.dart';
import 'package:tttest/model/acount.dart';
import 'package:tttest/utils/authentication.dart';

class UserFireStore {
  static final _firestoreInstance = FirebaseFirestore.instance;

  //collectionメソッドがCollectionReference型だから、CollectionReference型の変数に代入してる。しなくても機能はする。だが意味として分かりやすい形にした
  static final CollectionReference users = _firestoreInstance.collection(
      "users");




//usersコレクションに値を追加
  static Future<dynamic> setUser(Acount newAcount) async {
    try {
      await users.doc(newAcount.id).set({
        "name":newAcount.name,
        "user_id": newAcount.userId,
        "self_Introduction": newAcount.selfIntroduction,
        "image_Path": newAcount.imagePath,
        "syumi": newAcount.syumi,
        "created_Time": Timestamp.now(),
        "update_Time": Timestamp.now()
      });
      print("新規ユーザー作成完了");
      return true;
    } on FirebaseException catch (e) {
      print("新規ユーザー作成エラー:$e");
      return false;
    }
  }



  //firebaseからアカウントを取得するメソッド
  static Future<dynamic> getUser(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic> data = documentSnapshot.data() as Map<String,
          dynamic>;
      Acount myAcount = Acount(
          id: uid,//ドキュメント
          name: data["name"],
          userId: data["user_id"],
          selfIntroduction: data["self_Introduction"],
          imagePath: data["image_Path"],
          syumi: data["syumi"],
          createdTime: data["created_Time"],
          updateTime: data["update_Time"]
      );
      Authentication.myAcount = myAcount;
      print("ユーザー取得完了");
      return true;
    } on FirebaseException catch (e) {
      print("ユーザー取得エラー:$e");
      return false;
    }
  }


  static Future<dynamic> updateUser(Acount updateAcount) async {
    try {
      await users.doc(updateAcount.id).update({
        "name": updateAcount.name,
        "image_Path": updateAcount.imagePath,
        "user_id": updateAcount.userId,
        "self_Introduction": updateAcount.selfIntroduction,
        "update_Time": Timestamp.now()
      });
      print("ユーザー情報の更新完了");
      return true;
    } on FirebaseException catch (e) {
      print("ユーザー情報の更新失敗:$e");
      return false;
    }
  }

  //タイムラインに投稿表示
  static Future<Map<String, Acount>?> getPostUserMap(List<String> acountIds) async {
    Map<String, Acount> map = {}; //要素数0の配列
    try {
      await Future.forEach(acountIds, (String acountId) async {
        var doc = await users.doc(acountId)
            .get(); //変数docには usersコレクションの（参照してきた）値（ドキュメント）が入ってる。
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Acount postAcount = Acount(
            id: acountId,
            name: data["name"],
            userId: data["user_id"],
            imagePath: data["image_path"],
            selfIntroduction: data["self_introduction"],
            createdTime: data["created_time"],
            updateTime: data["update_time"]
        );
        map[acountId] = postAcount;
      });
      print("投稿完了");
      return map;
    } on FirebaseException catch (e) {
      print("エラー:$e");
      return null;
    }
  }


}