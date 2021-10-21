import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/models/timetable.dart';
import 'package:faceshot_teacher/services/firebase_firestore_service.dart';
import 'package:faceshot_teacher/utils/utility.dart';
import 'package:faceshot_teacher/widgets/form_fields/text_form_field.dart';
import 'package:flutter/material.dart';

class TimetableDayEditScreen extends StatefulWidget {
  final Teacher teacher;
  final String selectedDay;
  final Timetable timetable;
  const TimetableDayEditScreen(this.teacher, this.selectedDay, this.timetable,
      {Key? key})
      : super(key: key);

  @override
  _TimetableDayEditScreenState createState() => _TimetableDayEditScreenState();
}

class _TimetableDayEditScreenState extends State<TimetableDayEditScreen> {
  final TextEditingController fromHour = TextEditingController(),
      fromMinute = TextEditingController(),
      toHour = TextEditingController(),
      toMinute = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add a new class for ${widget.selectedDay}')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 40),

            // From
            const Text('Enter class start time:'),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: CustomTextFormField(
                    controller: fromHour,
                    hintText: 'Fromn Hour',
                    labelText: 'Hour',
                    prefixIcon: const Icon(Icons.email),
                    validator: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'This is a required field';
                      } else if (int.tryParse(val) == null) {
                        return 'Please enter a valid Hour';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: CustomTextFormField(
                    controller: fromMinute,
                    hintText: 'To Minute',
                    labelText: 'Minute',
                    prefixIcon: const Icon(Icons.email),
                    validator: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'This is a required field';
                      } else if (int.tryParse(val) == null) {
                        return 'Please enter a valid Minute';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // To
            const Text('Enter class finish time:'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: CustomTextFormField(
                    controller: toHour,
                    hintText: 'To Hour',
                    labelText: 'Hour',
                    prefixIcon: const Icon(Icons.email),
                    validator: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'This is a required field';
                      } else if (int.tryParse(val) == null) {
                        return 'Please enter a valid Hour';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: CustomTextFormField(
                    controller: toMinute,
                    hintText: 'To Minute',
                    labelText: 'Minute',
                    prefixIcon: const Icon(Icons.email),
                    validator: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'This is a required field';
                      } else if (int.tryParse(val) == null) {
                        return 'Please enter a valid Minute';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            //Create your Account
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });

                  //Initialize the objects when creating a new agenda
                  widget.timetable.timetableAgenda ??= {};
                  widget.timetable.timetableAgenda![
                      widget.selectedDay.toLowerCase()] ??= [];

                  //Add the current timings
                  widget.timetable
                      .timetableAgenda![widget.selectedDay.toLowerCase()]
                      .add(
                    {
                      'from': '${fromHour.text}:${fromMinute.text}',
                      'to': '${toHour.text}:${toMinute.text}',
                    },
                  );

                  await FirestoreService.setTimeTable(widget.timetable);

                  //Go to the prev screen
                  Navigator.of(context).pop();

                  setState(() {
                    isLoading = false;
                  });
                } else {
                  Utility.showSnackBar(
                    context,
                    'Please check the errors in the fields',
                  );
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text('Add Class'),
            ),
          ],
        ),
      ),
    );
  }
}
