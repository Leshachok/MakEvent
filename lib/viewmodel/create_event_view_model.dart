import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:meeting_app/data/event.dart';
import 'package:meeting_app/model/repository.dart';
import 'package:meeting_app/data/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateEventViewModel with ChangeNotifier{

  late SharedPreferences prefs;
  late Repository repository;
  late String title;
  late String description;
  late String date;
  String time = "";
  String location = 'Выбрать место встречи';
  double latitude = 0.0;
  double longitude = 0.0;
  List<User> users = [];

  CreateEventViewModel(){
    repository = Repository();
    initPrefs();
  }

  void initPrefs() async{
    prefs = await SharedPreferences.getInstance();
  }

  void setLocation(String location){
    this.location = location;
    notifyListeners();
  }

  String getLocation(){
    return location;
  }

  Future<void> createEvent(Event event) async{
    final response = await repository.createEvent(event);
    users.forEach((user) async {
      await addParticipant(user.getId(), response.getId(), 0);
    });
    var user_id = prefs.getString("user_id")!;
    await addParticipant(user_id, response.getId(), 3);
  }

  Future<void> addParticipant(String user_id, String event_id, int status) async{

    await repository.addParticipant(user_id, event_id, status);

  }

  Future<String> findUserbyNickname(String nickname) async{
    return await repository.findUserbyNickname(nickname);
  }

  void addUser(User user){
    users.add(user);
    notifyListeners();
  }

  User getUser(int position){
    return users[position];
  }

}