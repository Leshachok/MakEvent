import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:meeting_app/viewmodel/create_event_view_model.dart';
import 'package:meeting_app/viewmodel/main_view_model.dart';
import 'package:provider/provider.dart';
import 'package:meeting_app/data/event.dart';
import 'event_create_screen.dart';
import 'event_info_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({Key? key}) : super(key: key);

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 60),
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Row(
                  children: const [
                    Text(
                      ' Предстоящие встречи',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Consumer<MainViewModel>(
                      builder: (context, model, child){
                        return RefreshIndicator(
                          onRefresh: onRefreshList,
                          color: Color.fromRGBO(255, 23, 68, 1),
                          child: ListView.builder(
                              itemCount: model.getEvents().length,
                              itemBuilder: (context, position){
                                var event = model.getEvent(position);
                                return getRow(event);
                              }
                          ),
                        );
                      }
                  ),
                )
              ],
            )
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: getFloatingButton()
    );
  }

  Widget getFloatingButton() => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(35),
      boxShadow: const [
        BoxShadow(
          spreadRadius: 0.005,
          color: Colors.black,
          offset: Offset(0, 4),
          blurRadius: 5,
        )
      ],
    ),
    child: SizedBox(
      width: 70.0,
      height: 70.0,
      child: RawMaterialButton(
        shape: const CircleBorder(),
        elevation: 0.0,
        fillColor: Color.fromRGBO(198, 255, 0, 1),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: onFloatingButtonPressed,
      ),
    ),
  );


  Widget getRow(Event event) {
    var location = event.location;
    if(location.length > 30) location = location.substring(0, 29) + '..';
    timeDilation = 2.0;

    return GestureDetector(
      onTap: () async{
        var result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => EventInfoScreen(event)
            ));
        if(result == 'delete') onDeleteEvent(event.getId());
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Card(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                  child: Hero(
                    tag: "${event.getId()}",
                    child: Image.asset('lib/images/ski.jpg'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                          children:[
                            Text(
                              event.title,
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ]
                      ),
                      Row(
                          children:[
                            const Icon(
                              Icons.place_outlined,
                              size: 20,
                              color: Color.fromRGBO(0, 0, 0, 150),
                            ),
                            Text(
                              location,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(0, 0, 0, 150),
                              ),
                            ),
                          ]
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              event.date,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(0, 0, 0, 40),
                              ),
                            ),
                            // аватарки
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }

  void onFloatingButtonPressed() async{
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
            create: (BuildContext context) => CreateEventViewModel(),
            child: EventCreateScreen()
        )));
    if(result == 'create') {
      Fluttertoast.showToast(
        msg: "Зустріч створено!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      onRefreshList();
    }
  }

  Future<void> onRefreshList() async{
    MainViewModel viewModel = context.read<MainViewModel>();
    await viewModel.downloadEvents();
  }

  void onDeleteEvent(String event_id) async{
    var time = DateTime.now().microsecondsSinceEpoch;
    MainViewModel viewModel = context.read<MainViewModel>();
    await viewModel.deleteEvent(event_id);
    var after_time = DateTime.now().microsecondsSinceEpoch;
    print(after_time - time);
  }

}
