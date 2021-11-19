// import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:faceshot_teacher/models/attendance.dart';
import 'package:faceshot_teacher/utils/const.dart';
import 'package:http/http.dart' as http_client;

import '../firebase_firestore_service.dart';

///Class for handling all the API calls to Attendance Predictor APIS
class AttendancePredictorApiClient {
  ///Get Attendance prediction results
  static Future<List<Attendance>> getAttendancePrediction(
    String classImage,
  ) async {
    //Prepare the url
    Map? apiEndpoints = await FirestoreService.getPredictionApiEndpoint();
    String url = Const.apiBaseUrl;
    if (apiEndpoints !=null && apiEndpoints.isNotEmpty && apiEndpoints.containsKey('face_recognition_api_endpoint')) {
      url = apiEndpoints['face_recognition_api_endpoint'];
    }

    //Prepare the body
    Map body = {
      'image': classImage,
      //'total_students': [],
    };

    // log('Selected image:\n' + classImage);

    //Send the request
    final http_client.Response response = await http_client.post(
      Uri.parse(url),
      headers: <String, String>{'Accept': 'application/json'},
      body: jsonEncode(body),
    );

    //Handle the result
    final responseData = response.body;


    if (response.statusCode == 200) {
      log('result:\n' + response.body);
      List<Attendance> markedAttendances = [];
      List returnedAttendance = jsonDecode(responseData);
      // List returnedAttendance = [
      //   {
      //     "student_id": "N3gAFHY4Cxew1bgXWnVUa2MYPuR2",
      //     "attendance_confidence": 0.96,
      //     "student_detected_face_coordinates": {
      //       'topleft': [50, 50],
      //       'topright': [100, 50],
      //       'bottomright': [100, 100],o
      //       'bottomleft': [50, 100]
      //     }
      //   },
      //   {
      //     "student_id": "FI2Q5DEgUhUWXd6A6w7wy8dc2Kx1",
      //     "attendance_confidence": 0.8,
      //     "student_detected_face_coordinates": {
      //       'topleft': [70, 70],
      //       'topright': [700, 70],
      //       'bottomright': [700, 700],
      //       'bottomleft': [70, 700]
      //     }
      //   },
      // ];

      for (var attendanceData in returnedAttendance) {
        if (attendanceData['student_id'] != 'N/A') {
          markedAttendances.add(Attendance.fromJson(attendanceData));
        }
      }

      return markedAttendances;
    } else {
      return [];
    }
  }
}
