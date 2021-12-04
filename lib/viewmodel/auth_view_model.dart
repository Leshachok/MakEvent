import 'package:flutter/cupertino.dart';
import 'package:meeting_app/model/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel with ChangeNotifier{

  late Repository repository;

  AuthViewModel(){
    repository = Repository();
  }

  void authorize(dynamic json){
    repository.authorize(json);
  }

  Future<String> register(String email, String password){
    return repository.register(email, password);
  }

  Future<String> login(String email, String password){
    return repository.login(email, password);
  }

  Future<String> findUserByEmail(String email){
    return repository.findUserByEmail(email);
  }

}