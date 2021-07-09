import 'package:flutter/material.dart';
import 'message_list.dart';
import 'write_message.dart';

class MessagingView extends StatefulWidget {
  final String contactName;

  const MessagingView(this.contactName);

  @override
  _MessagingViewState createState() => _MessagingViewState(contactName);
}

class _MessagingViewState extends State<MessagingView> {
  final String contactName;

  _MessagingViewState(this.contactName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contactName),
      ),
      body: MessageListView(contactName),
      bottomSheet: WritingMessageView(contactName),
    );
  }
}
