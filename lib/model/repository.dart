import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meeting_app/model/authorization.dart';
import 'package:meeting_app/model/event.dart';
import 'package:meeting_app/model/participation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<List<Event>> getEvents() async{
    var user_id = prefs.getString("user_id");
    final response = await http.post(
        Uri.parse('https://appmeeting.azurewebsites.net/events'),
        body: {"user_id": user_id}
    );
    List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    List<Event> events = data.map<Event>((json) => Event.fromJson(json)).toList();
    return events;
  }

  Future<String> addParticipant(String event_id, int status) async{
    var user_id = prefs.getString("user_id")!;
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
    print(jsonEncode(event));
    final response = await http.post(
      Uri.parse('https://appmeeting.azurewebsites.net/event/add'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(event),
    );
    print(response.body);
    dynamic json = jsonDecode(response.body);
    print(json);
    Event createdEvent = Event.fromJson(json);
    return createdEvent;
  }

}