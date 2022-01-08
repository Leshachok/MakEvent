import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meeting/view/login_screen.dart';
import 'package:meeting/view/register_screen.dart';
import 'package:meeting/viewmodel/auth_view_model.dart';
  import 'package:provider/src/provider.dart';
  import 'package:fluttertoast/fluttertoast.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  var email = "";

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
                    'Ласкаво просимо!',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 32),
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                    height: 168,
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
                            child: TextField(
                              onChanged: (text){
                                email = text;
                              },
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
                            margin: const EdgeInsets.only(top: 16),
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(255, 23, 68, 1),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0)
                                )
                            ),
                            child: TextButton(
                              onPressed: checkEmail,
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

  checkEmail() async{
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    String? toast_message = "Введіть існуючу адресу електронної пошти";
    if(emailValid){
      var viewmodel = context.read<AuthViewModel>();
      var response = await viewmodel.findUserByEmail(email);
      var json = jsonDecode(response);
      var message = json['isFound'] ?? json['message'];
      if(message is bool){
        var screen = message ? LoginScreen(email) : RegisterScreen(email);
        toast_message = null;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => screen));
      }
    }
     Fluttertoast.showToast(
       msg: toast_message!,
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.BOTTOM,
     );
  }

}
