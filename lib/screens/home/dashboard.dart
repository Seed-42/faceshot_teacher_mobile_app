import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/models/timetable.dart';
import 'package:faceshot_teacher/screens/attendance/attendance_history_screen.dart';
import 'package:faceshot_teacher/screens/attendance/camera_screen.dart';
import 'package:faceshot_teacher/screens/timetable/timetable_home_screen.dart';
import 'package:faceshot_teacher/services/firebase_firestore_service.dart';
import 'package:flutter/material.dart';

class HomeScreeenDashboard extends StatefulWidget {
  final Teacher teacher;
  const HomeScreeenDashboard(this.teacher, {Key? key}) : super(key: key);

  @override
  _HomeScreeenDashboardState createState() => _HomeScreeenDashboardState();
}

class _HomeScreeenDashboardState extends State<HomeScreeenDashboard> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return FutureBuilder<Timetable?>(
        future: FirestoreService.getTimeTable(widget.teacher.uid),
        builder: (BuildContext context, AsyncSnapshot<Timetable?> snapshot) {
          bool isTimeTableAdded = true;
          bool isClassestoday = true;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data == null ||
              snapshot.data!.timetableAgenda == null ||
              snapshot.data!.timetableAgenda!.isEmpty) {
            isTimeTableAdded = false;
          }
          List? todaysAgenda = snapshot.data!.timetableAgenda![
              _getWeekDayName(DateTime.now().weekday).toLowerCase()];

          if (todaysAgenda == null || todaysAgenda.isEmpty) {
            isClassestoday = false;
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              //Today's Dashboard
              _getDashboardClassCard(
                theme,
                isTimeTableAdded,
                isClassestoday,
                todaysAgenda ?? [],
              ),

              //Timetable
              isTimeTableAdded &&
                      isClassestoday &&
                      _getCurrentTimeSlotFromTimeTable(snapshot.data!) != null
                  ? InkWell(
                      onTap: () async {
                        //Go to the TimeTableHomeScreen
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraScreen(
                              widget.teacher,
                              snapshot.data!,
                              _getCurrentTimeSlotFromTimeTable(snapshot.data!)!,
                            ),
                          ),
                        );

                        //reload the updated timetable
                        setState(() {});
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Attendance',
                                style: theme.textTheme.headline5,
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
                    )
                  : Container(),

              //Timetable
              InkWell(
                onTap: () async {
                  //Go to the TimeTableHomeScreen
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimeTableHomeScreen(widget.teacher),
                    ),
                  );

                  //reload the updated timetable
                  setState(() {});
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Timetable',
                          style: theme.textTheme.headline5,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          isTimeTableAdded
                              ? 'Manage your timetable from here'
                              : 'Start by creating a new Timetable',
                          style: theme.textTheme.bodyText1,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // //Previous Attendances
              // InkWell(
              //   onTap: () async {
              //     //Go to the Attendance acreen
              //     await Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => AttendanceHistoryScreen(
              //           widget.teacher,
              //           snapshot.data!,
              //         ),
              //       ),
              //     );

              //     //reload the updated timetable
              //     setState(() {});
              //   },
              //   child: Card(
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 12, vertical: 10),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'Attendance History',
              //             style: theme.textTheme.headline5,
              //             textAlign: TextAlign.left,
              //           ),
              //           Text(
              //             'View and update all your past attendances',
              //             style: theme.textTheme.bodyText1,
              //             textAlign: TextAlign.left,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          );
        });
  }

  String _getWeekDayName(int index) {
    String weekDay;
    if (index == 1) {
      weekDay = 'Monday';
    } else if (index == 2) {
      weekDay = 'Tuesday';
    } else if (index == 3) {
      weekDay = 'Wednesday';
    } else if (index == 4) {
      weekDay = 'Thursday';
    } else if (index == 5) {
      weekDay = 'Friday';
    } else if (index == 6) {
      weekDay = 'Saturday';
    } else {
      weekDay = 'Sunday';
    }

    return weekDay;
  }

  Card _getDashboardClassCard(
    ThemeData theme,
    bool isTimeTableAdded,
    bool isClassestoday,
    List todaysAgenda,
  ) {
    String headline = '', subHeadline = '';
    if (isTimeTableAdded) {
      if (isClassestoday) {
        // classStatus == -1 : no classes after or now
        // classStatus == 0 : class happening now
        // classStatus == 1 : class happening later
        int classStatus = -1;
        Map classHappening = {};
        for (var agenda in todaysAgenda) {
          DateTime from = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              int.parse(agenda['from'].toString().split(':').first),
              int.parse(agenda['from'].toString().split(':').last));
          DateTime to = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              int.parse(agenda['to'].toString().split(':').first),
              int.parse(agenda['to'].toString().split(':').last));

          if (from.isBefore(DateTime.now()) && to.isAfter(DateTime.now())) {
            //Happening now
            classStatus = 0;
            classHappening = agenda;
          } else if (from.isAfter(DateTime.now()) &&
              to.isAfter(DateTime.now()) &&
              classStatus == -1) {
            //Happening later
            classStatus = 1;
            classHappening = agenda;
          }
        }

        if (classStatus == 0) {
          headline = 'Class happening now';
          subHeadline =
              'From ${classHappening["from"]} to ${classHappening["to"]}';
        } else if (classStatus == 1) {
          headline = 'Class starting soon';
          subHeadline =
              'From ${classHappening["from"]} to ${classHappening["to"]}';
        } else {
          headline = 'All done for the day';
          subHeadline = 'No more classes today!';
        }
      } else {
        headline = 'All done for the day';
        subHeadline = 'No classes today!';
      }
    } else {
      headline = 'No Timetable added';
      subHeadline = 'Please start by adding a Timetable';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headline,
              style: theme.textTheme.headline4,
              textAlign: TextAlign.left,
            ),
            Text(
              subHeadline,
              style: theme.textTheme.bodyText1,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Map? _getCurrentTimeSlotFromTimeTable(Timetable timetable) {
    //Get All the classes for today
    List todaysAgenda = timetable.timetableAgenda![
        _getWeekDayName(DateTime.now().weekday).toLowerCase()];

    Map? currentTimeSlotFromTimeTable;

    //Get the class going on right now
    for (var agenda in todaysAgenda) {
      DateTime from = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          int.parse(agenda['from'].toString().split(':').first),
          int.parse(agenda['from'].toString().split(':').last));
      DateTime to = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          int.parse(agenda['to'].toString().split(':').first),
          int.parse(agenda['to'].toString().split(':').last));

      if (from.isBefore(DateTime.now()) && to.isAfter(DateTime.now())) {
        //Happening now
        currentTimeSlotFromTimeTable = agenda;
      }
    }

    return currentTimeSlotFromTimeTable;
  }
}
