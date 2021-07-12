// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_game/controller/users_controller.dart';
import 'package:word_game/data/user.dart';
import 'package:word_game/data/user_crud.dart';
import 'package:word_game/screen/page_navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // FirebaseMessaging messaging = FirebaseMessaging.instance;

    // messaging.getToken().then((token) {
    //   print('token:${token}');
    //   user = userCrud.getUser(token.toString());
    //   print('user ==> ${user}');
    // });

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: PageNavigation(),
    );
  }
}
