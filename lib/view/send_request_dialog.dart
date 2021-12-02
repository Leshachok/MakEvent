import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meeting_app/data/user.dart';
import 'package:meeting_app/viewmodel/create_event_view_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SendRequestDialog extends StatefulWidget {

  late CreateEventViewModel model;
  SendRequestDialog(this.model, {Key? key}) : super(key: key);

  @override
  _SendRequestDialogState createState() => _SendRequestDialogState(model);
}

class _SendRequestDialogState extends State<SendRequestDialog> {

  late CreateEventViewModel model;
  _SendRequestDialogState(this.model);

  String nickname = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (text){
            nickname = text;
          },
          maxLength: 20,
          decoration: InputDecoration(
              hintText: 'Введіть нікнейм друга',
              hintStyle: const TextStyle(
                color: Color.fromRGBO(94, 98, 102, 1),
              ),
              counterText: '',
              border: InputBorder.none,
            suffixIcon: GestureDetector(
              onTap: (){
                findUserbyNickname(nickname);
              },
              child: Icon(
                Icons.add
              ),
            )
          ),
        ),
        SafeArea(
          child: Container(
            height: 200,
            width: 240,
            child: ListView.builder(
                  itemCount: model.users.length,
                  itemBuilder: (context, position){
                    var user = model.getUser(position);
                    return getRow(user);
                  }),
          ),
        )
      ],
    );
  }

  Widget getRow(User user){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
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
                      user.name,
                      style: const TextStyle(
                          fontSize: 18
                      ),
                    ),
                  )
                ],
              ),
            )
          ]
      ),
    );
  }

  Future<void> findUserbyNickname(String nickname) async{
    var message = "";
    if(model.users.where((element) => element.name == nickname).isNotEmpty){
      message = "Користувач вже запрошений!";
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    var response = model.findUserbyNickname(nickname);
    dynamic json = "";
    User user;
    response.then((value) => {
      json = jsonDecode(value),
      if(json['message'] != null){
        message = json['message'],
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        )
      }else{
        user = User.fromJsonAsUser(json),
        this.nickname = "",
        model.addUser(user),
        setState(() { }),
      }
    });


  }

}
