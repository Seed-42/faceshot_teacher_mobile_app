import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:faceshot_teacher/models/attendance.dart';
import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/models/timetable.dart';
import 'package:faceshot_teacher/services/firebase_firestore_service.dart';
import 'package:faceshot_teacher/services/network/attendance_predictor_api_client.dart.dart';
import 'package:faceshot_teacher/utils/utility.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

import 'attendance_screen.dart';

class CameraScreen extends StatefulWidget {
  final Teacher teacher;
  final Timetable timetable;
  final Map selectedTimeSlot;

  const CameraScreen(this.teacher, this.timetable, this.selectedTimeSlot,
      {Key? key})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription> cameras = [];
  bool isLoading = false;
  String currentProcess = 'Clicking picture from camera';

  CameraController? controller;

  @override
  void initState() {
    initializeCameras();

    super.initState();
  }

  Future initializeCameras() async {
    cameras = await availableCameras();

    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || controller?.value.isInitialized == false) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: isLoading
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      Text(currentProcess),
                    ],
                  )
                  : IconButton(
                      icon: const Icon(
                        Icons.camera_rounded,
                        size: 56,
                      ),
                      onPressed: () async {
                        XFile? file = await takePicture();
                        if (mounted) {
                          if (file == null) {
                            Utility.showSnackBar(
                              context,
                              'Please try again',
                            );
                          } else {
                            //Get the picture
                            XFile? imageFile = file;

                            //Get the prediction and go to the next page
                            setState(() {
                              isLoading = true;
                            });
                            await _getAttendancePredication(imageFile);
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }

  // Take a picture from the camera
  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (_) {
      //print(e);
      return null;
    }
  }

  Future _getAttendancePredication(XFile classImage) async {
    //Copy the image file from camera to documents directory
    setState(() {
      currentProcess = 'Uploading picture to Cloud';
    });
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String attendanceUid =
        '${widget.selectedTimeSlot['from']}-${DateTime.now().month}-${DateTime.now().year}';
    final fileAttendanceFinalImage =
        File('${appDocDir.path}/$attendanceUid.jpg');
    final fileAttendanceCameraInitialImage = File(classImage.path);
    await fileAttendanceCameraInitialImage.copy(fileAttendanceFinalImage.path);

    //Upload this image to Firebase Storage
    TaskSnapshot snapshot = await FirebaseStorage.instance
        .ref()
        .child(
            'Attendances/${widget.timetable.uid}/${fileAttendanceFinalImage.uri.pathSegments.last}')
        .putFile(fileAttendanceFinalImage);
    if (snapshot.state == TaskState.success) {
      //final String downloadUrl = await snapshot.ref.getDownloadURL();
    } else {
      Utility.showSnackBar(
        context,
        'Error uploading the image: ${snapshot.state.toString()}',
      );
      setState(() {
        currentProcess = 'Clicking picture from camera';
      });
      return;
    }

    //Get the Attendance from the ML model
    setState(() {
      currentProcess = 'Running ML model on the picture';
    });
    Uint8List uint8List = await classImage.readAsBytes();
    String base64EncodedImage = base64Encode(uint8List);
    List<Attendance> attendances =
        await AttendancePredictorApiClient.getAttendancePrediction(
      base64EncodedImage,
    );

    //Update the Database
    setState(() {
      currentProcess = 'Updating database';
    });
    await FirestoreService.setAttendance(
      widget.timetable.uid,
      attendanceUid,
      attendances,
    );

    //Delete the original file
    fileAttendanceCameraInitialImage.delete();

    //Go to the next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceScreen(
          widget.teacher,
          widget.timetable,
          widget.selectedTimeSlot,
          attendanceUid,
        ),
      ),
    );
  }
}
