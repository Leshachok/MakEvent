import 'dart:convert';

import 'package:meeting/data/authorization.dart';
import 'package:meeting/data/event.dart';
import 'package:meeting/data/participant.dart';
import 'package:meeting/data/participation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Repository{

  static final Repository _singleton = Repository._internal();
  late SharedPreferences prefs;
  static const KEY_USER_ID = "user_id";
  static const KEY_USER_NAME = "user_name";

  factory Repository() {
    return _singleton;
  }

  Repository._internal(){
    initPrefs();
  }

  Future<void> initPrefs() async{
    prefs = await SharedPreferences.getInstance();
  }

  Future<String> register(String email, String password) async{
    final auth = Authorization(email, password);
    final response = await http.post(
      Uri.parse('https://appmeeting.azurewebsites.net/register'),
      headers: {
        "Content-Type": "application/json",
      },
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(auth),
    );
    return response.body;
  }

  Future<String> login(String email, String password) async{
    final auth = Authorization(email, password);
    final response = await http.post(
      Uri.parse('https://appmeeting.azurewebsites.net/login'),
      headers: {
        "Content-Type": "application/json",
      },
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(auth),
    );
    return response.body;
  }

  void authorize(dynamic json){
    String id = json['_id'];
    String name = json['name'];
    prefs.setString(KEY_USER_ID, id);
    prefs.setString(KEY_USER_NAME, name);
  }

  bool isAuthorized() => prefs.containsKey(KEY_USER_ID);

  logout() async{
    var response = await removeFCMToken();

    print(response);
    prefs.remove(KEY_USER_ID);
    prefs.remove(KEY_USER_NAME);
  }

  Future<String> updateUser(String newName) async{
    var userId = prefs.getString(KEY_USER_ID);
    final response = await http.post(
      Uri.parse('https://appmeeting.azurewebsites.net/user/update'),
      body: { "name": newName, KEY_USER_ID: userId },
    );
    return response.body;
  }

  String getUserName() => prefs.getString(KEY_USER_NAME)!;

  String getUserId() => prefs.getString(KEY_USER_ID)!;

  bool checkUserID(String userId) => prefs.getString(KEY_USER_ID)! == userId;

  setUsername(String username) => prefs.setString(KEY_USER_NAME, username);


  Future<List<Event>> getEvents() async{
    var userId = prefs.getString(KEY_USER_ID);
    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/events'),
        body: { KEY_USER_ID: userId }
    );
    List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    List<Event> events = data.map<Event>((json) => Event.fromJson(json)).toList();
    return events;
  }

  Future<List<Event>> getRequests() async{
    var userId = prefs.getString(KEY_USER_ID);
    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/requests'),
        body: { KEY_USER_ID: userId }
    );
    List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    List<Event> events = data.map<Event>((json) => Event.fromJson(json)).toList();
    return events;
  }

  Future<String> addParticipant(String userId, String eventId, int status) async{

    var body = Participation(eventId, userId, status);
    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/event/participant'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body)
    );
    print(response.body);
    return response.body;
  }

  Future<Event> createEvent(Event event) async{
    final response = await http.post(
      Uri.parse('https://appmeeting.azurewebsites.net/event/add'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(event),
    );
    dynamic json = jsonDecode(response.body);
    Event createdEvent = Event.fromJson(json);
    return createdEvent;
  }

  Future<void> deleteEvent(String eventId) async{

    final response = await http.post(
      Uri.parse('https://appmeeting.azurewebsites.net/event/delete'),
      body: {"event_id": eventId},
    );
    dynamic json = jsonDecode(response.body);
    print(json);
  }

  Future<String> updateRequest(String eventId, int status) async{
    var userId = prefs.getString(KEY_USER_ID)!;
    var body = Participation(eventId, userId, status);

    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/participant/update'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body)
    );

    return response.body;
  }

  Future<String> findUserByEmail(String email) async{
    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/user/findByEmail'),
        body: {"email": email}
    );
    return response.body;
  }

  //TODO себя нельзя приглашать
  Future<String> findUserbyNickname(String nickname) async{
    var userName = prefs.getString(KEY_USER_NAME)!;
    if(nickname == userName) {
      return """{"message": "Не можна запросити себе на зустріч!"}""";
    }
    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/user/findByName'),
        body: {"name": nickname}
    );
    print(response.body);
    return response.body;
  }

  Future<List<Participant>> getParticipants(String eventId) async{
    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/event/participants'),
        body: { "event_id": eventId }
    );
    List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    List<Participant> participants = data.map<Participant>((json) => Participant.fromJson(json)).toList();
    return participants;
  }

  Future<dynamic> setFCMToken(String token) async{
    if(!isAuthorized()) return;
    var user_id = getUserId();
    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/fcm/set'),
        body: { "user_id": user_id, "token": token }
    );

    return response.body;
  }

  Future<dynamic> removeFCMToken() async{
    var user_id = getUserId();
    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/fcm/remove'),
        body: { "user_id": user_id }
    );

    return response.body;
  }

}