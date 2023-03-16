import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tttest/view/acount/acount_page.dart';
import 'package:tttest/view/time_line/post_page.dart';
import 'package:tttest/view/time_line/time_line.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int selectedIndex = 0;
  List<Widget> pageList =[TimeLine(),AcountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: pageList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: ''
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity_outlined),
              label: ''
          )

        ],
        currentIndex: selectedIndex,
        onTap: (index){
          setState(() {
          selectedIndex = index;
          });
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> PostPage()));
        },
        child: Icon(Icons.chat_bubble_outline),
      ),
    );//Scaffold
  }
}
