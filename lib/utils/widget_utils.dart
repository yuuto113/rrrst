import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WidgetUtils{
  static AppBar createAppBar(String title){
   return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
      centerTitle: true,
    );
  }
}