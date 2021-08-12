import 'package:chat_app/screens/friends_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  String readTimestamp(Timestamp timestamp) {
    var time = "";
    DateTime date = timestamp.toDate();

    var diff = DateTime.now().difference(date);

    if (diff.inDays <= 0) {
      time = DateFormat.jm().format(date).toString();
    } else if (diff.inDays == 1) {
      time = "Yesterday";
    } else if (diff.inDays > 1 && diff.inDays <= 7) {
      time = DateFormat.E().format(date).toString();
    } else {
      time = DateFormat.yMd().format(date).toString();
    }

    return time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Logout"),
                    ],
                  ),
                ),
                value: "logout",
              ),
            ],
            onChanged: (item) {
              if (item == "logout") {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userChatList')
                    .doc(user.uid)
                    .collection('friends')
                    .orderBy('time', descending: true)
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
                      final friendImage = chatDocs[index]['friend_image'];
                      final friendUsername = chatDocs[index]['username'];
                      final lastMessage = chatDocs[index]['message'];
                      final senderId = chatDocs[index]['sender_id'];
                      bool whoSend = senderId == user.uid;
                      final sendingTime = chatDocs[index]['time'];
                      final usernameAfterSplit =
                          friendUsername.toString().split(" ");
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(friendImage),
                        ),
                        title: Text(
                          friendUsername,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: whoSend
                                  ? "You: "
                                  : "${usernameAfterSplit[0]}: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: "$lastMessage",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                          ]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          readTimestamp(sendingTime),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            ChatScreen.ROUTE_NAME,
                            arguments: {
                              'friendId': chatDocs[index]['uid'],
                              'friendUsername': chatDocs[index]['username'],
                            },
                          );
                        },
                      );
                    },
                    itemCount: chatDocs.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.message),
        onPressed: () {
          Navigator.of(context).pushNamed(FriendsListScreen.ROUTE_NAME);
        },
      ),
    );
  }
}
