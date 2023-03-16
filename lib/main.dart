import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tttest/view/start_up/login_page.dart';


import 'firebase_options.dart';

//main関数でStatelessWidgetのMyAppを呼び出している。
//Statelessウェジェットは、状態を持たない静的な画面なので、表示を変えるには再描画する必要があります。22へ
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override    //仮引数（BuildContext）値（context）
              //buildメソッドは、widgetを表示する、描画する。
              //下のコードは線画するという処理。それを実行しているのが12行目のmain関数。片方では機能しない。
              //runApp()実行時(アプリ起動時)　myApp（widget(設計図)）を呼び出す。　中のbuildメソッドが実行。->画面に表示。
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

