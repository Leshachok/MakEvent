import 'package:flutter/material.dart';
import 'package:meeting_app/view/main_screen.dart';

void main() => runApp(MeetingApp());

class MeetingApp extends StatefulWidget {
  @override
  _MeetingAppState createState() => _MeetingAppState();
}

class _MeetingAppState extends State<MeetingApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Meeting App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.red
        ),
        home: MainScreen(),
      );
  }


}


