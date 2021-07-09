import 'package:flutter/material.dart';

class Raw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wow"),
      ),
      body: Container(
        color: Colors.amber,
        child: Row(
          children: <Widget>[
            Box(),
            Box(),
            Box(),
          ],
        ),
      ),
    );
  }
}

class Box extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 90,
      color: Colors.red,
    );
  }
}
