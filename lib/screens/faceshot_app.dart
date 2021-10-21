import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/services/firebase_firestore_service.dart';
import 'package:faceshot_teacher/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'authentication/login_screen.dart';
import 'home_screen.dart';
import 'splash_screen.dart';

class FaceShotApp extends StatelessWidget {
  const FaceShotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //App Title
      title: 'Faceshot Teacher',

      //Theme
      theme: AppTheme.getTheme(context),

      //Hide the debug banner
      debugShowCheckedModeBanner: false,

      //Home
      home: Scaffold(
        body: FutureBuilder<Teacher?>(
          future: getUserSessionData(),
          builder: (BuildContext context, AsyncSnapshot<Teacher?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Loading
              return const SplashScreen();
            } else if (snapshot.data != null) {
              // already Logged in
              return HomeScreen(snapshot.data!);
            } else {
              // Not yet logged in
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }

  ///Perform all the initial functions and return what state is the app in
  Future<Teacher?> getUserSessionData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (FirebaseAuth.instance.currentUser != null) {
      return await FirestoreService.getTeacherProfile(
        FirebaseAuth.instance.currentUser!.email!,
      );
    } else {
      return null;
    }
  }
}
