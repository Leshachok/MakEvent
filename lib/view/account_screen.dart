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
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  late BuildContext context;
  late MainViewModel mainViewModel;

  String username = "";
  String newUsername = "";

  @override
  Widget build(BuildContext context) {
    mainViewModel = context.read<MainViewModel>();
    this.context = context;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(242, 242, 242, 1),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16, right: 16),
                  child: IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Color.fromRGBO(255, 23, 68, 1),
                      size: 32,
                    ),
                    onPressed: showLogoutDialog,
                  ),
                ),
              ],
            ),
            SizedBox(height: 48,),
            ClipRRect(
              borderRadius: BorderRadius.circular(80.0),
              child: Image.asset(
                'lib/images/img.png',
                height: 160,
              ),
            ),
            SizedBox(height: 32,),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 24),
              child: Text(
                "Електрона пошта",
              ),
            ),
            SizedBox(height: 9,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Consumer<MainViewModel>(
                builder: (context, viewModel, child) =>
                Container(
                  height: 21,
                  child: TextFormField(
                    maxLines: 1,
                    readOnly: true,
                    initialValue: viewModel.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(31, 28, 29, 1),
                      fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      counterText: '',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 19,),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 24),
              child: Text(
                "Ім'я користувача",
                style: TextStyle(

                ),
              ),
            ),
            SizedBox(height: 9,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Consumer<MainViewModel>(
                builder: (context, viewModel, child) =>
                    Container(
                      height: 21,
                      child: TextFormField(
                        maxLines: 1,
                        initialValue: viewModel.username,
                        onChanged: (nickname){
                          viewModel.checkNewNickname(nickname);
                          newUsername = nickname;
                        },
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(31, 28, 29, 1),
                            fontWeight: FontWeight.w700
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                        ),
                      ),
                    ),
              ),
            ),
            Spacer(),
            Consumer<MainViewModel>(
              builder: (context, viewModel, child) =>
              Visibility(
                visible: viewModel.isNewNicknameDifferent,
                child: SizedBox(
                  width: 1600,
                  child: GestureDetector(
                    onTap: onUserDataEditConfirmed,
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 23, 68, 1),
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child: const Text(
                        "ЗАСТОСУВАТИ ЗМІНИ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
    mainViewModel.isNewNicknameDifferent = false;
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
    var viewModel = context.read<MainViewModel>();
    var response = await viewModel.updateUser(newUsername);
    var json = jsonDecode(response);
    if(json['name'] != null){
      viewModel.setUsername(json['name']);
      viewModel.isNewNicknameDifferent = false;
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
