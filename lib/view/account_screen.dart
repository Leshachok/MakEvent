import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meeting/view/welcome_screen.dart';
import 'package:meeting/viewmodel/main_view_model.dart';
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
            color: const Color.fromRGBO(255, 23, 68, 1),
          ),
          Container(
            margin: const EdgeInsets.only(top: 180),
            decoration: const BoxDecoration(
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
                      'lib/images/img.png',
                    height: 160,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16, left: 32, right: 32),
                  width: 300,
                  child: Consumer<MainViewModel>(
                      builder: (context, model, child) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding:  EdgeInsets.only(left: 16),
                                  child: Text(
                                    model.username,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  child: TextButton(
                                    child: const Icon(
                                      Icons.edit,
                                      color: Color.fromRGBO(255, 23, 68, 1),
                                    ),
                                    onPressed: onUserDataEdit,
                                  ),
                                )
                              ],
                            )
                          ],
                        );
                      }
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 32,
            right: 16,
            child: IconButton(
              icon: const Icon(
                  Icons.logout,
                color: Colors.white,
                size: 32,
              ),
              onPressed: showLogoutDialog,
            )
          )
        ],
      ),
    );
  }

  void onUserDataEdit(){
    showDialog(
      context: context,
      builder: (context) => Consumer<MainViewModel>(
          builder: (context, model, child) {
            return AlertDialog(
              title: const Text('Змінити дані'),
              contentPadding: EdgeInsets.only(top: 16, left: 24, right: 24),
              content: SizedBox(
                height: 180,
                  child: Column(
                    children: [
                      TextField(
                          maxLines: 1,
                          maxLength: 20,
                          onChanged: (text){
                            newUsername = text;
                          },
                          decoration: const InputDecoration(
                            hintText: "Новий нікнейм",
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(94, 98, 102, 1),
                            ),
                            border: InputBorder.none,
                          )
                      ),
                    ],
                  )
              ),
              actionsPadding: EdgeInsets.symmetric(vertical: 0),
              actions: [
                TextButton(
                    onPressed: () => closeDialog(false),
                    child: const Text('Відхилити')),
                TextButton(
                    onPressed: onUserDataEditConfirmed,
                    child: const Text('Підтвердити'))
              ],

            );
          },
        )
    ).then((value){
      if(value == true){
        final snackBar = SnackBar(
          content: Text('Інформацію змінено!'),
          action: SnackBarAction(
            label: 'Добре',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  void onUserDataEditConfirmed() async{
    if(newUsername.length < 6){
      Fluttertoast.showToast(
        msg: "Довжина нікнейму повинна бути 6 або більше символів!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    closeDialog(true);
    var viewModel = context.read<MainViewModel>();
    var response = await viewModel.updateUser(newUsername);
    print(response);
    var json = jsonDecode(response);
    if(json['name'] != null){
      viewModel.setUsername(json['name']);
      newUsername = "";
    }else{
      Fluttertoast.showToast(
        msg: json['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void closeDialog(bool value){
    Navigator.pop(context, value);
  }

  showLogoutDialog(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text('Ви дійсно хочете вийти з акаунту?'),
        contentPadding: EdgeInsets.only(top: 16, left: 24, right: 24),
        actionsPadding: EdgeInsets.symmetric(vertical: 0),
        actions: [
          TextButton(
              onPressed: () => closeDialog(false),
              child: const Text('Ні')),
          TextButton(
              onPressed: onLogout,
              child: const Text('Так'))
        ],
      );

    });
  }

  void onLogout(){
    var viewModel = context.read<MainViewModel>();
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => const WelcomeScreen()),
      (r)=>false,
    );
    viewModel.logout();
  }

}
