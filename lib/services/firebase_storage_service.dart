// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class FirebaseUploadProfilePhotoDialog extends StatefulWidget {
//   FileType pickingType;
//   String fileName, fileURL, pathStorageParentFolder, title;

//   FirebaseUploadProfilePhotoDialog(this.title, this.fileName, this.fileURL, this.pathStorageParentFolder, this.pickingType);

//   @override
//   State<StatefulWidget> createState() => FirebaseUploadProfilePhotoDialogState();
// }

// class FirebaseUploadProfilePhotoDialogState extends State<FirebaseUploadProfilePhotoDialog> with SingleTickerProviderStateMixin {
//   AnimationController controller;
//   Animation<double> scaleAnimation;

//   UploadTask uploadTask;
//   double dbUploadStatus = 0;
//   String fileURL;

//   @override
//   void initState() {
//     super.initState();

//     controller = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
//     scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

//     controller.addListener(() {
//       setState(() {});
//     });

//     controller.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);

//     return Center(
//       child: Material(
//         color: Colors.transparent,
//         child: ScaleTransition(
//           scale: scaleAnimation,
//           child: Card(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   //Title
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(widget.title, style: theme.textTheme.headline6),
//                       IconButton(
//                         padding: const EdgeInsets.only(left: 16.0),
//                         icon: const Icon(Icons.close, color: Colors.grey),
//                         onPressed: () {
//                           if (uploadTask != null) uploadTask.cancel();
//                           Future.delayed(Duration.zero, () {
//                             Navigator.of(context).pop();
//                           });
//                         },
//                       )
//                     ],
//                   ),

//                   //Upload picture
//                   getSelectionWidget(theme),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   //get an upload widget
//   getSelectionWidget(ThemeData theme) {
//     //When no path is selected
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.all(12),
//           child: (widget.fileURL == null || widget.fileURL == '')
//               ? Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: FloatingActionButton.extended(
//                     backgroundColor: theme.primaryColor,
//                     label: const Text('Upload', style: TextStyle(color: Colors.white)),
//                     icon: const Icon(Icons.upload_rounded, color: Colors.white),
//                     onPressed: uploadFile,
//                   ),
//                 )
//               : (widget.fileURL.contains('http') || widget.fileURL.contains('www.'))
//                   ? InkWell(
//                       child: (widget.fileURL.toLowerCase().contains('.png') ||
//                               widget.fileURL.toLowerCase().contains('.jpg') ||
//                               widget.fileURL.toLowerCase().contains('.jpeg') ||
//                               widget.fileURL.toLowerCase().contains('.gif') ||
//                               widget.fileURL.toLowerCase().contains('.bmp') ||
//                               widget.fileURL.toLowerCase().contains('bmp') ||
//                               widget.fileURL.toLowerCase().contains('ebp'))
//                           ? widget.fileURL.contains('http://') || widget.fileURL.contains('https://')
//                               ? Image.network(
//                                   widget.fileURL,
//                                   width: 100,
//                                   height: 100,
//                                 )
//                               : Image.file(
//                                   File(widget.fileURL),
//                                   width: 100,
//                                   height: 100,
//                                 )
//                           : Icon(
//                               Icons.insert_drive_file,
//                               color: theme.primaryColor,
//                               size: 72,
//                             ),
//                       onTap: uploadFile,
//                     )
//                   : Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Text(dbUploadStatus.toString() + '%'),
//                         SizedBox(
//                           height: 50,
//                           width: 50,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: CircularProgressIndicator(
//                               value: dbUploadStatus,
//                               semanticsLabel: dbUploadStatus.toString(),
//                               valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//         ),
//       ],
//     );
//   }

//   //Uploads the file to the database
//   void uploadFile() async {
//     String val = await _openFileExplorer();
//     setState(() => widget.fileURL = val);
//     uploadDocuments(widget.fileName ?? widget.fileURL.split('/').last.split('.').first, widget.fileURL.split('/').last.split('.').last);
//   }

//   //Uploads the documents to Firebase Storage to the given path
//   void uploadDocuments(String filename, String fileExt) async {
//     //Upload the File
//     uploadTask =
//         FirebaseStorage.instance.ref().child(widget.pathStorageParentFolder + '/' + filename + '.' + fileExt).putFile(File(widget.fileURL));

//     //Get upload status
//     uploadTask.snapshotEvents.listen((TaskSnapshot event) {
//       setState(() {
//         dbUploadStatus = event.bytesTransferred / event.totalBytes * 100;
//       });
//     });

//     //Get the uploaded url
//     final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() {}));
//     final String url = await downloadUrl.ref.getDownloadURL();

//     //get the uploaded url
//     if (url != null) {
//       widget.fileURL = url;
//       Navigator.of(context).pop(url);
//     } else {
//       widget.fileURL = '';
//     }
//   }

//   Future<String> _openFileExplorer() async {
//     String _path = '';
//     try {
//       _path = (await FilePicker.platform.pickFiles(allowMultiple: false, type: widget.pickingType)).paths.first;
//     } catch (e) {
//       print('Unsupported operation' + e.toString());
//     }
//     return _path;
//   }
// }
