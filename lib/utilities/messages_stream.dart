import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'message_bubble.dart';

class MessagesStream extends StatelessWidget {
  final ScrollController scrollController;
  final Stream stream;

  MessagesStream({@required this.stream, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents;
        List<MessageBubble> messageBubble = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];

          messageBubble.add(
            MessageBubble(text: messageText, sender: messageSender),
          );
        }
        return Expanded(
          child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            children: messageBubble,
          ),
        );
      },
    );
  }
}
