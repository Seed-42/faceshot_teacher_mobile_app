import 'package:faceshot_teacher/models/teacher.dart';
import 'package:faceshot_teacher/models/timetable.dart';
import 'package:faceshot_teacher/services/firebase_firestore_service.dart';
import 'package:flutter/material.dart';

import 'timetable_day_edit_screen.dart';

class TimetableDayScreen extends StatefulWidget {
  final Teacher teacher;
  final String selectedDay;
  const TimetableDayScreen(this.teacher, this.selectedDay, {Key? key})
      : super(key: key);

  @override
  _TimetableDayScreenState createState() => _TimetableDayScreenState();
}

class _TimetableDayScreenState extends State<TimetableDayScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Timetable?>(
      future: FirestoreService.getTimeTable(widget.teacher.uid),
      builder: (BuildContext context, AsyncSnapshot<Timetable?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data == null ||
            snapshot.data!.timetableAgenda == null) {
          return Center(
            child: Text(
              'Please Add Timeslots',
              style: Theme.of(context).textTheme.headline6,
            ),
          );
        }
        List? todaysAgenda =
            snapshot.data!.timetableAgenda![widget.selectedDay.toLowerCase()];

        return Scaffold(
          appBar: AppBar(title: Text('Manage ${widget.selectedDay}')),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              //Push new screen
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimetableDayEditScreen(
                    widget.teacher,
                    widget.selectedDay,
                    snapshot.data!,
                  ),
                ),
              );

              //reload the updated timetable
              setState(() {});
            },
            label: const Text('Add a time slot'),
            icon: const Icon(Icons.add),
          ),
          body: (todaysAgenda != null && todaysAgenda.isNotEmpty)
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: todaysAgenda.length,
                  itemBuilder: (BuildContext context, int index) => ListTile(
                    title: Text('Class ${index + 1}'),
                    subtitle: Text(
                      'From ${todaysAgenda[index]['from']} To ${todaysAgenda[index]['to']}',
                    ),
                    onLongPress: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Remove this class?"),
                            content: const Text(
                              "This class will be removed permanently. Continue?",
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Yes"),
                                onPressed: () async {
                                  todaysAgenda.removeAt(index);
                                  snapshot.data!.timetableAgenda![
                                          widget.selectedDay.toLowerCase()] =
                                      todaysAgenda;
                                  await FirestoreService.setTimeTable(
                                      snapshot.data!);
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      setState(() {});
                    },
                  ),
                )
              : Center(
                  child: Text(
                    'Please Add Timeslots for ${widget.selectedDay}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
        );
      },
    );
  }
}
