import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class LoginClass {

  static late IdTokenResult idTokenResult;

  Future<IdTokenResult> getToken() async {
    IdTokenResult mUser = await FirebaseAuth.instance.currentUser!.getIdTokenResult();
    idTokenResult = mUser;
    return mUser;
  }


  Future<String> login(String emailAddress, password) async {
    String result = "success";
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      result = "failed";
      if (e.code == 'user-not-found') {
        result = ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        result =('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        result = ('올바른 이메일 형식이 아닙니다.');
      } else {
        result = (e.code);
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

  Future<String> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    var cred = await FirebaseAuth.instance.signInWithCredential(credential);

    // Once signed in, return the UserCredential
    return "success";
  }
}
