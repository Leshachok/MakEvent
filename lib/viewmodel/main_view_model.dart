
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:meeting_app/data/participant.dart';
import 'package:meeting_app/model/repository.dart';
import '../data/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainViewModel with ChangeNotifier{

  late Repository repository;
  late SharedPreferences prefs;
  List<Event> _events = [];
  List<Event> _requests = [];
  String username = "";
  bool isVaccinated = false;
  bool vaccinationSwitch = false;
  String vaccination = "";

  MainViewModel(BuildContext context){
    repository = Repository();
    _events = [
      Event('Похід у кіно', 'Йдемо на Людину-Павука 3 у Планету Кіно', '13-12-2021', 'Небесної сотні, 14, Київський район, Одеса', 46.415794, 30.712190, false),
      Event('Актовський каньйон', 'Їдемо з німцями до каньйону в Миколаївській області', '16-09-2021 06:00', 'Золотий Дюк, Глушко, 12, Київський район, Одеса', 47.708668, 31.420617, true),
    ];
    _requests = [
      Event('Збір у Яни вдома', 'Можна все - але тихо', '04-11-2021', 'Сегедська 9а, 13, Приморський район, Одеса', 46.4499439, 30.744418, false),
    ];
  }

  Future<void> init() async{
    await repository.initPrefs();
    getUsername();
    getVaccination();
    downloadEvents();
    downloadRequests();
  }

  Event getEvent(int position){
    return _events[position];
  }

  List<Event> getEvents(){
    return _events;
  }

  Future<void> downloadEvents() async{
    _events = await repository.getEvents();
    notifyListeners();
  }

  Future<void> deleteEvent(String event_id) async{
    await repository.deleteEvent(event_id);
    await downloadEvents();
  }

  Future<void> downloadRequests() async{
    _requests = await repository.getRequests();
    notifyListeners();
  }

  Future<void> updateRequest(String event_id, int status) async{
    await repository.updateRequest(event_id, status);
    await downloadRequests();
    await downloadEvents();
    notifyListeners();
  }

  Future<List<Participant>> getParticipants(String event_id) async{
    return await repository.getParticipants(event_id);
  }

  Event getRequest(int position){
    return _requests[position];
  }

  List<Event> getRequests(){
    return _requests;
  }

  bool isAuthorized() => repository.isAuthorized();

  logout() => repository.logout();

  Future<String> updateUser(String newName, String vaccination) async{
    return await repository.updateUser(newName, vaccination);
  }

  void setUsername(String username){
    repository.setUsername(username);
    getUsername();
  }

  void setVaccination(String vacciantion) {
    repository.setVaccination(vacciantion);
    getVaccination();
  }

  void getUsername() {
    username = repository.getUserName();
    notifyListeners();
  }

  void getVaccination() {
    vaccination = repository.getVaccination();
    isVaccinated = vaccination == "Вакцинований";
    vaccinationSwitch = isVaccinated;
    notifyListeners();
  }

  void setVaccinationSwitch(bool vacciantion) {
    vaccinationSwitch = vacciantion;
    notifyListeners();
  }


  bool checkUserID(String user_id) => repository.checkUserID(user_id);

}