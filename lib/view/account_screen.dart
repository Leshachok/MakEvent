import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width ;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Color.fromRGBO(255, 23, 68, 1),
          ),
          Container(
            margin: EdgeInsets.only(top: 180),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(48))
            ),
          ),
          Positioned(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(80.0),
                  child: Image.asset(
                      'lib/images/avatar.jpg',
                    height: 160,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32),
                  width: 160,
                  child: const Text(
                      'Лешачук Костя',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 80),
                  width: 280,
                  child: const Text(
                    'Не могу найти сообщение с тем что должно быть в настройках',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                )
              ],
            ),
            top: 100,
          )
        ],
      ),
    );
  }
}
