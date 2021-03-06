import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faceshot_teacher/models/attendance.dart';
import 'package:faceshot_teacher/models/student.dart';
import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/models/timetable.dart';

class FirestoreService {
  /// Gets the model API endpoint from Firebase database
  static Future<Map?> getPredictionApiEndpoint() async {
    //Get the user profile data
    DocumentSnapshot queriedApiEndpoints = await FirebaseFirestore.instance
        .collection('Variables').doc('API')
        .get();

    if (queriedApiEndpoints.exists) {
        return queriedApiEndpoints.data() as Map;
    } else {
      return null;
    }
  }

  /// Gets the userProfile from the [userEmail]
  static Future<Teacher?> getTeacherProfile(String userEmail) async {
    //Get the user profile data
    QuerySnapshot queriedProfiles = await FirebaseFirestore.instance
        .collection('Teachers')
        .where('teacher_email', isEqualTo: userEmail)
        .get();

    // Get the First queried result and return
    if (queriedProfiles.docs.isNotEmpty && queriedProfiles.docs.first.exists) {
      try {
        Map teacherData = queriedProfiles.docs.first.data() as Map;
        return Teacher.fromMap(teacherData);
      } catch (_) {
        return null;
      }
    } else {
      return null;
    }
  }

  /// Sets the Teacher profile
  static Future setTeacherProfile(Teacher teacher) async {
    //Get the user profile data
    await FirebaseFirestore.instance
        .collection('Teachers')
        .doc(teacher.uid)
        .set(teacher.toMap);
  }

  /// Gets the student profile from the [studentEmail] or [studentUid]
  static Future<Student?> getStudentProfile({
    String? studentEmail,
    String? studentUid,
  }) async {
    if (studentEmail != null) {
      //Get the user profile data
      QuerySnapshot queriedProfiles = await FirebaseFirestore.instance
          .collection('Students')
          .where('student_email', isEqualTo: studentEmail)
          .get();

      // Get the First queried result and return
      if (queriedProfiles.docs.isNotEmpty &&
          queriedProfiles.docs.first.exists) {
        try {
          Map studentData = queriedProfiles.docs.first.data() as Map;
          return Student.fromMap(studentData);
        } catch (_) {
          return null;
        }
      } else {
        return null;
      }
    } else if (studentUid != null) {
      //Get the user profile data
      DocumentSnapshot studentProfileDocumentSnapshot = await FirebaseFirestore
          .instance
          .collection('Students')
          .doc(studentUid)
          .get();

      // Get the First queried result and return
      if (studentProfileDocumentSnapshot.exists) {
        try {
          return Student.fromMap(studentProfileDocumentSnapshot.data() as Map);
        } catch (_) {
          return null;
        }
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  /// Gets the Timetable from the [timeTableUid]
  static Future<Timetable?> getTimeTable(String timeTableUid) async {
    //Get the user profile data
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Timetables')
        .doc(timeTableUid)
        .get();

    // Get the First queried result and return
    if (documentSnapshot.exists) {
      try {
        Map timeTableData = documentSnapshot.data() as Map;
        return Timetable.fromMap(timeTableData);
      } catch (_) {
        return null;
      }
    } else {
      return null;
    }
  }

  /// Sets the Timetable from the [timeTableUid]
  static Future setTimeTable(Timetable timeTable) async {
    //Get the user profile data
    await FirebaseFirestore.instance
        .collection('Timetables')
        .doc(timeTable.uid)
        .set(timeTable.toMap);
  }

  /// Gets the Timetable from the [timeTableUid]
  static Future<List<Attendance>> getAttendance(
      String timetableUid, String attendanceUid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Attendances')
        .doc(timetableUid)
        .collection(attendanceUid)
        .get();

    // Get the First queried result and return
    final List<Attendance> attendance = [];
    if (querySnapshot.size > 0) {
      for (var element in querySnapshot.docs) {
        if (element.data() != null && element.exists) {
          attendance.add(Attendance.fromJson(element.data()! as Map));
        }
      }
    }

    return attendance;
  }

  /// Sets the Attendance from the [attendance]
  static Future setAttendance(
    String timeTableUid,
    String attendanceUid,
    List<Attendance> attendance,
  ) async {
    //Get the user profile data
    for (Attendance studentAttendance in attendance) {
      await FirebaseFirestore.instance
          .collection('Attendances')
          .doc(timeTableUid)
          .collection(attendanceUid)
          .doc(studentAttendance.studentUid)
          .set(studentAttendance.toMap);
    }
  }
}
