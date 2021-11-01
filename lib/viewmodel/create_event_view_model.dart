import 'package:flutter/cupertino.dart';

class CreateEventViewModel with ChangeNotifier{

  String location = 'Выбрать место встречи';

  void setLocation(String location){
    this.location = location;
    notifyListeners();
  }

  String getLocation(){
    return location;
  }

}