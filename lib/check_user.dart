import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qiu/auth.dart';

import 'package:qiu/home_page.dart';

class CheckUser extends StatelessWidget {
  const CheckUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder <User?> (
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if (!snapshot.hasData) {
            return  const AuthenticationPage();
          }else{
            return const HomePage();
          }
        },
      ),
    );
  }
}
