
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ThirdPage extends StatefulWidget {
  String value;
  ThirdPage({Key? key, required this.value}): super(key: key);

  @override
  State<ThirdPage> createState() => _ThirdPageState(value);
}

class _ThirdPageState extends State<ThirdPage> {
  String value;
  _ThirdPageState(this.value);
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future signIn() async{
    // show dialog

    showDialog(
        context: context,
        builder: (context)
        {
          return const CircularProgressIndicator();
        },
    );
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: value,
      password: _passwordController.text.trim(),
    );

    Navigator.of(context).pop();

  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 20,
                      child: Center(
                        child: Image.asset(
                          'assets/qiu_logo.png',
                          height: 60,
                          width: 60,
                          scale: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 10,
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        iconSize: 32,
                        icon: const Icon(Icons.arrow_back),
                        color: const Color.fromRGBO(0, 88, 233, 1),
                      ),
                    ),
                    const Positioned(
                      bottom: 20,
                      left: 30,
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 88, 233, 1),
                        ),
                      ),
                    )
                  ],
                )
            ),
            Expanded(
              flex: 6,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 88, 233, 1),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    )
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 25,),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 58),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Enter new password',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter new password',
                            ),
                          ),
                        ),
                      ),
                    ),

                    // TODO: Confirm New password Text
                    const SizedBox(height: 15,),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 58),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Confirm new password',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    // TODO: Confirm New password TextBox
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirm new password',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 58),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Your password must be more than 8 characters and should include numbers, uppercase and lowercase characters',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 90,),
                    ElevatedButton(
                      onPressed: (){
                        signIn();
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                          minimumSize: const Size(280, 45),
                          elevation: 6.0,
                          primary: Colors.white,
                          backgroundColor: Colors.green,
                          //padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          )
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
