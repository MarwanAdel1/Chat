import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  String message;
  String username;
  String imageUrl;
  bool isMe;

  MessageBubble(this.message, this.username, this.imageUrl, this.isMe,
      {Key key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(12) : Radius.circular(0),
                ),
              ),
              width: 300,
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: isMe ? 16 : 50,
                right: isMe ? 50 : 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe
                            ? Colors.black
                            : Theme.of(context).accentTextTheme.title.color),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context).accentTextTheme.title.color),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: Colors.grey,
          ),
          top: 0,
          left: isMe ? null : 0,
          right: isMe ? 0 : null,
        )
      ],
      overflow: Overflow.visible,
    );
  }
}
