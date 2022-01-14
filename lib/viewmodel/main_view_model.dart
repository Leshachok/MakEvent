import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:meeting/data/participant.dart';
import 'package:meeting/model/repository.dart';
import '../data/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';

class MainViewModel with ChangeNotifier{

  late Repository repository;
  late SharedPreferences prefs;
  List<Event> _events = [];
  List<Event> _requests = [];
  String username = "";
  String email = "";
  bool isNewNicknameDifferent = false;

  MainViewModel(){
    repository = Repository();
    init();
  }

  Future<void> init() async{
    await repository.initPrefs();
    initFireBase();
    getUsername();
    getEmail();
    downloadEvents();
    downloadRequests();
  }

  Event getEvent(int position){
    return _events[position];
  }

  List<Event> getEvents(){
    return _events;
  }

  Future<void> downloadEvents() async{
    _events = await repository.getEvents();
    notifyListeners();
  }

  Future<void> deleteEvent(String event_id) async{
    await repository.deleteEvent(event_id);
    await downloadEvents();
  }

  Future<void> downloadRequests() async{
    _requests = await repository.getRequests();
    notifyListeners();
  }

  Future<void> updateRequest(String event_id, int status) async{
    await repository.updateRequest(event_id, status);
    await downloadRequests();
    await downloadEvents();
    notifyListeners();
  }

  Future<List<Participant>> getParticipants(String event_id) async{
    return await repository.getParticipants(event_id);
  }

  Event getRequest(int position){
    return _requests[position];
  }

  List<Event> getRequests(){
    return _requests;
  }

  void checkNewNickname(String nickname){
    if(username != nickname){
      isNewNicknameDifferent = true;
      notifyListeners();
    }
  }

  bool isAuthorized() => repository.isAuthorized();

  logout() => repository.logout();


  Future<String> updateUser(String newName) async{
    return await repository.updateUser(newName);
  }

  void setUsername(String username){
    repository.setUsername(username);
    getUsername();
  }


  void getUsername() {
    username = repository.getUserName();
    notifyListeners();
  }

  void getEmail() {
    email = repository.getUserEmail();
    print(email);
    notifyListeners();
  }

  bool checkUserID(String user_id) => repository.checkUserID(user_id);

  Future<void> addParticipant(String user_id, String event_id, int status) async{
    await repository.addParticipant(user_id, event_id, status);
  }

  Future<String> findUserbyNickname(String nickname) async{
    return await repository.findUserbyNickname(nickname);
  }

  initFireBase() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    getFCMToken();
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _firebaseMessagingForegroundHandler(RemoteMessage message) async {
    if(message.data.containsKey("event_type")){
      String type = message.data["event_type"];
      if(type == "invite"){
        downloadRequests();
      }else if(type == "participant_status"){

      }
    }
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');

    }
  }

  //хуня изза отсутствия токенов
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.notification}");
}