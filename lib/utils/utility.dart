import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class Utility {
  static bool isValidEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (emailValid) {
      return true;
    } else {
      return false;
    }
  }

  ///Registration: Password min 6 character, one number, one capital letter, one special character - add complexity
  static bool isValidPassword(String pass) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    bool passValid = RegExp(pattern).hasMatch(pass);
    if (passValid) {
      return true;
    } else {
      return false;
    }
  }

  ///Returns Alert Dialog Box
  static void showAlertDialog(BuildContext context, String title, String body) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static String format24HourTime(TimeOfDay tod) {
    final DateTime now = DateTime.now();
    final DateTime dt =
        DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final DateFormat format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  ///Returns Confirmation Dialog Box
  static Future<bool> showConfirmationDialog(
      BuildContext context, String title, String body) async {
    // flutter defined function
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  ///Takes input from the user and returns the text
  static Future showTextInputDialog(
      BuildContext context, String title, String defaultValue) async {
    final TextEditingController _textFieldController =
        TextEditingController(text: defaultValue);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 10.0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(title),
            content: TextField(
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop(_textFieldController.text);
                },
              ),
            ],
          );
        });
  }

  //Show loading pop up
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Loading, please wait..."),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Shows the snackbar
  static void showSnackBar(BuildContext context, String msg) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  //Show Toast Message
  static void showSnackBarScaffold({
    required scaffoldKey,
    required String text,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    try {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(text),
          action: (buttonText != null && onPressed != null)
              ? SnackBarAction(label: buttonText, onPressed: onPressed)
              : null,
        ),
      );
    } catch (e) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(text)),
      );
    }
  }

  static Future<String> getFilePath(File file) async {
    return basename(file.path);
  }

  // Open next screen
  static Future<Map> changeScreen(BuildContext context, Widget widget) async {
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => widget));
  }

  // Open next screen clear last one screen
  static Future<dynamic> pushReplacement(
      BuildContext context, Widget widget) async {
    return await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => widget));
  }

  static Future<dynamic> push(BuildContext context, Widget widget) async {
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => widget));
  }

  static Future<Map> clearState(BuildContext context, Widget widget) async {
    return await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget),
        (Route<dynamic> route) => false);
  }

  // Check internet
  static Future<bool> checkInternet() async {
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
