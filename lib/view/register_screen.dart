import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meeting/viewmodel/auth_view_model.dart';
import 'package:meeting/viewmodel/main_view_model.dart';
import 'package:provider/src/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  var email;
  RegisterScreen(this.email, {Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState(email);
}

class _RegisterScreenState extends State<RegisterScreen> {

  var email = "";
  var password = "";
  var confirmPassword = "";
  _RegisterScreenState(this.email);


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
                    'Створити акаунт',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 32),
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                    height: 292,
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
                            initialValue: email
                            ,
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
                              confirmPassword = text;
                            },
                            maxLines: 1,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Підтвердіть пароль',
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
                              var message = await onRegister(email, password);
                              Fluttertoast.showToast(
                                msg: message,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                            child: const Center(
                              child: Text(
                                'Зареєструватись',
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

  Future<String> onRegister(String email, String password) async{
    var viewModel = context.read<AuthViewModel>();
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if(!emailValid) return "Введена пошта недійсна!";
    if(password != confirmPassword) return "Паролі не співпадають";
    if(password.length < 8) return "Пароль має бути більше 7 символів!";

    var response = await viewModel.register(email, password);
    dynamic json;
    json = jsonDecode(response);
    print(json);

    if(json['message'] != null){
      return json['message'];
    } else authorize(json);
    return "Авторизовано!";
  }

  void authorize(dynamic json){
    var viewModel = context.read<AuthViewModel>();
    viewModel.authorize(json);
    var vmodel = context.read<MainViewModel>();
    vmodel.getUsername();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainScreen())
    );
  }

}
