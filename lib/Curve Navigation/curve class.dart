import 'package:ai_class_1/Curve%20Navigation/Class%20C.dart';
import 'package:ai_class_1/Curve%20Navigation/Class%20D.dart';
import 'package:ai_class_1/Curve%20Navigation/class%20A.dart';
import 'package:ai_class_1/Curve%20Navigation/class%20B.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
class Curve_page extends StatefulWidget {
  const Curve_page({super.key});

  @override
  State<Curve_page> createState() => _Curve_pageState();
}

class _Curve_pageState extends State<Curve_page> {
  final book = [class_A(),class_B(),class_C(),class_D()];
  var page = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("curve class"),
      ),
      bottomNavigationBar: CurvedNavigationBar(

        index: 3,
          onTap: (index) {
            setState(() {
              page = index;
            });
          },
          items: [
            Icon(Icons.home),
            Icon(Icons.call),
            Icon(Icons.info),
            Icon(Icons.car_crash),

          ]
      ),
      body:
       book [page],
    );

  }
}
