import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meeting_app/viewmodel/create_event_view_model.dart';
import 'package:meeting_app/viewmodel/main_view_model.dart';
import 'package:provider/provider.dart';
import 'package:meeting_app/model/event.dart';
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
                        return ListView.builder(
                            itemCount: model.getEvents().length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, position){
                              var event = model.getEvent(position);
                              return getRow(event);
                            }
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
    if(location.length > 36) location = location.substring(0, 35) + '..';
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EventInfoScreen(event)
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Card(
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                    child: Image.asset('lib/images/ski.jpg')
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

  void onFloatingButtonPressed(){
    MainViewModel viewModel = context.read<MainViewModel>();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
            create: (BuildContext context) => CreateEventViewModel(),
            child: EventCreateScreen(viewModel)
        )
        ));
  }

}
