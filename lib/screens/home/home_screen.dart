import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';

class HomeScreen extends StatefulWidget {
  final Teacher teacher;
  const HomeScreen(this.teacher, {Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faceshot Dashboard'),
      ),
      drawer: getPrimaryDrawer(context, widget.teacher),
      body: HomeScreeenDashboard(widget.teacher),
    );
  }
}
