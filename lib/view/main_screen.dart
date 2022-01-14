import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meeting/view//account_screen.dart';
import 'package:meeting/view/event_list_screen.dart';
import 'package:meeting/view/request_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{

  var currentIndex = 0;

  List<Widget> fragments = [
    EventListScreen(),
    RequestScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: fragments[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        backgroundColor: const Color.fromRGBO(255, 23, 68, 1),
        unselectedItemColor: Colors.white.withOpacity(0.6),
        onTap: onBottomAppbarTapped,
        currentIndex:  currentIndex,
        items: const [
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
          BottomNavigationBarItem(
              label: "Акаунт",
              icon: Icon(
                  Icons.account_circle
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

}
