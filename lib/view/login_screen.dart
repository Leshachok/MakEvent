import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:meeting/viewmodel/auth_view_model.dart';
import 'package:meeting/viewmodel/main_view_model.dart';
import 'package:provider/src/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  var email;
  LoginScreen(this.email, {Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState(email);
}

class LoginScreenState extends State<LoginScreen> {

  LoginScreenState(this.email);
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(36, 57, 132, 1),
                    Color.fromRGBO(170, 3, 35, 1),
                  ],
                )
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Увійти',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 32),
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                    height: 230,
                    width: 396,
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    child: Column(
                      children: [
                        Container(
                          height: 46,
                          padding: EdgeInsets.only(left: 12),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.0)
                              )
                          ),
                          child: TextFormField(
                            onChanged: (text){

                            },
                            initialValue: email,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              hintText: 'Введіть свій email',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(94, 98, 102, 1),
                              ),
                              counterText: '',
                            ),
                          ),
                        ),
                        Container(
                          height: 46,
                          padding: EdgeInsets.only(left: 12),
                          margin: const EdgeInsets.only(top: 16),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.0)
                              )
                          ),
                          child: TextFormField(
                            onChanged: (text){
                              password = text;
                            },
                            maxLines: 1,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Введіть пароль',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(94, 98, 102, 1),
                              ),
                              counterText: '',
                            ),
                          ),
                        ),
                        Container(
                          height: 46,
                          margin: const EdgeInsets.only(top: 16),
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(255, 23, 68, 1),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.0)
                              )
                          ),
                          child: TextButton(
                            onPressed: () async {
                              var message = await onLogin(email, password);
                              Fluttertoast.showToast(
                                msg: message,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                              );
                            },
                            child: const Center(
                              child: Text(
                                'Увійти',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  Future<String> onLogin(String email, String password) async{
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if(!emailValid) return "Введена пошта недійсна!";
    if(password.length < 8) return "Пароль має бути більше 7 символів!";

    var response = await viewModel.login(email, password);
    dynamic json = jsonDecode(response);
    print(json);
    if(json['message'] != null){
      return json['message'];
    } else authorize(json);
    return "Авторизовано!";
  }

  void authorize(dynamic json){
    viewModel.authorize(json, email);
    var vmodel = context.read<MainViewModel>();
    vmodel.getUsername();
    Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => MainScreen()), (r) => false
    );
  }

}
