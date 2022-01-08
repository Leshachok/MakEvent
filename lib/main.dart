import 'package:flutter/material.dart';
import 'package:meeting/view/main_screen.dart';
import 'package:meeting/view/welcome_screen.dart';
import 'package:meeting/viewmodel/auth_view_model.dart';
import 'package:meeting/viewmodel/main_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  runApp(MeetingApp());
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
            create: (BuildContext context) => MainViewModel()
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


