import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meeting_app/model/event.dart';
import 'package:meeting_app/model/event_model.dart';
import 'package:meeting_app/screens/event_add_screen.dart';
import 'package:meeting_app/screens/event_info_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

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
                child: Consumer<EventModel>(
                    builder: (context, model, child){
                      return ListView.builder(
                          itemCount: model.getEvents().length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, position){
                            return getRow(model.getEvent(position));
                          }
                      );
                    }
                ),
              )
            ],
          )
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color.fromRGBO(255, 23, 68, 1),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
            child: Row(
              children:[
                IconButton(
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text('Введите данные'),
                            content: SizedBox(
                              height: 150,
                              child: Column(
                                children: [
                                  Text('Костючук Константин'),
                                  Divider(height: 40),
                                  Text('Вакцинированы?'),
                                  Switch(
                                    value: true,
                                    onChanged: (bool){},
                                  )
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: (){},
                                child: Text('Подтвердить'),
                              )
                            ],
                          );
                        }
                    );
                  },
                  icon: const Icon(
                      Icons.menu_outlined,
                      color: Color.fromRGBO(198, 255, 0, 1),
                      size: 32,
                  ),
                ),
              ]
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: DecoratedBox(
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
        )
      );
  }

  void onFloatingButtonPressed(){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => EventAddScreen()
    ));
  }

  Widget getRow(Event event) {

    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EventInfoScreen(event)
            ));
      },
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
                          event.location,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(0, 0, 0, 150),
                          ),
                        ),
                      ]
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
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
                  Row(
                    children: [
                      Container(
                        width: 102,
                        child: TextButton(
                            onPressed: (){},
                            child: const Text(
                              'Принять',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white
                              ),
                            )
                        ),
                        decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color.fromRGBO(255, 23, 68, 1)
                        ),
                      ),
                      Container(
                        width: 140,
                        padding: EdgeInsets.only(left: 40),
                        child: TextButton(
                            onPressed: (){},
                            child: const Text(
                              'Отклонить',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(255, 23, 68, 1)
                              ),
                            )
                        ),
                        decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.white
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }

}
