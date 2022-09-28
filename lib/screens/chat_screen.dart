import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message_me_chat_app/model/message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.allUsers, required this.index});

  final List allUsers;
  final int index;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController textMessage = TextEditingController();

  void sendMessages({required String textMessage}) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chats')
        .doc(widget.allUsers[widget.index]['user_id'])
        .collection('messages')
        .add({
      'text_message': textMessage,
      'date_message': FieldValue.serverTimestamp(),
      'sender_id': _auth.currentUser!.uid,
      'email': _auth.currentUser!.email,
      'reciever_id': widget.allUsers[widget.index]['user_id'],
    }).then((value) {
      setState(() {});
    }).catchError((error) {
      setState(() {
        print(error.toString());
      });
    });

    await _firestore
        .collection('users')
        .doc(widget.allUsers[widget.index]['user_id'])
        .collection('chats')
        .doc(_auth.currentUser!.uid)
        .collection('messages')
        .add({
      'text_message': textMessage,
      'date_message': FieldValue.serverTimestamp(),
      'sender_id': _auth.currentUser!.uid,
      'email': _auth.currentUser!.email,
      'reciever_id': widget.allUsers[widget.index]['user_id'],
    }).then((value) {
      setState(() {});
    }).catchError((error) {
      setState(() {
        print(error.toString());
      });
    });
  }
 List allMessages=[]; 
  void getMessages(){
    _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chats')
        .doc(widget.allUsers[widget.index]['user_id'])
        .collection('messages').snapshots().listen((event) {
          allMessages=[];
          for (var element in event.docs) {
     setState(() {
              allMessages.add(MessageModel.fromJson(element.data()));
            print('=========================');
            print(allMessages[0]['email']);
         print('=========================');
     });
           }
        });
  }
  

  User? currentUser;
  String? messageText;
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        currentUser = user;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  void initState() {
    getCurrentUser();
getMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text(widget.allUsers[widget.index]['email'])
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .collection('chats')
                  .doc(widget.allUsers[widget.index]['user_id'])
                  .collection('messages')
                  .orderBy('date_message')
                  .snapshots(),
              builder: (context, snapshot) {
                List<MessageLine> messagesWidget = [];
                final message = snapshot.data!.docs.reversed;
                for (var message in message) {
                  final messageText = message.get('text_message');
                  final messageSender = message.get('email');
                  final user = currentUser!.email;
                  if (user == messageSender) {}
                  final messageWidget = MessageLine(
                    messageText: messageText,
                    messageSender: messageSender,
                    isMe: user == messageSender,
                  );
                  messagesWidget.add(messageWidget);
                }
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      children: messagesWidget,
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xff0B5345),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: textMessage,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here ...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textMessage.clear();
                      sendMessages(textMessage: messageText!);
                    },
                    child: const Text(
                      'Send',
                      style: TextStyle(color: Color(0xff0B5345), fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageLine extends StatelessWidget {
  const MessageLine({
    Key? key,
    required this.messageText,
    required this.messageSender,
    required this.isMe,
  }) : super(key: key);

  final String messageText;
  final String messageSender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            messageSender,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20))
                : const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(4)),
            color: isMe ? const Color(0xff0B5345) : const Color(0xff339FFF),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                messageText,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
