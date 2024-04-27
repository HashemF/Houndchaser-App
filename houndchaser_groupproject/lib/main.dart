import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houndchaser_groupproject/Pets/db/cubit/pet_db_cubit.dart';
import 'package:houndchaser_groupproject/Pets/db/pet_db.dart';
import 'Pets/auth/cubit/auth_cubit.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {

  //This line ensures widget initialized before firebase starts (required)
  WidgetsFlutterBinding.ensureInitialized();

  //Sets time zone for notifications
  tz.initializeTimeZones(); // Initialize timezone data
  tz.setLocalLocation(tz.getLocation('America/New_York'));
  // Create an instance of the plugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Specify the icon to be used for Android notifications
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_notification");

  // Combine initialization settings for all platforms
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Initialize the plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider<PetDBCubit>(
              create: (_)=>PetDBCubit(PetDatabase()),
            ),
            BlocProvider<AuthCubit>(
                create: (_)=>AuthCubit()
            )
          ],
        child: const MyApp(),
      ),
  );
}
