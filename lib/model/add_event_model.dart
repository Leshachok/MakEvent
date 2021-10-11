import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddEventModel with ChangeNotifier{

  String location = 'Выбрать место встречи';

  void setLocation(String location){

    this.location = location;
    notifyListeners();
  }

  String getLocation(){
    return location;
  }

}