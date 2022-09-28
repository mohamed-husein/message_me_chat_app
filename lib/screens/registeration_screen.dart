import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message_me_chat_app/screens/chat_screen.dart';
import 'package:message_me_chat_app/screens/users_screen.dart';
import 'package:message_me_chat_app/shared/cache_helper.dart';
import 'package:message_me_chat_app/widgets/my_button.dart';

class RegisterationScreen extends StatefulWidget {
  const RegisterationScreen({super.key});
  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen>{
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;


  void registerNewUser() async {

    try{
          await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
        CacheHelper.sharedPreferences.setString('SAVEDUSER',_auth.currentUser!.uid);
  
        createUser();
        
    }
    catch(e){
      debugPrint(e.toString());
    }
  }

  void createUser()async{
    try{
      await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).set({
        'email':email,
        'user_id':_auth.currentUser!.uid,
      });
    }
    catch(e){
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 180,
              child: Image.asset('assets/images/logo.png'),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter Your Email',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter Your Password',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MyButton(
                color: const Color(0xff339FFF),
                text: 'Register',
                onPressed: () async {
                  try {
                    registerNewUser();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const UsersScreen(),),((route) => false));
                   
                  } catch (e) {
                    print(e.toString());
                  }
                }),
          ],
        ),
      ),
    );
  }
}
