import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qiu/reset.dart';

class SignInPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignInPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async{
    try{
      showDialog(context: context, builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
        },
      );
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }on FirebaseAuthException catch(e){
      Navigator.pop(context);
      _passwordController.clear();
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(
            e.message.toString(),
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        );
      });
    }

  }

  @override
  void dispose(){
    _passwordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Center(
                child:GestureDetector(
                  onTap: widget.showLoginPage,
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
          leading: const BackButton(
            color: Colors.black54,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
               Container(
                 height: MediaQuery.of(context).size.height * 0.25,
                 color: Colors.white,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Image.asset(
                           'assets/imageassets/qiu_logo.png',
                           scale: 1,
                           width: 60,
                           height: 60,
                         )
                       ],
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: const [
                         Text(
                           'Login',
                           style: TextStyle(
                             fontSize: 28,
                             fontWeight: FontWeight.w500,
                             color: Color.fromRGBO(0, 88, 233, 0.85),
                           ),
                         ),
                       ],
                     ),
                   ],
                 ),
               ),
              Container(
                height: MediaQuery.of(context).size.height * 0.625,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 88, 233, 0.85),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    )
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 25,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: _emailController,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // TODO: Confirm New password Text
                    const SizedBox(height: 15,),
                    // TODO: Confirm New password TextBox
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              prefixIcon: Icon(Icons.lock)
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    ElevatedButton(
                      onPressed: (){
                        signIn();
                      },
                      style: TextButton.styleFrom(
                          minimumSize: const Size(280, 45),
                          elevation: 6.0,
                          primary: Colors.white,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          )
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 45.0),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPasswordPage(),),);
                            },
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
