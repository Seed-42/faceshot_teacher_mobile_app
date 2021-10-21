import 'dart:ui';

import 'package:flutter/material.dart';

import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double width = 100, height = 100;

  @override
  void initState() {
    //Animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _controller.repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //Background
        Image.asset(
          'assets/images/background.gif',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),

        //Add Blur Layer
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
        ),

        //Logo
        Align(
          child: ScaleTransition(
            // ignore: always_specify_types
            scale: Tween(begin: 0.75, end: 2.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Curves.elasticOut,
              ),
            ),
            child: const AppLogo(
              height: 80,
              width: 80,
              transparentVersion: true,
            ),
          ),
        ),

        //App Name
        // Positioned(
        //   left: 0,
        //   right: 0,
        //   bottom: MediaQuery.of(context).size.height * 0.5 - 130,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Text(
        //       'FaceShot\nTeacher',
        //       style: theme.textTheme.headline4?.copyWith(
        //         color: theme.primaryColor,
        //       ),
        //       textAlign: TextAlign.center,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
