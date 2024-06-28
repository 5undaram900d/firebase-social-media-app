
import 'dart:async';
// import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_media_app/ui/auth/A03_LoginScreen.dart';
import 'package:firebase_social_media_app/ui/posts/A07_PostScreen.dart';
import 'package:flutter/material.dart';

class SplashServices{
  void isLogin(BuildContext context){

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user != null){
      Timer(const Duration(seconds: 2), () => {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PostScreen()))
      });
    }
    else{
      Timer(const Duration(seconds: 2), () => {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()))
      });
    }

  }
}