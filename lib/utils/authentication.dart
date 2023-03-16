import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/acount.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; //FirebaseAuthライブラリのFirebaseAuthクラス
  static User? currentFirebaseUser; //FirebaseAuthライブラリのUserクラス
  static Acount? myAcount; //取得してきた値

  //追加、登録
  static Future<dynamic> signUp(
      {required String email, required String pass}) async {
    try {
      UserCredential newAccount = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
      print("auth完了");
      return newAccount;
    } on FirebaseAuthException catch (e) {
      print("authエラー: $e");
      return "登録エラーが発生しました";
    }
  }

  //サインアップ　サインイン処理
  static Future<dynamic> emailSignIn(
      {required String email, required String pass}) async {
    try {
      final UserCredential _result = await _firebaseAuth
          .signInWithEmailAndPassword(
          email: email,
          password: pass);
      currentFirebaseUser = _result.user;
      print("authサインイン完了");
      return _result;
    } on FirebaseAuthException catch (e) {
      print("authサインイン失敗: $e");
      return false;
    }
  }

  //ログアウト
  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

//消去
  static Future<void> delet() async {
    await currentFirebaseUser!.delete();
  }


// googlesiginn
  static Future<dynamic> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn(scopes: ["email"]).signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken
        );
        final UserCredential _result = await _firebaseAuth.signInWithCredential(
            credential);
        currentFirebaseUser = _result.user;
        print("Googleログイン完了");
        return _result;
      }
    } on FirebaseException catch (e) {
      print("Googleログインエラー:$e");
      return false;
    }
  }

  //pass変更
static Future<dynamic> sendPasswordResetEmail(String email)async{
    try{
await _firebaseAuth.sendPasswordResetEmail(email: email);
return 'success';
    }catch(e){
print("eraaです");
      return "ERROR_INVALID_EMAIL";
    }
}

}