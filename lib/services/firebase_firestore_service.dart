import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/models/timetable.dart';

class FirestoreService {
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
        return Teacher.formMap(teacherData);
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
        return Timetable.formMap(timeTableData);
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
}
