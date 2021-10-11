
import 'package:flutter/cupertino.dart';
import 'event.dart';

class EventModel with ChangeNotifier{

  List<Event> _events = [];

  EventModel();

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

}