import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'timetable/timetable_home_screen.dart';

class HomeScreen extends StatefulWidget {
  final Teacher teacher;
  const HomeScreen(this.teacher, {Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faceshot Dashboard'),
      ),
      drawer: getPrimaryDrawer(context, widget.teacher),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          //Timetable
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance',
                    style: theme.textTheme.headline4,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'Take attendance for your current class',
                    style: theme.textTheme.bodyText1,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),

          //Timetable
          InkWell(
            onTap: () {
              //Go to the TimeTableHomeScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimeTableHomeScreen(widget.teacher),
                ),
              );
            },
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Timetable',
                      style: theme.textTheme.headline4,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'Create and view your timetable from here',
                      style: theme.textTheme.bodyText1,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
