import 'dart:typed_data';

import 'package:faceshot_teacher/models/attendance.dart';
import 'package:faceshot_teacher/models/student.dart';
import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/models/timetable.dart';
import 'package:faceshot_teacher/services/firebase_firestore_service.dart';
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
      body: widget.attendances.isEmpty
          ? const Center(child: Text('Not Attendance Data found'))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 25.0,
              ),
              itemCount: widget.attendances.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getStudentNameText(
                      widget.attendances[index].studentUid,
                    ),
                    Text(
                      'Marked ' +
                          (widget.attendances[index].confidence > 0.5
                              ? 'Present'
                              : 'Absent') +
                          ', with ${widget.attendances[index].confidence * 100}% accuracy',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Image.network(
                      showGoogleDriveImage(widget.attendances[index].fileUrl),
                      height: 100,
                    ),
                    TextButton(
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
                    )
                  ],
                );
              },
            ),
      // body: FutureBuilder<List<Attendance>>(
      //   future: _loadAttendanceItems(),
      //   builder: (context, AsyncSnapshot<List<Attendance>> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     if (snapshot.data == null || snapshot.data!.isEmpty) {
      //       return const Center(child: Text('Not Attendance Data found'));
      //     }
      //
      //     return ListView.builder(
      //       itemCount: snapshot.data?.length,
      //       itemBuilder: (BuildContext context, int index) {
      //         return ListTile(
      //           leading: snapshot.data![index].studentDetectedFace != null
      //               ? Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Image.memory(base64Decode(
      //                     snapshot.data![index].studentDetectedFace!,
      //                   )),
      //                 )
      //               : snapshot.data![index].coordinates != null
      //                   ? Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: _getDetectedFaceImage(
      //                         snapshot.data![index].coordinates,
      //                       ),
      //                     )
      //                   : const SizedBox(),
      //           title: getStudentNameText(snapshot.data![index].studentUid),
      //           subtitle: Text(
      //             'Marked ' +
      //                 (snapshot.data![index].confidence > 0.5
      //                     ? 'Present'
      //                     : 'Absent') +
      //                 ', with ${snapshot.data![index].confidence * 100}% accuracy',
      //           ),
      //           trailing: TextButton(
      //             child: const Text('Change attendance'),
      //             onPressed: () async {
      //               if (snapshot.data![index].confidence < 0.5) {
      //                 snapshot.data![index].confidence = 1;
      //               } else {
      //                 snapshot.data![index].confidence = 0;
      //               }
      //               FirestoreService.setAttendance(
      //                 widget.timetable.uid,
      //                 widget.attendanceUid,
      //                 snapshot.data!,
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

  /// Takes the google drive image url and returns a url string which is viewable by Image.network
  String showGoogleDriveImage(String url) {
    if (url.contains('http://drive.google.com/uc?export=view&id=')) {
      return url.replaceAll('http://drive.google.com/uc?export=view&id=',
          'https://drive.google.com/uc?export=view&id=');
    } else {
      return url;
    }
  }

  // // Get the detected photo
  // FutureBuilder _getDetectedFaceImage(Coordinates? coordinates) {
  //   return FutureBuilder<ui.Image>(
  //     future: _getClassAttendanceImage(),
  //     builder: (
  //       BuildContext context,
  //       AsyncSnapshot<ui.Image> snapshot,
  //     ) {
  //       if (snapshot.data == null) {
  //         return const SizedBox();
  //       }
  //
  //       //Load picture
  //       if (coordinates != null) {
  //         return FittedBox(
  //           child: SizedBox(
  //             width: 500,
  //             height: 500,
  //             child: CustomPaint(
  //               painter: SquarePainter(
  //                 snapshot.data!,
  //                 //left
  //                 coordinates.topLeft.first * 0.0,
  //                 //top
  //                 coordinates.topLeft.last + 0.0,
  //                 //width
  //                 coordinates.bottomRight.first -
  //                     coordinates.bottomLeft.first +
  //                     0.0,
  //                 //height
  //                 coordinates.bottomRight.last -
  //                     coordinates.topRight.last +
  //                     0.0,
  //               ),
  //             ),
  //           ),
  //         );
  //       } else {
  //         return const SizedBox();
  //       }
  //     },
  //   );
  // }

  // Future<ui.Image> _getClassAttendanceImage() async {
  //   final Directory appDocDir = await getApplicationDocumentsDirectory();
  //   final fileAttendanceFinalImage =
  //       File('${appDocDir.path}/${widget.attendanceUid}.jpg');
  //
  //   return await loadImage(
  //     Uint8List.view(fileAttendanceFinalImage.readAsBytesSync().buffer),
  //   );
  // }

  Future<ui.Image> loadImage(Uint8List bytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  // Future<List<Attendance>> _loadAttendanceItems() async {
  //   // Download attendance photo from storage
  //
  //   // Return database data
  //   return await FirestoreService.getAttendance(
  //     widget.timetable.uid,
  //     widget.attendanceUid,
  //   );
  // }

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
