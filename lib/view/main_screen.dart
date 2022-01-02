
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meeting_app/view//account_screen.dart';
import 'package:meeting_app/view/event_list_screen.dart';
import 'package:meeting_app/view/request_screen.dart';
import 'package:meeting_app/viewmodel/main_view_model.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{

  var currentIndex = 0;

  List<Widget> fragments = [
    AccountScreen(),
    EventListScreen(),
    RequestScreen()
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: fragments[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromRGBO(198, 255, 0, 1),
        backgroundColor: const Color.fromRGBO(255, 23, 68, 1),
        onTap: onBottomAppbarTapped,
        currentIndex:  currentIndex,
        items: const [
          BottomNavigationBarItem(
              label: "Акаунт",
              icon: Icon(
                  Icons.account_circle
              )
          ),
          BottomNavigationBarItem(
              label: "Зустрічі",
              icon: Icon(
                  Icons.message
              )
          ),
          BottomNavigationBarItem(
              label: "Запрошення",
              icon: Icon(
                  Icons.notifications_active
              )
          ),
        ],
      ),
    );
  }

  void onBottomAppbarTapped(int position){
    setState(() {
      currentIndex = position;
    });
  }

  initViewModel() {
     context.read<MainViewModel>().init();
  }

}
