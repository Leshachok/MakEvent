import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:meeting_app/viewmodel/auth_view_model.dart';
import 'package:provider/src/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  late AuthViewModel viewModel;
  String email = "";
  String password = "";

  @override
  void initState(){
    super.initState();
    viewModel = context.read<AuthViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 56, vertical: 150),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Center(
              child: Text(
                  "Авторизація",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40),
              // ignore: prefer_const_constructors
              child: TextField(
                onChanged: (text) => email = text,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Введіть пошту",
                  suffixIcon: Icon(
                    Icons.mail,
                    color: Color.fromARGB(127, 0, 0, 0),
                  )
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              // ignore: prefer_const_constructors
              child: TextField(
                onChanged: (text) => password = text,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),

                    hintText: "Введіть пароль",
                    suffixIcon: Icon(
                      Icons.lock,
                      color: Color.fromARGB(127, 0, 0, 0),
                    )
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                var message = await onLogin(email, password);
                Fluttertoast.showToast(
                  msg: message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
              },
              child: Container(
                margin: const EdgeInsets.only(top: 32),
                height: 46,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 23, 68, 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0)
                    )
                ),
                child: const Center(
                  child: Text(
                    'Увійти',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                var message = await onRegister(email, password);
                Fluttertoast.showToast(
                  msg: message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
              },
              child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(4.0)
                    ),
                    border: Border.all(
                        color: const Color.fromRGBO(255, 23, 68, 1)
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Створити акаунт',
                      style: TextStyle(
                          color: Color.fromRGBO(255, 23, 68, 1)
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

  Future<String> onRegister(String email, String password) async{
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if(!emailValid) return "Введена пошта недійсна!";
    if(password.length < 8) return "Пароль має бути більше 7 символів!";

    var response = await viewModel.register(email, password);
    dynamic json;
    String message = "";

    json = jsonDecode(response);
    message = json['message'] != null ? json['message'] : "Акаунт створено";
    return message;
    // Navigator.pushReplacement(
    //   context, MaterialPageRoute(builder: (context) => MainScreen())
    // );
  }

  Future<String> onLogin(String email, String password) async{
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if(!emailValid) return "Введена пошта недійсна!";
    if(password.length < 8) return "Пароль має бути більше 7 символів!";

    var response = await viewModel.login(email, password);
    dynamic json = jsonDecode(response);
    if(json['message'] != null){
      return json['message'];
    } else authorize(json);
    return "Авторизовано!";
  }

  void authorize(dynamic json){
    viewModel.authorize(json);
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => MainScreen())
    );
  }

}
