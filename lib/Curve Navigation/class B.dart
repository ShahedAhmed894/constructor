import 'package:flutter/material.dart';
class class_B extends StatefulWidget {
  const class_B({super.key});

  @override
  State<class_B> createState() => _class_BState();
}

class _class_BState extends State<class_B> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("class B"),
      ),
      body: Center(

      ),
    );
  }
}
