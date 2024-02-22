import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_workout/view/home_screen/home_screen.dart';
import 'package:home_workout/view/home_screen/home_two.dart';
import 'package:home_workout/view/onboarding/onboardng_screen_one.dart';

// ignore: public_member_api_docs
class SplashServices {
  void isLogin(BuildContext context) async{
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
     await Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home_screen()),
        ),
      );
    } else {
       await Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const onboarding_screen_one()),
        ),
      );
    }
  }
}
