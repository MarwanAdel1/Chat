import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsListItem extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('userFriends')
          .doc('${user.uid}')
          .collection('friends')
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
              return ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                      chatDocs[index]['friend_image']),
                ),
                title: Text(
                  "${chatDocs[index]['friend_username']}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ChatScreen.ROUTE_NAME,
                    arguments: {
                      'friendId': chatDocs[index]['friend_id'],
                      'friendUsername': chatDocs[index]['friend_username'],
                    },
                  );
                },
              );
            },
            itemCount: chatDocs.length,
          );
        }
    );
  }
}
