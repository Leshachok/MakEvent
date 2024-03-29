import 'package:flutter/material.dart';
import 'package:meeting_app/view/send_request_dialog.dart';
import 'package:meeting_app/viewmodel/create_event_view_model.dart';
import 'package:meeting_app/data/event.dart';
import 'package:meeting_app/view/map_dialog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventCreateScreen extends StatefulWidget {
  EventCreateScreen();

  @override
  _EventCreateScreenState createState() => _EventCreateScreenState();

}

class _EventCreateScreenState extends State<EventCreateScreen> {

  late CreateEventViewModel viewModel;
  bool isCreateButtonVisible = true;

  _EventCreateScreenState();

  //потом нахуй все в вьюмодел
  String title = "";
  String description = "";
  String date = "";
  String time = "";
  String location = "";


  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    date = formatted;
    viewModel = context.read<CreateEventViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children:[
                Column(
                  children: [
                    Container(
                      height: 72,
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        onChanged: (text){
                          title = text;
                        },
                        maxLength: 20,
                        decoration: InputDecoration(
                            hintText: 'Назва зустрічі',
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(94, 98, 102, 1),
                            ),
                            counterText: '',
                            border: InputBorder.none,
                            icon: GestureDetector(
                              child: const Icon(
                                Icons.close,
                                color: Color.fromRGBO(94, 98, 102, 1),
                                size: 44,
                              ),
                              onTap: onBackButtonPressed,
                            )
                        ),
                      )
                    ),
                    Divider(
                      height: 1,
                    ),
                    Container(
                      height: 72,
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          onChanged: (text){
                            description = text;
                          },
                          maxLines: 1,
                          maxLength: 66,
                          decoration: InputDecoration(
                              hintText: 'Опис',
                              hintStyle: const TextStyle(
                                color: Color.fromRGBO(94, 98, 102, 1),
                              ),
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 12),
                              icon: GestureDetector(
                                child: const Icon(
                                  Icons.message_rounded,
                                  color: Color.fromRGBO(94, 98, 102, 1),
                                  size: 24,
                                ),
                                onTap: onBackButtonPressed,
                              )
                          ),
                        )
                    ),
                    Divider(
                      height: 1,
                    ),
                    GestureDetector(
                      onTap: onDateChoosingClicked,
                      child: Container(
                          height: 72,
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Color.fromRGBO(94, 98, 102, 1),
                                size: 24,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 28),
                                child: Text(
                                  date,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(94, 98, 102, 1),
                                      fontSize: 16
                                  ),
                                ),
                              )
                            ],
                          ),
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    GestureDetector(
                      onTap: onTimeChoosingClicked,
                      child: Container(
                        height: 72,
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Color.fromRGBO(94, 98, 102, 1),
                              size: 24,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 28),
                              child: Text(
                                time.isNotEmpty ? time : "Обрати час",
                                style: const TextStyle(
                                    color: Color.fromRGBO(94, 98, 102, 1),
                                    fontSize: 16
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    GestureDetector(
                      onTap: onPlaceChoosingClicked,
                      child: Container(
                          height: 72,
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.place,
                                color: Color.fromRGBO(94, 98, 102, 1),
                                size: 24),
                              Container(
                                padding: const EdgeInsets.only(left: 28),
                                child: Consumer<CreateEventViewModel>(
                                  builder: (context, value, child){
                                    location = value.location;
                                    var loc = location;
                                    if(loc.length > 36) loc = location.substring(0, 35) + '..';
                                    return Text(
                                      loc,
                                      style: const TextStyle(
                                          color: Color.fromRGBO(94, 98, 102, 1),
                                          fontSize: 16
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    Container(
                      height: 72,
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.photo,
                            color: Color.fromRGBO(94, 98, 102, 1),
                            size: 24,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 28),
                            child: const Text(
                              'Обрати фото (недоступно)',
                              style: TextStyle(
                                  color: Color.fromRGBO(94, 98, 102, 1),
                                  fontSize: 16
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onAddFriendClicked,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 32, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          child: RawMaterialButton(
                            shape: const CircleBorder(),
                            elevation: 0.0,
                            fillColor: const Color.fromRGBO(255, 32, 75, 230),
                            child: const Icon(
                              Icons.add,
                              size: 32,
                              color: Color.fromRGBO(255, 23, 68, 1),
                            ),
                            onPressed: onAddFriendClicked,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            child: const Text(
                              'ЗАПРОСИТИ ДРУЗІВ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(255, 32, 75, 25),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: Visibility(
          visible: isCreateButtonVisible,
          child: Container(
            margin: const EdgeInsets.all(16),
            width: 320,
              child: TextButton(
                  onPressed: onCreateButtonPressed,
                  child: const Text(
                      'Створити зустріч',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                    ),
                  )
            ),
            decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: Color.fromRGBO(255, 23, 68, 1)
            ),
          ),
        )
    );
  }

  void onDateChoosingClicked() async{
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if(picked!=null){
      picked = DateTime(picked.year, picked.month, picked.day);
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      String formatted = formatter.format(picked);
      if(date!= formatted) setState(() { date = formatted; });
    }
  }

  void onTimeChoosingClicked() async{
    showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 0, minute: 0)
    ).then((value) => {
      setState(() {
        if(value == null) return;
        final String hourLabel = _addLeadingZeroIfNeeded(value.hour);
        final String minuteLabel = _addLeadingZeroIfNeeded(value.minute);
        time = '$hourLabel:$minuteLabel';
      })
    });
  }

  String _addLeadingZeroIfNeeded(int value) {
    return (value < 10) ? '0$value' : value.toString();
  }

  void onBackButtonPressed() => Navigator.pop(context, 'cancel');

  void onCreateButtonPressed() async{
    CreateEventViewModel model = context.read<CreateEventViewModel>();
    if(!(title.isNotEmpty && description.isNotEmpty && date.isNotEmpty && location.isNotEmpty && model.latitude != 0.0)) {
      Fluttertoast.showToast(
          msg: "Заповніть всі поля!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
      );
    }else{
      isCreateButtonVisible = false;
      setState(() {

      });
      Event newEvent = Event(title, description, date + ' ' + time, location, model.latitude, model.longitude, model.isOutdoor);
      // var model = context.read<MainViewModel>();
      await model.createEvent(newEvent);
      Navigator.pop(context, 'create');
    }
  }


  void onPlaceChoosingClicked() {
    showDialog(
        context: context,
        builder: (context){
              return AlertDialog(
                title: const Text('Обрати місце зустрічі'),
                contentPadding: EdgeInsets.only(top: 16, left: 24, right: 24),
                content: SizedBox(
                    height: 360,
                    child: GoogleMapDialog(viewModel)
                ),
                actionsPadding: EdgeInsets.symmetric(vertical: 0),
                actions: [
                  TextButton(
                      onPressed: closeDialog,
                      child: Text('Підтвердити'))
                ],

              );

        },
    ).then((value){
      //getAdressByCoords(model.location);
    });
  }

  void closeDialog(){
    Navigator.pop(context, true);
  }

  void onAddFriendClicked() {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Додати друзів'),
          contentPadding: EdgeInsets.only(top: 16, left: 24, right: 24),
          content: SizedBox(
              height: 360,
              child: SendRequestDialog(viewModel)
          ),
          actionsPadding: EdgeInsets.symmetric(vertical: 0),
          actions: [
            TextButton(
                onPressed: closeDialog,
                child: Text('Підтвердити'))
          ],

        );

      },
    ).then((value){
    });
  }

}