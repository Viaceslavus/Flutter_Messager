import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sommer/user_settings.dart';
import 'message_list.dart';

class WritingMessageView extends StatefulWidget {
  final String dbPath;

  const WritingMessageView(this.dbPath);

  @override
  _WritingMessageViewState createState() => _WritingMessageViewState(dbPath);
}

class _WritingMessageViewState extends State<WritingMessageView> {
  final String dbPath;
  String? lastMessage;

  _WritingMessageViewState(this.dbPath);

  @override
  Widget build(BuildContext context) {
    var messageText = TextEditingController();

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: TextField(
              controller: messageText,
              onChanged: (mess) => setState(() => lastMessage = mess),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              child: Icon(Icons.send),
              onPressed: () async {
                var message = messageText.text;
                if (message != "") {
                  await addMessageToDb(message);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addMessageToDb(String message) async {
    var myConversation = FirebaseDatabase.instance
        .reference()
        .child("Contacts")
        .child(UserSettings().userName!)
        .child(dbPath);

    var targetConversation = FirebaseDatabase.instance
        .reference()
        .child("Contacts")
        .child(dbPath)
        .child(UserSettings().userName!);

    var myConversationMessageId = await myConversation.get().asStream().length;

    var myConversationMessageKey = message + myConversationMessageId.toString();

    var targetConversationMessageId =
        await targetConversation.get().asStream().length;

    var targetConversationMessageKey =
        message + targetConversationMessageId.toString();

    await myConversation.child(myConversationMessageKey).set(message);

    await targetConversation.child(targetConversationMessageKey).set(message);

    await myConversation
        .child(myConversationMessageKey)
        .child('isMine')
        .set(true);

    await targetConversation
        .child(targetConversationMessageKey)
        .child('isMine')
        .set(false);
  }
}
