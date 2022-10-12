import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }

  Future sendResetLink() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(context: context, builder: (context){
        return const AlertDialog(
          content: Text(
            'Your password reset link has been successfully sent to your email inbox',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
        );},
      );
      _emailController.clear();

    }on FirebaseAuthException catch (e){
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              content: Text(
                e.message.toString(),
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          },
      );
      _emailController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children:  [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 0,),
                child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                  iconSize: 38,
                  color: Colors.black54,
                )
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height *0.4,
            width: MediaQuery.of(context).size.width *0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Password reset link will be sent to your email.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 20,),
                  child: TextField(
                    controller: _emailController,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'email',
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                MaterialButton(
                  onPressed: sendResetLink,
                  color: const Color.fromRGBO(0, 88, 233, 0.85),
                  child: const Text(
                    'Request password reset link',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
