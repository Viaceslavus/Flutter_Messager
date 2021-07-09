import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sommer/user_settings.dart';

class MessageListView extends StatefulWidget {
  final String dbPath;

  const MessageListView(this.dbPath);

  @override
  _MessageListViewState createState() => _MessageListViewState(dbPath);
}

class _MessageListViewState extends State<MessageListView> {
  final String dbPath;
  DatabaseReference? myContacts;

  List<Message> messages = [];

  _MessageListViewState(this.dbPath);

  @override
  Future<void> initState() async {
    super.initState();
    myContacts = FirebaseDatabase.instance
        .reference()
        .child("Contacts")
        .child(UserSettings().userName!);
    var loadedMessages = await myContacts?.child(dbPath).get();
    var messagesMap = loadedMessages?.value as Map<String, Object>;
    for (int i = 0; i < messagesMap.length; i++) {
      var messageText = messagesMap.keys.elementAt(i);
      bool isMyMessage = myContacts?.child(messageText).child('isMine') as bool;
      messages.add(
          Message(messagesMap.values.elementAt(i).toString(), isMyMessage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          child: StreamBuilder(
            stream: myContacts?.onChildAdded,
            builder: ((BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData)
                messages.add(snapshot.data);

              return Column(
                children: messages,
              );
             }
            ),
          ),
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String text;
  final bool isMine;

  const Message(this.text, this.isMine);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3.2),
      child: Container(
        color: isMine ? Colors.blue : Colors.blue[185],
        child: Text(
          text,
          textAlign: isMine ? TextAlign.right : TextAlign.left,
        ),
      ),
    );
  }
}
