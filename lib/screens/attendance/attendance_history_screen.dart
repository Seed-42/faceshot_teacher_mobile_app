// import 'package:faceshot_teacher/models/teacher.dart';
// import 'package:faceshot_teacher/models/timetable.dart';
// import 'package:faceshot_teacher/services/firebase_firestore_service.dart';
// import 'package:flutter/material.dart';

// class AttendanceHistoryScreen extends StatefulWidget {
//   final Teacher teacher;
//   final Timetable timetable;
//   const AttendanceHistoryScreen(this.teacher, this.timetable, {Key? key})
//       : super(key: key);

//   @override
//   _AttendanceHistoryScreenState createState() =>
//       _AttendanceHistoryScreenState();
// }

// class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attendance history'),
//       ),
//       body: FutureBuilder(
//         future: FirestoreService.getAllAttendancesForTimetable(
//           widget.timetable.uid,
//         ),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.data == null) {
//             return Center(
//               child: Text(
//                 'No Attendances yet',
//                 style: Theme.of(context).textTheme.headline5,
//               ),
//             );
//           }

//           return ListView();
//         },
//       ),
//     );
//   }
// }
