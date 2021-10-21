import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/faceshot_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Firebase
  await Firebase.initializeApp();

  return runApp(const FaceShotApp());
}
