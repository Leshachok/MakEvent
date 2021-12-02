import 'dart:convert';

import 'package:meeting_app/data/authorization.dart';
import 'package:meeting_app/data/event.dart';
import 'package:meeting_app/data/participant.dart';
import 'package:meeting_app/data/participation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Repository{
  static final Repository _singleton = Repository._internal();
  late SharedPreferences prefs;

  factory Repository() {
    return _singleton;
  }

  Repository._internal(){
    initPrefs();
  }

  void initPrefs() async{
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
    prefs.setString("user_id", id);
    prefs.setString("user_name", name);
  }

  Future<String> updateNickname(String newName) async{
    var user_id = prefs.getString("user_id");
    final response = await http.post(
      Uri.parse('https://appmeeting.azurewebsites.net/user/update'),
      body: { "name": newName, "user_id": user_id },
    );
    return response.body;
  }

  String getUserName() => prefs.getString("user_name")!;

  void setUsername(String username){
    prefs.setString("user_name", username);
  }

  Future<List<Event>> getEvents() async{
    var user_id = prefs.getString("user_id");
    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/events'),
        body: { "user_id": user_id }
    );
    List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    List<Event> events = data.map<Event>((json) => Event.fromJson(json)).toList();
    return events;
  }

  Future<List<Event>> getRequests() async{
    var user_id = prefs.getString("user_id");
    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/requests'),
        body: { "user_id": user_id }
    );
    List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    List<Event> events = data.map<Event>((json) => Event.fromJson(json)).toList();
    return events;
  }

  Future<String> addParticipant(String user_id, String event_id, int status) async{

    var body = Participation(event_id, user_id, status);
    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/event/participant'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body)
    );

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

  Future<String> updateRequest(String event_id, int status) async{
    var user_id = prefs.getString("user_id")!;
    var body = Participation(event_id, user_id, status);

    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/participant/update'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body)
    );

    return response.body;
  }

  //TODO себя нельзя приглашать
  Future<String> findUserbyNickname(String nickname) async{
    var user_name = prefs.getString("user_name")!;
    if(nickname == user_name) {
      return """{"message": "Не можна запросити себе на зустріч!"}""";
    }
    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/user/findByName'),
        body: {"name": nickname}
    );
    print(response.body);
    return response.body;
  }

  Future<List<Participant>> getParticipants(String event_id) async{
    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/event/participants'),
        body: { "event_id": event_id }
    );
    List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    List<Participant> participants = data.map<Participant>((json) => Participant.fromJson(json)).toList();
    return participants;
  }


}