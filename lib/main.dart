import 'package:flutter/material.dart';
import 'package:meeting_app/view/login_screen.dart';
import 'package:meeting_app/viewmodel/auth_view_model.dart';
import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) => MaterialApp(
        title: 'Meeting App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.red
        ),
        home: ChangeNotifierProvider(
            create: (BuildContext context) => AuthViewModel(),
            child: LoginScreen()
        ),
  );


}


