import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:meeting_app/model/event.dart';
import 'package:meeting_app/model/repository.dart';

class CreateEventViewModel with ChangeNotifier{

  late Repository repository;
  late String title;
  late String description;
  late String date;
  String time = "";
  String location = 'Выбрать место встречи';
  double latitude = 0.0;
  double longitude = 0.0;

  CreateEventViewModel(){
    repository = Repository();
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
    addParticipant(response.getId());
  }

  Future<void> addParticipant(String event_id) async{
    await repository.addParticipant(event_id, 3);
  }

}