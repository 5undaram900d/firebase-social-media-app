/**
 for getting SHA_Key for firebase setup
    open gradlew in terminal which is in android folder
    now run command in terminal
      gradlew signingReport
 **/

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_social_media_app/ui/A01_SplashScreen.dart';
import 'package:flutter/material.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal
      ),
      home: SplashScreen(),
    );
  }
}
