import 'package:flutter/cupertino.dart';
import 'package:houndchaser_groupproject/Routes/route_generator.dart';
import 'package:houndchaser_groupproject/Widgets/LoginButton.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houndchaser_groupproject/Pets/db/cubit/pet_db_cubit.dart';

///ScheduleWalk
///Select a time and pet(s)
///navigates to a select_pets_view
///Walks will associate the selected pets with them
///A notification will be sent reminding the user it's time for a walk
///
/// @author Evan


class ScheduleWalk extends StatefulWidget {
  const ScheduleWalk({super.key});

  @override
  _ScheduleWalkState createState() => _ScheduleWalkState();
}

class _ScheduleWalkState extends State<ScheduleWalk> {
  DateTime? _selectedTime;
  bool _timeSelected = false; // Track if a time has been selected

  @override
  Widget build(BuildContext context) {
    // If a date is selected, display the selected time
    String buttonText = _timeSelected
        ? 'Selected Time: ${DateFormat.jm().format(_selectedTime!)}'
        : 'Select Time';

    //variable for actual time, use getTime to set reminder time
    String time = _timeSelected
        ? DateFormat.jm().format(_selectedTime!)
        : DateFormat.jm().format(DateTime.now());

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: LoginButton(),
        middle: const Text('Schedule a Walk'),
        backgroundColor: CupertinoColors.systemBrown,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Image.asset('assets/WalkingDog.png'),
            ),
            CupertinoButton(
              key: const Key('timeSelectButton'),
              onPressed: _showTimePicker,
              child: Text(buttonText),
            ),
            Expanded(
              child: Image.asset('assets/hopefulDog.png'),
            ),
            CupertinoButton(
              key: const Key('selectPetsButton'),
              onPressed: () => Navigator.pushNamed(context, RouteGenerator.selectPetPage),
              child: const Text('Select Pets'),
            ),
            CupertinoButton(
              key: const Key('doneButton'),
              onPressed: () {
                scheduleNotification();
                Navigator.of(context).pop();
              },
              child: const Text('Done', style: TextStyle(fontSize: 32)),
            ),
          ],
        ),
      ),
    );
  }

  //Schedules a notification to inform user it is time for a walk
  Future<void> scheduleNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      '1',
      'WalkTime',
      channelDescription: 'Informs user it is time to start their walk',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    //set selected time to now if null
    if (_selectedTime != null) {
      final now = DateTime.now();
      final selectedTimeToday = DateTime(
          now.year, now.month, now.day, _selectedTime!.hour,
          _selectedTime!.minute);

      //Calculate time to display notification
      Duration difference = selectedTimeToday.difference(now);

      //If selected time is in the past, assume it is for the next day
      if (difference.isNegative) {
        difference += const Duration(days: 1); //Add 24 hours
      }

      //get pet names to display in notification
      final selectedPets = context
          .read<PetDBCubit>()
          .state
          .selectedPets;
      String petNames = "";
      for (var i = 0; i < selectedPets.length; i++) {
        petNames = "$petNames${selectedPets[i].name} and ";
      }
      if (selectedPets.isNotEmpty){
        //Trim the trailing "and"
        petNames = petNames.substring(0, petNames.length - 5);
        petNames = '$petNames!';
      }
      else{petNames = "no one, you did not select any pets!";}
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'It is time for your scheduled walk!',
        'Today you are walking $petNames',
        // Schedule the notification to show in 5 seconds from now, adjust accordingly
        tz.TZDateTime.now(tz.local).add(difference),
        notificationDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time, // To match the time components only
      );
    }
  }

  void _showTimePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: _selectedTime ?? DateTime.now(),
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    _selectedTime = newDateTime;
                    _timeSelected = true; //time has been selected
                  });
                },
              ),
            ),
            CupertinoButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
