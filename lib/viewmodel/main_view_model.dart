
import 'package:flutter/cupertino.dart';
import '../model/event.dart';

class MainViewModel with ChangeNotifier{

  List<Event> _events = [];
  List<Event> _requests = [];

  MainViewModel(){
    _events = [
      Event('Похід у кіно', 'Йдемо на Людину-Павука 3 у Планету Кіно', '13-12-2021', 'Небесної сотні, 14, Київський район, Одеса'),
      Event('Актовський каньйон', 'Їдемо з німцями до каньйону в Миколаївській області', '16-09-2021 06:00', 'Золотий Дюк, Глушко, 12, Київський район, Одеса'),
    ];
    _requests = [
      Event('Збір у Яни вдома', 'Можна все - але тихо', '04-11-2021', 'Сегедська 9а, 13, Приморський район, Одеса'),
    ];
  }

  void addEvent(Event event){
    _events.add(event);
    notifyListeners();
  }

  Event getEvent(int position){
    return _events[position];
  }

  List<Event> getEvents(){
    return _events;
  }

  Event getRequest(int position){
    return _requests[position];
  }


  List<Event> getRequests(){
    return _requests;
  }

}