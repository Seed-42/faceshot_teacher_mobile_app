import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/services/firebase_auth_service.dart';
import 'package:faceshot_teacher/services/firebase_firestore_service.dart';
import 'package:faceshot_teacher/utils/utility.dart';
import 'package:faceshot_teacher/widgets/app_logo.dart';
import 'package:faceshot_teacher/widgets/form_fields/text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController tecEmail = TextEditingController(),
      tecPassword = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log into your account'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            // Logo
            AppLogo(width: width * 0.6, transparentVersion: true),

            // Email
            CustomTextFormField(
              controller: tecEmail,
              hintText: 'Enter your Email',
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email),
              validator: (String? val) {
                if (val == null || val.isEmpty) {
                  return 'This is a required field';
                } else if (Utility.isValidEmail(val) == false) {
                  return 'Please enter a valid email';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 10),

            // Password
            CustomTextFormField(
              controller: tecPassword,
              hintText: 'Set Password',
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              validator: (String? val) {
                if (val == null || val.isEmpty) {
                  return 'This is a required field';
                } else if (Utility.isValidPassword(val) == false) {
                  return 'Please enter a more secure password';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 10),

            //Create your Account
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });

                  //Signup
                  EmailAuthService emailAuthService = EmailAuthService();
                  await emailAuthService.signIn(
                    tecEmail.text,
                    tecPassword.text,
                  );

                  if (FirebaseAuth.instance.currentUser == null) {
                    setState(() {
                      isLoading = false;
                    });
                    Utility.showSnackBar(
                      context,
                      'Wrong credentials, please try again',
                    );
                    return;
                  }

                  //Fetch from to database
                  Teacher? teacher = await FirestoreService.getTeacherProfile(
                    FirebaseAuth.instance.currentUser!.email!,
                  );

                  if (teacher == null) {
                    setState(() {
                      isLoading = false;
                    });
                    Utility.showSnackBar(
                      context,
                      'Failed to locate an account, please create a new account',
                    );
                    return;
                  }

                  //Go to the homescreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(teacher),
                      settings: const RouteSettings(name: "home_screen"),
                    ),
                  );

                  setState(() {
                    isLoading = false;
                  });
                } else {
                  Utility.showSnackBar(
                    context,
                    'Please check the errors in the fields',
                  );
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text('Sign in'),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: const Text('Signup instead'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                        settings: const RouteSettings(name: "signup_screen"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
