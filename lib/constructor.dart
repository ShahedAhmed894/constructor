import 'package:flutter/material.dart';
class Shahed {
  String name;
  int age;
  Shahed(this.name,this.age); //default constructor

Shahed.toyota(this.name): age=20; //name constructor

}
class constuctor_class extends StatefulWidget {
  const constuctor_class({super.key});

  @override
  State<constuctor_class> createState() => _constuctor_classState();
}

class _constuctor_classState extends State<constuctor_class> {
  @override
  Widget build(BuildContext context) {
    Shahed shahed_object = Shahed("toyota supra", 23);  //default constructor
     Shahed shahed_name =  Shahed.toyota("toyota gr86"); //name constuctor
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("constructor implement"),
      ),
      body: Center(
        child: Column(
children: [
  Text(" ${shahed_object.age},${shahed_object.name}"),    //default construction
  Text("${shahed_name.name},${shahed_name.age}"),       //name constructor
],
        ),
      ),
    );
  }
}
