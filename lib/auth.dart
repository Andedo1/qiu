import 'package:flutter/material.dart';
import 'package:qiu/sign_up.dart';
import 'package:qiu/login.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool showLoginPage = false;

  void toggleScreen(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return SingUpPage(showLoginPage: toggleScreen);
    }else {
      return SignInPage(showLoginPage: toggleScreen);
    }
  }
}
