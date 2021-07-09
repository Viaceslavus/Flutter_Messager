import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sommer/home_view.dart';
import 'package:sommer/user_settings.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    bool authorized = false;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        authorized = true;
        UserSettings().userName = auth.currentUser?.email;
      }
    });
    return authorized ? HomeView() : LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(hintText: 'Enter your email'),
                  onChanged: (value) {
                    setState(() {
                      this.email = value;
                    });
                  },
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(hintText: 'Enter your password'),
                  onChanged: (value) {
                    setState(() {
                      this.password = value;
                    });
                  },
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: ElevatedButton(
                child: Text("Login"),
                onPressed: login,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: ElevatedButton(
                child: Text("Sign Up"),
                onPressed: signUp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    if (email == null || password == null) return;

    UserSettings().userName = email!;

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }

    gotoMainView();
  }

  Future<void> signUp() async {
    if (email == null || password == null) return;

    UserSettings().userName = email!;

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }

    var dbUsers =
        FirebaseDatabase.instance.reference().child("RegisteredUsers");
    dbUsers.child(email!).set(email);

    gotoMainView();
  }

  void gotoMainView() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => HomeView(),
    ));
  }
}
