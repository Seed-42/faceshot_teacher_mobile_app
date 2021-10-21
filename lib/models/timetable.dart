/// Timetable Model
class Timetable {
  late String uid, authorUid;
  List<String>? subscribedStudents = [];
  Map? timetableAgenda;

  Timetable(
    this.uid,
    this.authorUid, {
    this.subscribedStudents,
    this.timetableAgenda,
  });

  Timetable.formMap(Map teacherData) {
    uid = teacherData['timetable_uid'];
    authorUid = teacherData['timetable_author_uid'];

    if (teacherData.containsKey('timetable_subscribed_students')) {
      subscribedStudents = teacherData['timetable_subscribed_students'];
    }
    if (teacherData.containsKey('timetable_agenda')) {
      timetableAgenda = teacherData['timetable_agenda'];
    }
  }

  Map<String, dynamic> get toMap {
    Map<String, dynamic> teacherData = {
      'timetable_uid': uid,
      'timetable_author_uid': authorUid,
    };

    if (subscribedStudents != null && subscribedStudents!.isNotEmpty) {
      teacherData['timetable_subscribed_students'] = subscribedStudents;
    }
    if (timetableAgenda != null && timetableAgenda!.isNotEmpty) {
      teacherData['timetable_agenda'] = timetableAgenda;
    }
    return teacherData;
  }
}
