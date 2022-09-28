import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message_me_chat_app/screens/chat_screen.dart';
import 'package:message_me_chat_app/screens/signin_screen.dart';
import 'package:message_me_chat_app/shared/cache_helper.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List allUsers = [];
  final _auth = FirebaseAuth.instance;

   void signOut() async {
    try {
      await _auth.signOut();
      CacheHelper.sharedPreferences.remove('SAVEDUSER');
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  
  getAllUsers() async {
    try {
      CollectionReference userRef = FirebaseFirestore.instance.collection('users');
      var response = await userRef.get();
      final user = response.docs;
      for (var element in user) {
        
          if (element.get('user_id') != _auth.currentUser!.uid) {
            setState(() {
              allUsers.add(element.data());
            });
          }
      
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff0B5345),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 25,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text('Message Me')
          ],
        ),
         actions: [
          IconButton(
            onPressed: () {
              signOut();
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignInScreen(),));
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) =>  ChatScreen(allUsers: allUsers,index: index),));
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          allUsers[index]['email'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(thickness: 2),
              ),
          itemCount: allUsers.length),
    );
  }
}
