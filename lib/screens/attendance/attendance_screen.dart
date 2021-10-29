import 'package:faceshot_teacher/models/attendance.dart';
import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/models/timetable.dart';
import 'package:faceshot_teacher/services/firebase_firestore_service.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(title: const Text('Attendance for today')),
      body: FutureBuilder<List<Attendance>>(
        future: _loadAttendanceItems(),
        builder: (context, AsyncSnapshot<List<Attendance>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('Not Attdance Data found'));
          }

          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text('${snapshot.data![index].studentUid}'),
                subtitle: Text(
                  'Marked ' +
                      (snapshot.data![index].confidence > 0.9
                          ? 'Present'
                          : 'Absent') +
                      ', with ${snapshot.data![index].confidence * 100}% accuracy',
                ),
                trailing: TextButton(
                  child: const Text('Change attendance'),
                  onPressed: () async {
                    if (snapshot.data![index].confidence > 0.9) {
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

  Future<List<Attendance>> _loadAttendanceItems() async {
    // Download attdance photo from storage

    // Return database data
    return await FirestoreService.getAttendance(
      widget.timetable.uid,
      widget.attendanceUid,
    );
  }
}
