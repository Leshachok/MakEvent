
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:meeting_app/model/repository.dart';
import '../model/event.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainViewModel with ChangeNotifier{

  late Repository repository;
  late SharedPreferences prefs;
  List<Event> _events = [];
  List<Event> _requests = [];

  MainViewModel(BuildContext context){
    repository = Repository();
    _events = [
      Event('Похід у кіно', 'Йдемо на Людину-Павука 3 у Планету Кіно', '13-12-2021', 'Небесної сотні, 14, Київський район, Одеса', 46.415794, 30.712190),
      Event('Актовський каньйон', 'Їдемо з німцями до каньйону в Миколаївській області', '16-09-2021 06:00', 'Золотий Дюк, Глушко, 12, Київський район, Одеса', 47.708668, 31.420617),
    ];
    _requests = [
      Event('Збір у Яни вдома', 'Можна все - але тихо', '04-11-2021', 'Сегедська 9а, 13, Приморський район, Одеса', 46.4499439, 30.744418),
    ];
    downloadEvents();
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

  Event getRequest(int position){
    return _requests[position];
  }

  List<Event> getRequests(){
    return _requests;
  }

}