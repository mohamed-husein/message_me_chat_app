import 'package:flutter/material.dart';
import 'package:message_me_chat_app/screens/registeration_screen.dart';
import 'package:message_me_chat_app/screens/signin_screen.dart';
import 'package:message_me_chat_app/widgets/my_button.dart';

class WelcomeScreen extends StatefulWidget {
   const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 180,
              child: Image.asset('assets/images/logo.png'),
            ),
            const Text('Message Me',textAlign: TextAlign.center,style: TextStyle(fontSize: 40,fontWeight: FontWeight.w900,color: Color(0xff339FFF),)),
            const SizedBox(height: 30,),
            MyButton(color: const Color(0xff0B5345),text:'Sign In' ,onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (_) => const SignInScreen(),));
            }),
            MyButton(color: const Color(0xff339FFF),text:'Register' ,onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterationScreen(),));
            }),
          ],
        ),
      ),
    );
  }
}

