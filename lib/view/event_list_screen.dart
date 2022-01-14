import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:meeting/viewmodel/create_event_view_model.dart';
import 'package:meeting/viewmodel/main_view_model.dart';
import 'package:provider/provider.dart';
import 'package:meeting/data/event.dart';
import 'event_create_screen.dart';
import 'event_info_screen.dart';

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    const Text(
                      ' Заплановані зустрічі',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    IconButton(
                      onPressed: onRefreshList,
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Consumer<MainViewModel>(
                      builder: (context, model, child){
                        Widget child = Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Нема запланованих зустрічей.',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18
                                ),
                              ),
                              Text(
                                'Спробуйте створити зустріч!',
                                style: TextStyle(
                                    color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                        );
                        if(model.getEvents().isNotEmpty){
                          child = ListView.builder(
                              itemCount: model.getEvents().length,
                              itemBuilder: (context, position){
                                var event = model.getEvent(position);
                                return getRow(event);
                              }
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: onRefreshList,
                          color: Color.fromRGBO(255, 23, 68, 1),
                          child: child
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
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.14),
          offset: Offset(0, 4),
          blurRadius: 5,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          offset: Offset(0, 1),
          blurRadius: 10,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.20),
          offset: Offset(0, 2),
          blurRadius: 4,
        ),
      ],
    ),
    child: SizedBox(
      width: 56.0,
      height: 56.0,
      child: RawMaterialButton(
        shape: const CircleBorder(),
        elevation: 0.0,
        fillColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Color.fromRGBO(255, 23, 68, 1),
        ),
        onPressed: onFloatingButtonPressed,
      ),
    ),
  );


  Widget getRow(Event event) {
    // var location = event.location;
    // if(location.length > 30) location = location.substring(0, 29) + '..';
    timeDilation = 2.0;

    return GestureDetector(
      onTap: () async{
        var result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                create: (BuildContext context) => CreateEventViewModel(),
                child: EventInfoScreen(event)
            )));
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
                      Container(
                        child: Row(
                            children:[
                              const Icon(
                                Icons.place_outlined,
                                size: 20,
                                color: Color.fromRGBO(0, 0, 0, 150),
                              ),
                              Flexible(
                                child: Text(
                                  event.location,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(0, 0, 0, 150),
                                  ),
                                ),
                              ),
                            ]
                        ),
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
      final snackBar = SnackBar(
        content: Text('Зустріч створено!'),
        action: SnackBarAction(
          label: 'Добре',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      onRefreshList();
    }
  }

  Future<void> onRefreshList() async{
    MainViewModel viewModel = context.read<MainViewModel>();
    await viewModel.downloadEvents();
  }

  void onDeleteEvent(String event_id) async{
    MainViewModel viewModel = context.read<MainViewModel>();
    await viewModel.deleteEvent(event_id);
    final snackBar = SnackBar(
      content: Text('Зустріч відмінено!'),
      action: SnackBarAction(
        label: 'Добре',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
