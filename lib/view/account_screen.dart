import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meeting_app/view/welcome_screen.dart';
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
  String vaccination = "";
  String newUsername = "";
  String newVaccination = "";


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
                      'lib/images/avatar.jpg',
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
                                    onPressed: onUsernameEdit,
                                  ),
                                )
                              ],
                            ),
                            Container(
                              child: Text(model.vaccination),
                              margin: EdgeInsets.only(top: 16),
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

  void onUsernameEdit(){
    showDialog(
      context: context,
      builder: (context){

        return Consumer<MainViewModel>(
          builder: (context, model, child) {
            var value = model.vaccinationSwitch;
            return AlertDialog(
              title: const Text('Змінити дані'),
              contentPadding: EdgeInsets.only(top: 16, left: 24, right: 24),
              content: SizedBox(
                height: 120,
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Вакцинація:'),
                          Switch(value: value, onChanged: (isvacc){
                            newVaccination = isvacc ? "Вакцинований" : "Не вакцинований";
                            model.setVaccinationSwitch(isvacc);
                          }),
                        ],
                      ),
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
        );

      },
    ).then((value){
      if(value == null){
        var viewModel = context.read<MainViewModel>();
        viewModel.vaccinationSwitch = viewModel.isVaccinated;
      }
    });
  }

  void onUsernameEditConfirmed() async{
    if(newUsername.length < 6 && newVaccination.isEmpty){
      Fluttertoast.showToast(
        msg: "Довжина нікнейму повинна бути 6 або більше символів!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    closeDialog();
    var viewModel = context.read<MainViewModel>();
    var response = await viewModel.updateUser(newUsername, newVaccination);
    print(response);
    var json = jsonDecode(response);
    if(json['name'] != null){
      viewModel.setUsername(json['name']);
      viewModel.setVaccination(json['vaccination']);
      newVaccination = "";
      newUsername = "";
    }else{
      Fluttertoast.showToast(
        msg: json['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void closeDialog(){
    Navigator.pop(context, true);
  }

  showLogoutDialog(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text('Ви дійсно хочете вийти з акаунту?'),
        contentPadding: EdgeInsets.only(top: 16, left: 24, right: 24),
        actionsPadding: EdgeInsets.symmetric(vertical: 0),
        actions: [
          TextButton(
              onPressed: closeDialog,
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
