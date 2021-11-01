import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meeting_app/model/event.dart';
import 'package:meeting_app/viewmodel/main_view_model.dart';
import 'package:provider/provider.dart';

import 'event_info_screen.dart';

class InvitationsScreen extends StatefulWidget {
  const InvitationsScreen({Key? key}) : super(key: key);

  @override
  _InvitationsScreenState createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
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
                      ' Приглашения',
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
                            itemCount: model.getRequests().length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, position){
                              var event = model.getRequest(position);
                              return getRow(event);
                            }
                        );
                      }
                  ),
                )
              ],
            )
        )
    );
  }

  Widget getRow(Event event) {
    var location = event.location;
    if(location.length > 36) location = location.substring(0, 35) + '..';
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
                            location,
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
