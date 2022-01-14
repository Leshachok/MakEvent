import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:meeting/model/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel with ChangeNotifier{

  late Repository repository;

  AuthViewModel(){
    repository = Repository();
  }

  void authorize(dynamic json, String email){
    repository.authorize(json, email);
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

  void getFCMToken() {
    var fm = FirebaseMessaging.instance;
    fm.getToken().then((token) async {
      await saveTokenToDatabase(token);
    });

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  saveTokenToDatabase(String? token) {
    if(token == null) return;
    repository.setFCMToken(token);
  }

}