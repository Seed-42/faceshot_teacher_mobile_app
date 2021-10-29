import 'package:faceshot_teacher/models/teacher.dart';
import 'package:flutter/material.dart';

import 'timetable_day_screen.dart';

class TimeTableHomeScreen extends StatefulWidget {
  final Teacher teacher;
  const TimeTableHomeScreen(this.teacher, {Key? key}) : super(key: key);

  @override
  _TimeTableHomeScreenState createState() => _TimeTableHomeScreenState();
}

class _TimeTableHomeScreenState extends State<TimeTableHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Timetable')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: DateTime.daysPerWeek,
        itemBuilder: (BuildContext context, int index) =>
            _getWeekListTile(index),
      ),
    );
  }

  ListTile _getWeekListTile(int index) {
    String weekDay;
    if (index == 0) {
      weekDay = 'Monday';
    } else if (index == 1) {
      weekDay = 'Tuesday';
    } else if (index == 2) {
      weekDay = 'Wednesday';
    } else if (index == 3) {
      weekDay = 'Thursday';
    } else if (index == 4) {
      weekDay = 'Friday';
    } else if (index == 5) {
      weekDay = 'Saturday';
    } else {
      weekDay = 'Sunday';
    }
    return ListTile(
      title: Text(weekDay),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TimetableDayScreen(widget.teacher, weekDay),
          ),
        );
      },
    );
  }
}
