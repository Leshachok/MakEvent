import 'package:flutter/material.dart';
import 'package:meeting_app/data/event.dart';
import 'package:meeting_app/data/participant.dart';
import 'package:meeting_app/data/user.dart';
import 'package:meeting_app/view/send_request_dialog.dart';
import 'package:meeting_app/viewmodel/create_event_view_model.dart';
import 'package:meeting_app/viewmodel/main_view_model.dart';
import 'package:provider/src/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EventInfoScreen extends StatefulWidget {

  late Event _event;

  EventInfoScreen(this._event);

  @override
  _EventInfoScreenState createState() => _EventInfoScreenState(_event);
}

class _EventInfoScreenState extends State<EventInfoScreen> {

  List<Participant> participants = [];
  late Event _event;
  late MainViewModel viewModel;
  late CreateEventViewModel createEventViewModel;
  bool isDeleteButtonVisible = false;
  String recommendation = "";
  Color recommendationColor = Color.fromARGB(150, 0, 0, 0);
  _EventInfoScreenState(this._event);
  List<User> oldusers = [];

  @override
  void initState(){
    super.initState();
    viewModel = context.read<MainViewModel>();
    createEventViewModel = context.read<CreateEventViewModel>();
    getParticipants();
  }

  Future<void> getParticipants() async{
    participants = await viewModel.getParticipants(_event.getId());

    List<User> users = participants.map((e) => e.user).cast<User>().toList();
    createEventViewModel.users = users;
    oldusers.clear();
    oldusers.addAll(users);
    participants.forEach((element) {
      if(element.status == 3 && viewModel.checkUserID(element.user.getId())){
        isDeleteButtonVisible = true;
      }
    });
    await getRecommendation();
    setState(() {

    });
  }

  Future<void> getRecommendation() async{
    bool allVaccinated = !participants.where((element) => element.status == 2 || element.status == 3).map((e) => e.user.vaccination).contains("Не вакцинований");
    if(_event.isOutdoor && allVaccinated) {
      recommendation = "Безпечно! Схоже, що всі учасники вакциновані, а зустріч відбудеться на свіжому повітрі";
      recommendationColor = const Color.fromARGB(150, 0, 255, 0);
    } else if(_event.isOutdoor) {
      recommendation = "Майже безпечно! Не всі учасники вакциновані, але зустріч відбудеться на свіжому повітрі.";
      recommendationColor = const Color.fromARGB(150, 255, 255, 0);
    } else if(allVaccinated) {
      recommendation = "Всі учасники вакциновані, але не забувайте про засоби особистої безпеки, адже зустріч буде у замкнутому просторі.";
      recommendationColor = const Color.fromARGB(150, 255, 165, 0);
    } else {
      recommendation = "Небезпечно! Не всі вакциновані, а зустріч буде у замкнутому просторі.";
      recommendationColor = const Color.fromARGB(150, 255, 0, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children:[
            Stack(
                children:[
                  Hero(
                    tag: _event.getId(),
                    child: Image.asset('lib/images/ski.jpg')
                  ),
                  Positioned(
                    top: 50,
                    left: 16,
                    child: ElevatedButton(
                      onPressed: onBackButtonPressed,
                      child: const Icon(Icons.arrow_back_rounded),
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          fixedSize: Size(50, 50),
                          primary: const Color.fromARGB(150, 0, 0, 0)
                      ),
                    ),
                  ),
                  Positioned(
                    top: 116,
                    left: 16,
                    child: ElevatedButton(
                      onPressed: onRecommendationPressed,
                      child: const Icon(Icons.coronavirus),
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          fixedSize: Size(50, 50),
                          primary: recommendationColor
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isDeleteButtonVisible,
                    child: Positioned(
                        top: 48,
                        right: 16,
                        child: ElevatedButton(
                          onPressed: onDeleteButtonPressed,
                          child: const Icon(Icons.restore_from_trash),
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              fixedSize: Size(50, 50),
                              primary: const Color.fromARGB(150, 0, 0, 0)
                          ),
                        ),
                    ),
                  )
                ]
            ),
            Container(
              margin: const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 10),
              child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          _event.title,
                          style: const TextStyle(
                              fontSize: 30
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          _event.description,
                          maxLines: 3,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.grey
                          ),
                        ),
                      )
                    ],
                  )
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 20,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        _event.date,
                        style: const TextStyle(
                            fontSize: 18
                        ),
                      )
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.place,
                    color: Color.fromRGBO(255, 23, 68, 1),
                    size: 20,
                  ),
                  Flexible(
                    child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        child:  Text(
                          _event.location,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 18
                          ),
                        )
                    ),
                  ),
                  IconButton(
                      onPressed: onCreateRoute,
                      icon: const Icon(
                        Icons.subdirectory_arrow_right,
                        color: Color.fromRGBO(255, 23, 68, 1),
                        size: 32,
                      )
                  )

                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),

              child: const Divider(
                height: 10,
                thickness: 0.8,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.people,
                        size: 20,
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text(
                            'Учасники',
                            style: TextStyle(
                                fontSize: 18
                            ),
                          )
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: onAddFriendClicked,
                    child: Container(
                      width: 70,
                      height: 20,
                      child: Text('Додати',
                          style: TextStyle(
                              fontSize: 18,
                            color: Color.fromRGBO(255, 23, 68, 1)
                          ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: participants.length,
                    itemBuilder: (BuildContext context, int position){
                      return getRow(position);
                      },
                    physics: BouncingScrollPhysics(),
                  ),
                ),
              ),

            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color.fromRGBO(255, 23, 68, 1),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: TextButton(
              onPressed: (){},
              style: const ButtonStyle(
                  splashFactory: NoSplash.splashFactory
              ),
              child: const Text(
                '',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget getRow(int position) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Container(
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Icon(
                    Icons.camera_alt,
                    size: 25,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      participants[position].user.name,
                      style: const TextStyle(
                          fontSize: 18
                      ),
                    ),
                  )
                ],
              ),
            ),
            getStatus(position)
          ]
      ),
    );
  }

  void onDeleteButtonPressed() => {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Вы дійсно хочете відмінити зустріч?'),
            content: null,
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Ні'),
              ),
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context, 'delete');
                },
                child: Text('Так'),
              )
            ],
          );
        })
  };

  void onCreateRoute() async{
    var url = 'https://www.google.com/maps?f=d&daddr=${_event.latitude.toString()},${_event.longitude.toString()}&dirflg=d';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void onBackButtonPressed() => Navigator.pop(context, 'close');

  onRecommendationPressed(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Covid-безпечність'),
            content: Text(
              recommendation
            ),
          );
        });
  }

  Widget getStatus(int pos){
    Color textColor = participants[pos].status == 0 ? Colors.grey :  participants[pos].status == 1 ? Color.fromRGBO(255, 23, 68, 1) : participants[pos].status == 2 ? Colors.green : Colors.blue;
    Color backColor = textColor.withAlpha(50);
    String text = participants[pos].status == 0 ? "Не вирішив" : participants[pos].status == 1 ? "Відмовився" : participants[pos].status == 2 ? "Погодився" : "Організатор";

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: backColor
      ),
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 4),
      child: Text(
        text,
        style: TextStyle(
            color: textColor,
            fontSize: 18
        ),
      ),
    );
  }

  void onAddFriendClicked(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Додати друзів'),
          contentPadding: EdgeInsets.only(top: 16, left: 24, right: 24),
          content: SizedBox(
              height: 360,
              child: SendRequestDialog(createEventViewModel)
          ),
          actionsPadding: EdgeInsets.symmetric(vertical: 0),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context, "ok");
                },
                child: Text('Підтвердити'))
          ],

        );

      },
    ).then((value) async {
      if(value == "ok"){
        var users = createEventViewModel.users;
        await checkNewUsers(users);
        getParticipants();
      }
    });
  }

  checkNewUsers(List<User> list) async{
    list.forEach((user) async {
      if(!oldusers.contains(user)){
        await createEventViewModel.addParticipant(user.getId(), _event.getId(), 0);
      }
    });
  }

}