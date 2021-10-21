import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/screens/authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

getPrimaryDrawer(BuildContext context, Teacher teacher) {
  return Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            image: DecorationImage(
              image: Image.asset('assets/images/icon_transparent.png').image,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              teacher.name,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white60,
                  ),
            ),
          ),
        ),
        ListTile(
          trailing: const Icon(Icons.logout),
          title: const Text('Log out'),
          onTap: () async {
            //Logout
            await FirebaseAuth.instance.signOut();

            //Go to the login screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
                settings: const RouteSettings(name: "home_screen"),
              ),
            );
          },
        ),
      ],
    ),
  );
}
