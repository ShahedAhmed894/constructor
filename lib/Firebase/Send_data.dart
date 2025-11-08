import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
class Send_data_1 extends StatefulWidget {
  const Send_data_1({super.key});

  @override
  State<Send_data_1> createState() => _Send_data_1State();
}

class _Send_data_1State extends State<Send_data_1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("send data"),
      ),
      body: Center(
child: ElevatedButton(onPressed: () async {
 await  FirebaseFirestore.instance.collection("Data").add({"Name":"Ahmed"});
}, child: Text("send data")),
      ),
    );

  }
}
