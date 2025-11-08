import 'package:flutter/material.dart';
class class_A extends StatefulWidget {
  const class_A({super.key});

  @override
  State<class_A> createState() => _class_AState();
}

class _class_AState extends State<class_A> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("class A"),
      ),
      body: Center(

      ),
    );
  }
}
