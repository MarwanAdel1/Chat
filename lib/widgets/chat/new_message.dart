import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final String friendId;

  NewMessage(this.friendId);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  String _enteredMessage = "";

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final friendData = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.friendId)
        .get();

    FirebaseFirestore.instance
        .collection('userChat')
        .doc(user.uid)
        .collection('Friends')
        .doc(widget.friendId)
        .collection('messages')
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userUsername': userData['username'],
      'userImage': userData['image_url'],
    });

    FirebaseFirestore.instance
        .collection('userChat')
        .doc(widget.friendId)
        .collection('Friends')
        .doc(user.uid)
        .collection('messages')
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userUsername': userData['username'],
      'userImage': userData['image_url'],
    });

    FirebaseFirestore.instance
        .collection('userChatList')
        .doc(user.uid)
        .collection('friends')
        .doc(widget.friendId)
        .set({
      'message': _enteredMessage,
      'time': Timestamp.now(),
      'uid': widget.friendId,
      'username': friendData['username'],
      'friend_image': friendData['image_url'],
      'sender_id': user.uid,
    });

    FirebaseFirestore.instance
        .collection('userChatList')
        .doc(widget.friendId)
        .collection('friends')
        .doc(user.uid)
        .set({
      'message': _enteredMessage,
      'time': Timestamp.now(),
      'uid': user.uid,
      'username': friendData['username'],
      'friend_image': friendData['image_url'],
      'sender_id': user.uid,
    });

    setState(() {
      _controller.clear();
      _enteredMessage="";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Send a message...",
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim()=="" ? null : _sendMessage,
            icon: Icon(
              Icons.send,
            ),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
