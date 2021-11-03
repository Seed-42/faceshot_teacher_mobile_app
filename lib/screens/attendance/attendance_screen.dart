import 'dart:io';
import 'dart:typed_data';

import 'package:faceshot_teacher/models/attendance.dart';
import 'package:faceshot_teacher/models/student.dart';
import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/models/timetable.dart';
import 'package:faceshot_teacher/services/firebase_firestore_service.dart';
import 'package:faceshot_teacher/widgets/square_painter.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:async';

class AttendanceScreen extends StatefulWidget {
  final Teacher teacher;
  final Timetable timetable;
  final Map selectedTimeSlot;
  final String attendanceUid;

  const AttendanceScreen(
      this.teacher, this.timetable, this.selectedTimeSlot, this.attendanceUid,
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
        title: const Text('Attendance for today'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              // Navigator.of(context).popUntil(
              //   ModalRoute.withName("/"),
              // );
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: FutureBuilder<List<Attendance>>(
        future: _loadAttendanceItems(),
        builder: (context, AsyncSnapshot<List<Attendance>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('Not Attendance Data found'));
          }

          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: snapshot.data![index].coordinates != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _getDetectedFaceImage(
                          snapshot.data![index].coordinates,
                        ),
                      )
                    : const SizedBox(),
                title: getStudentNameText(snapshot.data![index].studentUid),
                subtitle: Text(
                  'Marked ' +
                      (snapshot.data![index].confidence > 0.5
                          ? 'Present'
                          : 'Absent') +
                      ', with ${snapshot.data![index].confidence * 100}% accuracy',
                ),
                trailing: TextButton(
                  child: const Text('Change attendance'),
                  onPressed: () async {
                    if (snapshot.data![index].confidence < 0.5) {
                      snapshot.data![index].confidence = 1;
                    } else {
                      snapshot.data![index].confidence = 0;
                    }
                    FirestoreService.setAttendance(
                      widget.timetable.uid,
                      widget.attendanceUid,
                      snapshot.data!,
                    );

                    setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Get the detected photo
  FutureBuilder _getDetectedFaceImage(Coordinates? coordinates) {
    return FutureBuilder<ui.Image>(
      future: _getClassAttendanceImage(),
      builder: (
        BuildContext context,
        AsyncSnapshot<ui.Image> snapshot,
      ) {
        if (snapshot.data == null) {
          return const SizedBox();
        }

        //Load picture
        if (coordinates != null) {
          return FittedBox(
            child: SizedBox(
              width: 500,
              height: 500,
              child: CustomPaint(
                painter: SquarePainter(
                  snapshot.data!,
                  //left
                  coordinates.topLeft.first * 0.0,
                  //top
                  coordinates.topLeft.last + 0.0,
                  //width
                  coordinates.bottomRight.first -
                      coordinates.bottomLeft.first +
                      0.0,
                  //height
                  coordinates.bottomRight.last -
                      coordinates.topRight.last +
                      0.0,
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Future<ui.Image> _getClassAttendanceImage() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final fileAttendanceFinalImage =
        File('${appDocDir.path}/${widget.attendanceUid}.jpg');

    return await loadImage(
        Uint8List.view(fileAttendanceFinalImage.readAsBytesSync().buffer));
  }

  Future<ui.Image> loadImage(Uint8List bytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<List<Attendance>> _loadAttendanceItems() async {
    // Download attdance photo from storage

    // Return database data
    return await FirestoreService.getAttendance(
      widget.timetable.uid,
      widget.attendanceUid,
    );
  }

  FutureBuilder<Student?> getStudentNameText(String studentUid) {
    return FutureBuilder<Student?>(
      future: FirestoreService.getStudentProfile(studentUid: studentUid),
      builder: (BuildContext context, AsyncSnapshot<Student?> snapshot) {
        if (snapshot.data == null) {
          return Text(studentUid);
        } else {
          return Text(snapshot.data!.name);
        }
      },
    );
  }
}
