import 'dart:typed_data';

import 'package:faceshot_teacher/models/attendance.dart';
import 'package:faceshot_teacher/models/student.dart';
import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/models/timetable.dart';
import 'package:faceshot_teacher/services/firebase_firestore_service.dart';
import 'package:faceshot_teacher/widgets/no_cached_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';

class AttendanceScreen extends StatefulWidget {
  final Teacher teacher;
  final Timetable timetable;
  final Map selectedTimeSlot;
  final String attendanceUid;
  final List<Attendance> attendances;

  const AttendanceScreen(this.teacher, this.timetable, this.selectedTimeSlot,
      this.attendanceUid, this.attendances,
      {Key? key})
      : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //leading: Container(),
          title: const Text('Attendance for today'),
          actions: [
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: widget.attendances.isEmpty
            ? const Center(child: Text('Not Attendance Data found'))
            : ListView.builder(
                itemCount: widget.attendances.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: widget.attendances[index].fileUrl != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              widget.attendances[index].fileUrl,
                            ),
                          )
                        : const SizedBox(),
                    title: getStudentNameText(
                        widget.attendances[index].studentUid),
                    subtitle: Text(
                      'Marked ' +
                          (widget.attendances[index].confidence > 0.5
                              ? 'Present'
                              : 'Absent') +
                          ', with ${widget.attendances[index].confidence * 100}% accuracy',
                    ),
                    trailing: TextButton(
                      child: const Text('Change attendance'),
                      onPressed: () async {
                        if (widget.attendances[index].confidence < 0.5) {
                          widget.attendances[index].confidence = 1;
                        } else {
                          widget.attendances[index].confidence = 0;
                        }
                        FirestoreService.setAttendance(
                          widget.timetable.uid,
                          widget.attendanceUid,
                          widget.attendances,
                        );

                        setState(() {});
                      },
                    ),
                  );
                },
              )
        // : GridView.builder(
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 2,
        //       crossAxisSpacing: 5.0,
        //       mainAxisSpacing: 25.0,
        //     ),
        //     itemCount: widget.attendances.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       return Container(
        //         width: MediaQuery.of(context).size.width * 0.5,
        //         height: MediaQuery.of(context).size.width * 0.6,
        //         padding: const EdgeInsets.all(8.0),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             Text(
        //               widget.attendances[index].studentUid,
        //               style: Theme.of(context).textTheme.headline4,
        //             ),
        //             Text(
        //               'Marked ' +
        //                   (widget.attendances[index].confidence > 0.5
        //                       ? 'Present'
        //                       : 'Absent') +
        //                   ', with ${widget.attendances[index].confidence * 100}% accuracy',
        //               style: Theme.of(context).textTheme.headline6,
        //             ),
        //             Image.network(
        //               widget.attendances[index].fileUrl,
        //               width: MediaQuery.of(context).size.width * 0.5,
        //               height: MediaQuery.of(context).size.width * 0.5,
        //             ),
        //             TextButton(
        //               child: Text(
        //                 widget.attendances[index].confidence < 0.5
        //                     ? 'Mark Present'
        //                     : 'Mark Absent',
        //               ),
        //               onPressed: () async {
        //                 if (widget.attendances[index].confidence < 0.5) {
        //                   widget.attendances[index].confidence = 1;
        //                 } else {
        //                   widget.attendances[index].confidence = 0;
        //                 }
        //                 FirestoreService.setAttendance(
        //                   widget.timetable.uid,
        //                   widget.attendanceUid,
        //                   widget.attendances,
        //                 );

        //                 setState(() {});
        //               },
        //             )
        //           ],
        //         ),
        //       );
        //     },
        //   ),
        // body: FutureBuilder<List<Attendance>>(
        //   future: _loadAttendanceItems(),
        //   builder: (context, AsyncSnapshot<List<Attendance>> snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(child: CircularProgressIndicator());
        //     }
        //     if (widget.attendances == null || widget.attendances.isEmpty) {
        //       return const Center(child: Text('Not Attendance Data found'));
        //     }
        //
        //     return ListView.builder(
        //       itemCount: widget.attendances?.length,
        //       itemBuilder: (BuildContext context, int index) {
        //         return ListTile(
        //           leading: widget.attendances[index].studentDetectedFace != null
        //               ? Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: Image.memory(base64Decode(
        //                     widget.attendances[index].studentDetectedFace!,
        //                   )),
        //                 )
        //               : widget.attendances[index].coordinates != null
        //                   ? Padding(
        //                       padding: const EdgeInsets.all(8.0),
        //                       child: _getDetectedFaceImage(
        //                         widget.attendances[index].coordinates,
        //                       ),
        //                     )
        //                   : const SizedBox(),
        //           title: getStudentNameText(widget.attendances[index].studentUid),
        //           subtitle: Text(
        //             'Marked ' +
        //                 (widget.attendances[index].confidence > 0.5
        //                     ? 'Present'
        //                     : 'Absent') +
        //                 ', with ${widget.attendances[index].confidence * 100}% accuracy',
        //           ),
        //           trailing: TextButton(
        //             child: const Text('Change attendance'),
        //             onPressed: () async {
        //               if (widget.attendances[index].confidence < 0.5) {
        //                 widget.attendances[index].confidence = 1;
        //               } else {
        //                 widget.attendances[index].confidence = 0;
        //               }
        //               FirestoreService.setAttendance(
        //                 widget.timetable.uid,
        //                 widget.attendanceUid,
        //                 widget.attendances,
        //               );
        //
        //               setState(() {});
        //             },
        //           ),
        //         );
        //       },
        //     );
        //   },
        // ),
        );
  }

  FutureBuilder<Student?> getStudentNameText(String studentUid) {
    return FutureBuilder<Student?>(
      future: FirestoreService.getStudentProfile(studentUid: studentUid),
      builder: (BuildContext context, AsyncSnapshot<Student?> snapshot) {
        if (snapshot.data == null) {
          return Text(studentUid, style: Theme.of(context).textTheme.headline4);
        } else {
          return Text(
            snapshot.data!.name,
            style: Theme.of(context).textTheme.headline4,
          );
        }
      },
    );
  }
}
