import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizapp/ui/login_page.dart';
import 'package:quizapp/ui/start_quiz.dart';

import '../common/preffs_manager.dart';

class SplashPage extends StatefulWidget {
  final PreferenceManager preffs;
  final FirebaseAuth firebaseAuth;

  const SplashPage({super.key, required this.preffs, required this.firebaseAuth});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 2),
      () {
        if (widget.firebaseAuth.currentUser != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => StartQuiz(user: widget.firebaseAuth.currentUser!, firebaseAuth: widget.firebaseAuth)));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.asset(
        'assets/images/logo.png',
        height: 100,
        width: 100,
      ),
    ));
  }
}
