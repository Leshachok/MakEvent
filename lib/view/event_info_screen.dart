
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meeting_app/model/event.dart';
import 'package:meeting_app/model/user.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class EventInfoScreen extends StatefulWidget {

  late Event _event;

  EventInfoScreen(this._event);

  @override
  _EventInfoScreenState createState() => _EventInfoScreenState(_event);
}

class _EventInfoScreenState extends State<EventInfoScreen> {

  List<User> users = [];
  late Event _event;

  _EventInfoScreenState(this._event);

  @override
  void initState() {
    super.initState();
    getJsonFromFile();
  }

  void getJsonFromFile() async{
    String json = await rootBundle.loadString('lib/users.json');
    var list = (jsonDecode(json) as List<dynamic>);
    list.forEach((element) {
      users.add(User.fromJson(element));
    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    var loc = _event.location;
    if(loc.length > 28) loc = loc.substring(0, 27) + '..';
    return Scaffold(
        body: Column(
          children:[
            Stack(
                children:[
                  Hero(
                    tag: "event_${_event.getId()}_image",
                    child: Image.asset('lib/images/ski.jpg')
                  ),
                  Positioned(
                    top: 50,
                    left: 16,
                    child: ElevatedButton(
                      onPressed: onBackButtonPressed,
                      child: const Icon(Icons.arrow_back_rounded),
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          fixedSize: Size(50, 50),
                          primary: const Color.fromARGB(150, 0, 0, 0)
                      ),
                    ),
                  ),
                  Positioned(
                      top: 48,
                      right: 16,
                      child: ElevatedButton(
                        onPressed: onDeleteButtonPressed,
                        child: const Icon(Icons.restore_from_trash),
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            fixedSize: Size(50, 50),
                            primary: const Color.fromARGB(150, 0, 0, 0)
                        ),
                      ),
                  )
                ]
            ),
            Container(
              margin: const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
              child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          _event.title,
                          style: const TextStyle(
                              fontSize: 30
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          _event.description,
                          maxLines: 3,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.grey
                          ),
                        ),
                      )
                    ],
                  )
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 20,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        _event.date,
                        style: const TextStyle(
                            fontSize: 18
                        ),
                      )
                  )
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.place,
                          color: Color.fromRGBO(255, 23, 68, 1),
                          size: 20,
                        ),
                        Container(
                            padding: const EdgeInsets.only(left: 10),
                            child:  Text(
                              loc,
                              style: const TextStyle(
                                  fontSize: 18
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: onCreateRoute,
                      icon: const Icon(
                        Icons.subdirectory_arrow_right,
                        color: Color.fromRGBO(255, 23, 68, 1),
                        size: 32,
                      )
                  )

                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),

              child: const Divider(
                height: 10,
                thickness: 0.8,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.people,
                    size: 20,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'Участники',
                        style: TextStyle(
                            fontSize: 18
                        ),
                      )
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int position){
                      return getRow(position);
                      },
                    physics: BouncingScrollPhysics(),
                  ),
                ),
              ),

            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color.fromRGBO(255, 23, 68, 1),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: TextButton(
              onPressed: (){},
              style: const ButtonStyle(
                  splashFactory: NoSplash.splashFactory
              ),
              child: const Text(
                '',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget getRow(int position) {
    return GestureDetector(
      onLongPress: (){
        users.removeAt(position);
        setState(() {});
      },
      onTap: (){
        users[position].status = users[position].status == 0 ? 1 : users[position].status == 1 ? 2 : 0;
        setState(() {

        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Container(
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Icon(
                      Icons.camera_alt,
                      size: 25,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        users[position].name,
                        style: const TextStyle(
                            fontSize: 18
                        ),
                      ),
                    )
                  ],
                ),
              ),
              getStatus(position)
            ]
        ),
      ),
    );
  }

  void onDeleteButtonPressed() => {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Вы действительно хотите отменить встречу?'),
            content: null,
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Нет'),
              ),
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Да'),
              )
            ],
          );
        })
  };

  void onCreateRoute() async{
    var url = 'https://www.google.com/maps?f=d&daddr=${_event.latitude.toString()},${_event.longitude.toString()}&dirflg=d';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void onBackButtonPressed() => Navigator.pop(context);

  Widget getStatus(int pos){
    Color textColor = users[pos].status == 0 ? Color.fromRGBO(255, 23, 68, 1) : users[pos].status == 1 ? Colors.green : Colors.blue;
    Color backColor = textColor.withAlpha(50);
    String text = users[pos].status == 0 ? "Слился" : users[pos].status == 1 ? "Будет" : "Зачинщик";

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: backColor
      ),
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 4),
      child: Text(
        text,
        style: TextStyle(
            color: textColor,
            fontSize: 18
        ),
      ),
    );
  }
}