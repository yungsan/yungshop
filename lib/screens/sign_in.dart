import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nguyen_manh_dung/services/auth.services.dart';
import 'package:nguyen_manh_dung/widgets/button.dart';
import 'package:nguyen_manh_dung/widgets/text.dart';
import 'package:nguyen_manh_dung/customs/custom_icons.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _auth = AuthService();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  Future<void> signIn(context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    User? user = await _auth.signInWithEmailAndPasswrod(email, password);
    if (user != null) {
      Navigator.pushNamed(context, '/');
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: const MyText(
              text: 'Please check your email and password again.',
              fs: 16,
              fw: FontWeight.normal,
            ),
            actions: [
              TextButton(
                child: const MyText(
                  text: 'Try again',
                  fs: 16,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
      print('Can\'t Login. Try again.');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MyText(text: 'Sign In', fs: 30),
              const MyText(
                text: "Hi! Welcome back, you've been missed",
                color: Colors.black38,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MyText(text: 'Email', top: 10, bottom: 10),
                    TextFormField(
                      controller: _emailController,
                      minLines: 1,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15.0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        hintText: 'example@gmail.com',
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                    ),
                    const MyText(text: 'Password', top: 10, bottom: 10),
                    TextFormField(
                      controller: _passwordController,
                      minLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15.0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        hintText: '****************',
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: MyButton(
                    text: const MyText(
                      text: 'Sign In',
                      color: Colors.white,
                      fs: 20,
                      fw: FontWeight.normal,
                    ),
                    background: Theme.of(context).colorScheme.primary,
                    onPressed: () => signIn(context),
                  ),
                ),
              ),
              const Row(children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 15),
                  child: Divider(),
                )),
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: MyText(text: "Or sign in with"),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 40),
                  child: Divider(),
                )),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.apple),
                      iconSize: 50,
                      color: Colors.white,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Custom.google),
                      iconSize: 50,
                      color: Colors.red,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Custom.twitter),
                      iconSize: 50,
                      color: Colors.white,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue.shade900),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Dont't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signUp');
                        },
                        child: const Text('Sign Up',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2)),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}
