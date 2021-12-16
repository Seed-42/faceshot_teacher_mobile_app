import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'screens/faceshot_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Firebase
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAESvi2_dzRTz8Hg7NHrXAuCj-X8SiDGrE",
          authDomain: "faceshot-seed-42.firebaseapp.com",
          projectId: "faceshot-seed-42",
          storageBucket: "faceshot-seed-42.appspot.com",
          messagingSenderId: "673461305828",
          appId: "1:673461305828:web:14f1b88ac6f2db403347f1",
          measurementId: "G-3JFL01MKVR"),
    );
  } else {
    await Firebase.initializeApp();
  }

  return runApp(const FaceShotApp());
}
