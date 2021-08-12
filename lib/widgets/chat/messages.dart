import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  final String friendId;

  Messages(this.friendId);

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('userChat')
          .doc(user.uid)
          .collection('Friends')
          .doc(friendId)
          .collection('messages')
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
            return MessageBubble(
              chatDocs[index]['text'],
              chatDocs[index]['userUsername'],
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
