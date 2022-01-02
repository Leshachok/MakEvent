import 'package:flutter/material.dart';
import 'package:meeting_app/view/main_screen.dart';
import 'package:meeting_app/view/welcome_screen.dart';
import 'package:meeting_app/viewmodel/auth_view_model.dart';
import 'package:meeting_app/viewmodel/main_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async{
  await initFireBase();
  runApp(MeetingApp());
}

initFireBase() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.data}");
}


class MeetingApp extends StatefulWidget {
  @override
  _MeetingAppState createState() => _MeetingAppState();
}

class _MeetingAppState extends State<MeetingApp> {

  _MeetingAppState(){
    initPrefs();
  }

  Widget? screen;

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => AuthViewModel()),
        ChangeNotifierProvider(
            create: (BuildContext context) => MainViewModel(context)
        )
      ],
      child: MaterialApp(
          title: 'Meeting App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Colors.red
          ),
          home: screen
      ),
    );
  }

  initPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    screen = preferences.containsKey("user_id") ? MainScreen() : WelcomeScreen();
    setState(() {

    });
  }

}


