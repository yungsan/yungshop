import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nguyen_manh_dung/services/auth.services.dart';
import 'package:nguyen_manh_dung/widgets/button.dart';
import 'package:nguyen_manh_dung/widgets/text.dart';
import 'package:nguyen_manh_dung/customs/custom_icons.dart';
import 'package:nguyen_manh_dung/screens/sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<StatefulWidget> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final _auth = AuthService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _checked = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp(context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String fullName = _nameController.text.trim();
    if (fullName.isEmpty) {
      _showDialog('Please enter your name.');
    } else if (email.isEmpty) {
      _showDialog('Please enter your email.');
    } else if (!_isValidEmail(email)) {
      _showDialog('Invalid email.');
    } else if (password.isEmpty) {
      _showDialog('Please enter password.');
    }
    User? user =
        await _auth.signUpWithEmailAndPasswrod(email, password, fullName);
    if (user != null) {
      print('User is successfully created');
      Navigator.pushNamed(context, '/signIn');
    } else {
      print('Failed to created user');
    }
  }

  void _showDialog(String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: MyText(text: error, fs: 16, fw: FontWeight.normal),
          actions: [
            TextButton(
              child: const MyText(text: 'Try again', fs: 16),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MyText(text: 'Create Account', fs: 30),
              const Padding(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: MyText(
                  text:
                      "Fill your infomation below or register with your social account.",
                  center: true,
                  color: Colors.black38,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MyText(text: 'Name', top: 10, bottom: 10),
                    TextFormField(
                      controller: _nameController,
                      minLines: 1,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15.0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        hintText: 'John Cena',
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                    ),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: _checked,
                              onChanged: (bool? value) =>
                                  {setState(() => _checked = value!)}),
                          const Text(
                            'Agree with ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const Text(
                            'Terms & Condition',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: MyButton(
                    text: const MyText(
                      text: 'Sign Up',
                      color: Colors.white,
                      fs: 20,
                      fw: FontWeight.normal,
                    ),
                    background: Theme.of(context).colorScheme.primary,
                    onPressed: () => _signUp(context),
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
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignIn()));
                        },
                        child: const Text('Sign In',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2)),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
