import 'package:flutter/material.dart';
import 'package:sommer/messaging/message_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sommer/user_settings.dart';
import 'messaging/messaging_main.dart';

class HomeView extends StatelessWidget {
  static String name = "Slavikogram";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: ContactsListView(),
      bottomSheet: Container(
        alignment: Alignment.bottomCenter,
        width: 100,
        height: 100,
        child: AddContactButton(),
      ),
    );
  }
}

class AddContactButton extends StatefulWidget {
  @override
  _AddContactButtonState createState() => _AddContactButtonState();
}

class _AddContactButtonState extends State<AddContactButton> {
  static Function(String)? addingContactConfirmed;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: ElevatedButton(
        child: Icon(Icons.add),
        onPressed: () {
          showContactFindWindow(context);
        },
      ),
    );
  }

  void addContact(String contactName) => setState(() {
        addingContactConfirmed?.call(contactName);
      });

  showContactFindWindow(BuildContext context) {
    var textController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter phone number"),
            content: TextField(
              controller: textController,
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    addContact(textController.text);
                    Navigator.of(context).pop();
                  },
                  child: Text("Добавить"))
            ],
          );
        });
  }
}

class ContactsListView extends StatefulWidget {
  @override
  _ContactsListViewState createState() {
    return _ContactsListViewState();
  }
}

class _ContactsListViewState extends State<ContactsListView> {
  List<ContactButton> contacts = [];

  _ContactsListViewState() {
    _AddContactButtonState.addingContactConfirmed = addContactOnClick;
  }

  @override
  Future<void> initState() async {
    super.initState();

    var myContacts = FirebaseDatabase.instance
        .reference()
        .child("Contacts")
        .child(UserSettings().userName!);
    var childrenStream = myContacts.onChildAdded;

    await for (var contact in childrenStream) {
      addContactToList(contact.snapshot.key!);
    }

    childrenStream.listen((event) {
      addContactToList(event.snapshot.key!);
    });
  }

  void addContactOnClick(String contactName) async {
    var dbUsers =
        FirebaseDatabase.instance.reference().child("RegisteredUsers");
    var userData = await dbUsers.child(contactName).get();

    if (userData?.value != null) addContactToList(contactName);
  }

  void addContactToList(String contactName) {
    setState(() {
      contacts.add(ContactButton(contactName));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: contacts,
          ),
        ),
      ),
    );
  }
}

class ContactButton extends StatefulWidget {
  final String contactName;

  const ContactButton(this.contactName);

  @override
  _ContactButtonState createState() => _ContactButtonState(contactName);
}

class _ContactButtonState extends State<ContactButton> {
  final String contactName;

  _ContactButtonState(this.contactName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: SizedBox(height: 2),
          ),
          Container(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MessagingView(contactName),
                ));
              },
              child: Container(
                color: Colors.blueAccent[200],
                alignment: Alignment.topCenter,
                height: 80,
                child: Center(
                  child: Text(contactName),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
