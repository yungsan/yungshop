import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nguyen_manh_dung/models/user.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  final _fs = FirebaseFirestore.instance;

  final Map<int, String> _route = {
    0: '/',
    1: '/',
    2: '/',
    3: '/',
    4: '/',
    5: '/',
    6: '/',
    7: '/signIn',
  };

  Future<User?> signUpWithEmailAndPasswrod(
      String emailInput, String passwordInput, String fullName) async {
    if (emailInput.isEmpty || passwordInput.isEmpty || fullName.isEmpty) {
      return null;
    }
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: emailInput.trim(),
        password: passwordInput.trim(),
      );

      final data = UserModel(fullName: fullName).toMap();

      _fs.collection('users').doc(credential.user?.uid).set(data);

      return credential.user;
    } catch (e) {
      print('Can\'t Sign Up now.');
      print(e);
    }
    return null;
  }

  Future<User?> signInWithEmailAndPasswrod(
      String emailInput, String passwordInput) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailInput,
        password: passwordInput,
      );
      return credential.user;
    } catch (e) {
      print('Can\'t Sign In now.');
      print(e);
    }
    return null;
  }

  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  Future<void> signOut(context, index) async {
    await _auth.signOut();
    Navigator.pushNamed(context, _route[index]!);
  }

  String getCurrentUserId() {
    return _auth.currentUser!.uid;
  }
}
