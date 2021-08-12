import 'package:chat_app/screens/find_friends_screen.dart';
import 'package:chat_app/widgets/friends_list_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter/material.dart';

class FriendsListScreen extends StatelessWidget {
  static const ROUTE_NAME="friendslist";
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(FindFriendScreen.ROUTE_NAME);
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: FriendsListItem(),
            ),
          ],
        ),
      ),
    );
  }
}
