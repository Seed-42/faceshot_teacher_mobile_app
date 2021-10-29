import 'dart:convert';

import 'package:faceshot_teacher/models/attendance.dart';
import 'package:faceshot_teacher/utils/const.dart';
import 'package:http/http.dart' as http_client;

///Class for handling all the API calls to Attendance Predictor APIS
class AttendancePredictorApiClient {
  ///Get Attendance prediction results
  static Future<List<Attendance>> getAttendancePrediction(
      String classImage) async {
    //Prepare the url
    String url = '${Const.apiBaseUrl}/get_prediction';

    //Send the request
    // final http_client.Response response = await http_client.get(
    //   Uri.parse(url),
    //   headers: <String, String>{'Accept': 'application/json'},
    // );

    //Handle the result
    // final responseData = response.body;
    // if (response.statusCode == 200) {
    List<Attendance> markedAttendances = [];
    List returnedAttendance = [
      {
        "student_id": "N3gAFHY4Cxew1bgXWnVUa2MYPuR2",
        "attendance_confidence": 0.96,
        "student_detected_face_coordinates": {
          'topleft': [50, 50],
          'topright': [500, 50],
          'bottomright': [500, 500],
          'bottomleft': [50, 500]
        }
      },
      {
        "student_id": "FI2Q5DEgUhUWXd6A6w7wy8dc2Kx1",
        "attendance_confidence": 0.8,
        "student_detected_face_coordinates": {
          'topleft': [70, 70],
          'topright': [700, 70],
          'bottomright': [700, 700],
          'bottomleft': [70, 700]
        }
      },
    ];

    returnedAttendance.forEach((attendanceData) {
      markedAttendances.add(Attendance.fromJson(attendanceData));
    });

    return markedAttendances;
    // } else {
    //   return [];
    // }
  }
}
