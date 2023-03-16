import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  String id;
  String content;
  String postAcountId;
  Timestamp? createdTime;

  Post({this.id ="", this.content ="", this.postAcountId="", this.createdTime});
}