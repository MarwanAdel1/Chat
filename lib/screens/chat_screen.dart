import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const ROUTE_NAME="chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {
    final routeArguments = ModalRoute.of(context).settings.arguments as Map<String,dynamic>;
    final friendId = routeArguments['friendId'];
    final friendUsername = routeArguments['friendUsername'];

    return Scaffold(
      appBar: AppBar(
        title: Text(friendUsername),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(friendId),
            ),
            NewMessage(friendId),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    fbm.subscribeToTopic('chat');
  }
}
