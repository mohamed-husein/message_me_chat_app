import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:message_me_chat_app/screens/chat_screen.dart';
import 'package:message_me_chat_app/screens/registeration_screen.dart';
import 'package:message_me_chat_app/screens/signin_screen.dart';
import 'package:message_me_chat_app/screens/users_screen.dart';
import 'package:message_me_chat_app/screens/welcome_screen.dart';
import 'package:message_me_chat_app/shared/cache_helper.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Message Me',
      theme: ThemeData(
        fontFamily: 'Tajawal',
        primarySwatch: Colors.blue,
      ),
      home:CacheHelper.sharedPreferences.getString('SAVEDUSER') ==null? const WelcomeScreen() : const UsersScreen(),
     
    );
  }
}
