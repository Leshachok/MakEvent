import 'package:flutter/cupertino.dart';
import 'package:meeting_app/model/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel with ChangeNotifier{

  late Repository repository;

  AuthViewModel(){
    repository = Repository();
  }

  void authorize(SharedPreferences prefs, dynamic json) async{
    String id = json['_id'];
    prefs.setString("user_id", id);
  }

  Future<String> register(String email, String password){
    return repository.register(email, password);
  }

  Future<String> login(String email, String password){
    return repository.login(email, password);
  }

}