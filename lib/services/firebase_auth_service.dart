import 'package:firebase_auth/firebase_auth.dart';

//import '../models/user/user_model.dart';
//import 'firebase_firestore_service.dart';

///Authentication Base functions skeleton
abstract class BaseAuth {
  User? getCurrentUser() => FirebaseAuth.instance.currentUser;

  Future<void> signOut() async => FirebaseAuth.instance.signOut();

  Future signIn();

  Future<User> signUp();
}

///Email Auth
class EmailAuthService {
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential authRes =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //if (authRes.user != null) User? user = authRes.user;
      //return FirebaseAuth.instance.currentUser;
      return authRes.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> sendEmailVerification() async =>
      FirebaseAuth.instance.currentUser?.sendEmailVerification();

  Future<bool> isEmailVerified() async =>
      FirebaseAuth.instance.currentUser?.emailVerified ?? false;

  Future<User?> signUp(String email, String password) async {
    try {
      return (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
    } on Exception {
      return null;
    }
  }

  Future<void> resetAccountPassword(String email) async =>
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

  Future<void> signOut() async => FirebaseAuth.instance.signOut();
}
