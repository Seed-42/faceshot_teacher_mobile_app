import 'dart:async';
import 'dart:io';
import 'package:faceshot_teacher/models/attendance.dart';
import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/models/timetable.dart';
import 'package:faceshot_teacher/services/firebase_firestore_service.dart';
import 'package:faceshot_teacher/services/network/attendance_predictor_api_client.dart.dart';
import 'package:faceshot_teacher/utils/utility.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

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

    controller = CameraController(cameras[0], ResolutionPreset.medium);
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
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CameraPreview(controller!),
          ),
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
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Camera
                          IconButton(
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

                          const SizedBox(width: 50),

                          //Gallery
                          IconButton(
                            icon: const Icon(
                              Icons.image_rounded,
                              size: 56,
                            ),
                            onPressed: () async {
                              //Get the picture
                              final ImagePicker _picker = ImagePicker();
                              XFile? imageFile = await _picker.pickImage(
                                source: ImageSource.gallery,
                              );

                              //Get the prediction and go to the next page
                              if (imageFile != null) {
                                setState(() {
                                  isLoading = true;
                                });
                                await _getAttendancePredication(imageFile);
                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                Utility.showSnackBar(
                                  context,
                                  'No Image selected',
                                );
                              }
                            },
                          ),
                        ],
                      ),
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

    late File fileAttendanceFinalImage;
    late File? fileAttendanceCameraInitialImage;
    String attendanceUid =
        '${widget.selectedTimeSlot['from']}-${DateTime.now().month}-${DateTime.now().year}';

    late TaskSnapshot snapshot;
    if (kIsWeb) {
      //path to save Storage
      fileAttendanceFinalImage = File('temp/$attendanceUid.jpg');

      //Upload this image to Firebase Storage
      snapshot = await FirebaseStorage.instance
          .refFromURL('urlFromStorage')
          .child(
              'Attendances/${widget.timetable.uid}/${fileAttendanceFinalImage.uri.pathSegments.last}')
          .putFile(fileAttendanceFinalImage);
    } else {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      fileAttendanceFinalImage = File('${appDocDir.path}/$attendanceUid.jpg');
      fileAttendanceCameraInitialImage = File(classImage.path);
      await fileAttendanceCameraInitialImage
          .copy(fileAttendanceFinalImage.path);

      //Upload this image to Firebase Storage
      snapshot = await FirebaseStorage.instance
          .ref()
          .child(
              'Attendances/${widget.timetable.uid}/${fileAttendanceFinalImage.uri.pathSegments.last}')
          .putFile(fileAttendanceFinalImage);
    }

    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      //Get the Attendance from the ML model
      setState(() {
        currentProcess = 'Running ML model on the picture';
      });

      // Convert the image to base64
      // Uint8List uint8List = await classImage.readAsBytes();
      // String base64EncodedImage = base64Encode(uint8List);
      // List<Attendance> attendances =
      //     await AttendancePredictorApiClient.getAttendancePrediction(
      //   base64EncodedImage,
      // );

      List<Attendance> attendances =
          await AttendancePredictorApiClient.getAttendancePrediction(
        downloadUrl,
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
      if (fileAttendanceCameraInitialImage != null) {
        fileAttendanceCameraInitialImage.delete();
      }

      //Go to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceScreen(
            widget.teacher,
            widget.timetable,
            widget.selectedTimeSlot,
            attendanceUid,
            attendances,
          ),
        ),
      );
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
  }
}
