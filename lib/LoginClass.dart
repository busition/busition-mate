import 'package:firebase_auth/firebase_auth.dart';

class LoginClass {

  static late IdTokenResult idTokenResult;

  Future<IdTokenResult> getUser() async {
    var mUser = await FirebaseAuth.instance.currentUser!.getIdTokenResult();
    idTokenResult = mUser;
    return mUser;
  }


  Future<String> login(String emailAddress, password) async {
    String result = "success";
    try {
      print("A");
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      result = "failed";
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        print('올바른 이메일 형식이 아닙니다.');
      } else {
        print(e.code);
      }
    }
    return result;
  }

  Future<List<String>> signUp(String emailAddress, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return ["password" , 'weak-password'];
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return ["email" ,'weak-password'];
      }

    } catch (e) {
      print(e);
    }
    return ["pass","success"];

  }
}
