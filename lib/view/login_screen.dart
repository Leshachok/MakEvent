import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:meeting_app/viewmodel/auth_view_model.dart';
import 'package:provider/src/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
              onTap: onLogin,
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
              onTap: onRegister,
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

  void onRegister(){
    var response = viewModel.register(email, password);
    dynamic json;
    String message = "";

    response.then((value) => {
      json = jsonDecode(value),
      message = json['message'] != null ? json['message'] : "Акаунт створено",
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      )
    });

    // Navigator.pushReplacement(
    //   context, MaterialPageRoute(builder: (context) => MainScreen())
    // );
  }

  void onLogin(){
    var response = viewModel.login(email, password);
    dynamic json;

    response.then((value) => {
      json = jsonDecode(value),
      if(json['message'] != null){
        Fluttertoast.showToast(
          msg: json['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        )
      } else authorize(json)
    });


  }

  void authorize(dynamic json) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    viewModel.authorize(prefs, json);
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => MainScreen())
    );
  }

}
