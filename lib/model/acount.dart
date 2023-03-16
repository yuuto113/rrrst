import 'package:cloud_firestore/cloud_firestore.dart';

class Acount {
  String id;
  String name;
  String imagePath;
  String selfIntroduction;
  String userId;
  String syumi;
  Timestamp? createdTime;
  Timestamp? updateTime;
//①コンストラクタ
  Acount({this.id ="", this.name ="" ,this.imagePath ="",this.syumi="",
    this.selfIntroduction ="", this.userId ="", this.createdTime, this.updateTime});



}