class Attendance {
  late String studentUid;
  late double confidence;
  Coordinates? coordinates;
  String? studentDetectedFace;
  late String fileUrl;

  Attendance(
    this.studentUid,
    this.confidence,
    this.studentDetectedFace,
    this.fileUrl,
  );

  Attendance.fromJson(Map attendanceData) {
    if (attendanceData.containsKey('attendance_student_uid')) {
      studentUid = attendanceData['attendance_student_uid'];
    } else if (attendanceData.containsKey('student_id')) {
      studentUid = attendanceData['student_id'];
    }

    if (attendanceData.containsKey('attendance_confidence')) {
      confidence = attendanceData['attendance_confidence'];
    } else if (attendanceData.containsKey('student_attendance_confidence')) {
      confidence = attendanceData['student_attendance_confidence'];
    }

    if (attendanceData
        .containsKey('attendance_student_detected_face_coordinates')) {
      if (attendanceData['attendance_student_detected_face_coordinates']
          is String) {
        studentDetectedFace =
            attendanceData['attendance_student_detected_face_coordinates'];
      } else {
        coordinates =
            attendanceData['attendance_student_detected_face_coordinates'];
      }
    } else if (attendanceData
        .containsKey('student_detected_face_coordinates')) {
      if (attendanceData['student_detected_face_coordinates'] is String) {
        studentDetectedFace =
            attendanceData['student_detected_face_coordinates'];
      } else {
        coordinates = Coordinates.fromJson(
            attendanceData['student_detected_face_coordinates']);
      }
    } else if (attendanceData.containsKey('file_url')) {
      fileUrl = attendanceData['file_url'];
    }
  }

  Map<String, dynamic> get toMap {
    Map<String, dynamic> mapToReturn = {
      'attendance_student_uid': studentUid,
      'attendance_confidence': confidence,
    };
    if (coordinates != null) {
      mapToReturn['attendance_student_detected_face_coordinates'] =
          coordinates!.toMap;
    } else if (studentDetectedFace != null) {
      mapToReturn['attendance_student_detected_face_coordinates'] =
          studentDetectedFace;
    } else if (fileUrl.isNotEmpty) {
      mapToReturn['file_url'] = fileUrl;
    }
    return mapToReturn;
  }
}

class Coordinates {
  late List topLeft, topRight, bottomLeft, bottomRight;

  Coordinates(this.topLeft, this.topRight, this.bottomLeft, this.bottomRight);

  Coordinates.fromJson(Map coordinateData) {
    if (coordinateData.containsKey('topleft')) {
      topLeft = coordinateData['topleft'];
    } else if (coordinateData.containsKey('top_left')) {
      topLeft = coordinateData['top_left'];
    }
    if (coordinateData.containsKey('topright')) {
      topRight = coordinateData['topright'];
    } else if (coordinateData.containsKey('top_right')) {
      topRight = coordinateData['top_right'];
    }
    if (coordinateData.containsKey('bottomleft')) {
      bottomLeft = coordinateData['bottomleft'];
    } else if (coordinateData.containsKey('bottom_left')) {
      bottomLeft = coordinateData['bottom_left'];
    }
    if (coordinateData.containsKey('bottomright')) {
      bottomRight = coordinateData['bottomright'];
    } else if (coordinateData.containsKey('bottom_right')) {
      bottomRight = coordinateData['bottom_right'];
    }
  }

  Map<String, dynamic> get toMap {
    return {
      'top_left': topLeft,
      'top_right': topRight,
      'bottom_left': bottomLeft,
      'bottom_right': bottomRight,
    };
  }
}
