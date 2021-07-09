import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: FirebaseAuth.,
    //   builder: (ctx, userSnapshot) {
    //     if (userSnapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data.docs;

        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemBuilder: (ctxx, index) {
            print("$index : Text : ${chatDocs[index]['text']}\nUsername : ${chatDocs[index]['username']}\n "
                "User Image : ${chatDocs[index]['userImage']}\nUser ID : ${chatDocs[index]['userId']}\n");
            return MessageBubble(
              chatDocs[index]['text'],
              chatDocs[index]['username'],
              chatDocs[index]['userImage'],
              chatDocs[index]['userId'] == user.uid,
              key: ValueKey(chatDocs[index].id),
            );
          },
          itemCount: chatDocs.length,
          reverse: true,

        );
      },
    );
  }
}
