import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meeting_app/viewmodel/main_view_model.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  String username = "";
  String newUsername = "";


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Color.fromRGBO(255, 23, 68, 1),
          ),
          Container(
            margin: EdgeInsets.only(top: 180),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(48))
            ),
          ),
          Positioned(
            top: 100,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(80.0),
                  child: Image.asset(
                      'lib/images/avatar.jpg',
                    height: 160,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32),
                  width: 300,
                  child: Consumer<MainViewModel>(
                      builder: (context, model, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              model.username,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                            ),
                            GestureDetector(
                              onTap: onUsernameEdit,
                              child: Container(
                                margin: EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.edit,
                                  color: Color.fromRGBO(255, 23, 68, 1),
                                ),
                              ),
                            )
                          ],
                        );
                      }
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void onUsernameEdit(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Змінити ім`я'),
          contentPadding: EdgeInsets.only(top: 16, left: 24, right: 24),
          content: SizedBox(
              height: 80,
              child: Column(
                children: [
                  TextField(
                    maxLines: 1,
                    maxLength: 20,
                    onChanged: (text){
                      newUsername = text;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Введіть нове ім`я',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(94, 98, 102, 1),
                        ),
                        border: InputBorder.none,
                    )
                  )
                ],
              )
          ),
          actionsPadding: EdgeInsets.symmetric(vertical: 0),
          actions: [
            TextButton(
                onPressed: closeDialog,
                child: const Text('Відхилити')),
            TextButton(
                onPressed: onUsernameEditConfirmed,
                child: const Text('Підтвердити'))
          ],

        );

      },
    ).then((value){
    });
  }

  void onUsernameEditConfirmed() async{
    var viewModel = context.read<MainViewModel>();
    var response = await viewModel.updateNickname(newUsername);
    print(response);
    closeDialog();
    var json = jsonDecode(response);
    if(json['name'] != null){
      viewModel.setUsername(json['name']);
    }else{
      Fluttertoast.showToast(
        msg: "Помилка",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void closeDialog(){
    Navigator.pop(context, true);
  }

}
