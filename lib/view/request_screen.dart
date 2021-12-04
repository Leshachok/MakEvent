import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meeting_app/data/event.dart';
import 'package:meeting_app/viewmodel/main_view_model.dart';
import 'package:provider/provider.dart';

import 'event_info_screen.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
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
                      ' Запрошення',
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
                          child: ListView.builder(
                              itemCount: model.getRequests().length,
                              itemBuilder: (context, position){
                                var event = model.getRequest(position);
                                return getRow(event);
                              }
                          ),
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
    if(location.length > 30) location = location.substring(0, 29) + '..';
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
                  child: Hero(
                    tag: event.getId(),
                      child: Image.asset('lib/images/ski.jpg')
                  )
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
                          width: 110,
                          child: TextButton(
                              onPressed: (){
                                onUpdateRequest(event.getId(), 2);
                              },
                              child: const Text(
                                'Погодитись',
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
                          width: 160,
                          padding: EdgeInsets.only(left: 40),
                          child: TextButton(
                              onPressed: (){
                                onUpdateRequest(event.getId(), 1);
                              },
                              child: const Text(
                                'Відмовитись',
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

  Future<void> onUpdateRequest(String event_id, int status) async{
    var before_time = DateTime.now().microsecondsSinceEpoch;
    var viewModel = context.read<MainViewModel>();
    await viewModel.updateRequest(event_id, status);
    var after_time = DateTime.now().microsecondsSinceEpoch;
    print(after_time - before_time);
  }

  Future<void> onRefreshList() async{
    MainViewModel viewModel = context.read<MainViewModel>();
    await viewModel.downloadRequests();
  }

}
