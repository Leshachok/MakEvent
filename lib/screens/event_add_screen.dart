
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meeting_app/model/add_event_model.dart';
import 'package:meeting_app/model/event.dart';
import 'package:meeting_app/model/event_model.dart';
import 'package:meeting_app/screens/map_dialog.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class EventAddScreen extends StatefulWidget {
  @override
  _EventAddScreenState createState() => _EventAddScreenState();
}

class _EventAddScreenState extends State<EventAddScreen> {

  late String title;
  late String description;
  String date = '1 января 1970, 00:00';
  late String location;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children:[
              Column(
                children: [
                  Container(
                    height: 72,
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (text){
                        title = text;
                      },
                      maxLength: 20,
                      decoration: InputDecoration(
                          hintText: 'Название встречи',
                          hintStyle: const TextStyle(
                            color: Color.fromRGBO(94, 98, 102, 1),
                          ),
                          counterText: '',
                          border: InputBorder.none,
                          icon: GestureDetector(
                            child: const Icon(
                              Icons.close,
                              color: Color.fromRGBO(94, 98, 102, 1),
                              size: 44,
                            ),
                            onTap: onBackButtonPressed,
                          )
                      ),
                    )
                  ),
                  Divider(
                    height: 1,
                  ),
                  Container(
                    height: 72,
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        onChanged: (text){
                          description = text;
                        },
                        maxLines: 1,
                        maxLength: 66,
                        decoration: InputDecoration(
                            hintText: 'Описание',
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(94, 98, 102, 1),
                            ),
                            counterText: '',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 12),
                            icon: GestureDetector(
                              child: const Icon(
                                Icons.message_rounded,
                                color: Color.fromRGBO(94, 98, 102, 1),
                                size: 24,
                              ),
                              onTap: onBackButtonPressed,
                            )
                        ),
                      )
                  ),
                  Divider(
                    height: 1,
                  ),
                  Container(
                      height: 72,
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Color.fromRGBO(94, 98, 102, 1),
                            size: 24,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 28),
                            child: GestureDetector(
                              child: const Text(
                                'Выбрать дату и время встречи',
                                style: TextStyle(
                                    color: Color.fromRGBO(94, 98, 102, 1),
                                    fontSize: 16
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  GestureDetector(
                    onTap: onAddPlaceButtonPressed,
                    child: Container(
                        height: 72,
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.place,
                              color: Color.fromRGBO(94, 98, 102, 1),
                              size: 24),
                            Container(
                              padding: const EdgeInsets.only(left: 28),
                              child: Consumer<AddEventModel>(
                                builder: (context, value, child){
                                  location = value.location;
                                  return Text(
                                    value.location,
                                    style: const TextStyle(
                                        color: Color.fromRGBO(94, 98, 102, 1),
                                        fontSize: 16
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Container(
                    height: 72,
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.photo,
                          color: Color.fromRGBO(94, 98, 102, 1),
                          size: 24,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 28),
                          child: GestureDetector(
                            child: const Text(
                              'Выбрать фото',
                              style: TextStyle(
                                  color: Color.fromRGBO(94, 98, 102, 1),
                                  fontSize: 16
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      child: RawMaterialButton(
                        shape: const CircleBorder(),
                        elevation: 0.0,
                        fillColor: const Color.fromRGBO(255, 32, 75, 230),
                        child: const Icon(
                          Icons.add,
                          size: 32,
                          color: Color.fromRGBO(255, 23, 68, 1),
                        ),
                        onPressed: (){},
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        child: const Text(
                          'ПРИГЛАСИТЬ ДРУЗЕЙ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(255, 32, 75, 25),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.all(16),
        width: 320,
          child: TextButton(
              onPressed: onCreateButtonPressed,
              child: const Text(
                  'Создать встречу',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white
                ),
              )
        ),
        decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Color.fromRGBO(255, 23, 68, 1)
        ),
      )
    );
  }

  void onBackButtonPressed() => Navigator.pop(context);

  void onCreateButtonPressed(){
    Event newEvent = Event(title, description, date, location);
    var model = context.read<EventModel>();
    model.addEvent(newEvent);
    Navigator.pop(context);
  }


  void onAddPlaceButtonPressed() {
    AddEventModel model = context.read<AddEventModel>();
    showDialog(
        context: context,
        builder: (context){
              return AlertDialog(
                title: const Text('Выбрать место встречи'),
                contentPadding: EdgeInsets.only(top: 16, left: 24, right: 24),
                content: SizedBox(
                    height: 360,
                    child: GoogleMapDialog(model)
                ),
                actionsPadding: EdgeInsets.symmetric(vertical: 0),
                actions: [
                  TextButton(
                      onPressed: onLocationChosen,
                      child: Text('Подтвердить'))
                ],

              );

        },
    ).then((value){
      getAdressByCoords(model.location);
    });
  }

  void onLocationChosen(){
    Navigator.pop(context, true);
  }

  Future<void> getAdressByCoords(String location) async {
    String token = "FuZGxQQZBxOgVzK6uwCF51hZycZjWdwgX8TIL_d4e7I";
    String url = "https://revgeocode.search.hereapi.com/v1/revgeocode?at=$location&apiKey=$token";
    print(url);
    var response = await http.get(Uri.parse(url));
    var json = response.body;
    Map<String, dynamic> map = jsonDecode(json);
    var adress = map['items']![0]['address']['label'];
    // var bytes = adress.codeUnits;
    // adress = utf8.decode(bytes);
    print(adress);
  }

}