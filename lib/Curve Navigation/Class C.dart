import 'package:flutter/material.dart';
class class_C extends StatefulWidget {
  const class_C({super.key});

  @override
  State<class_C> createState() => _class_CState();
}

class _class_CState extends State<class_C> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("class C"),
      ),
      body: Center(
child: Image.network("https://imgs.search.brave.com/kJOny2nYsfGqW2dS2oxaef-nrCMZV7c8bVt0yvjCjIk/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5nZXR0eWltYWdl/cy5jb20vaWQvMjM3/MDk3NC9waG90by9l/ZGluYnVyZ2gtc2Nv/dGxhbmQtYWxmaWUt/am9leS1wb3Nlcy1v/bi10b3Atb2YtaGlz/LXJlZC1mb3JkLWVz/Y29ydC1iZWZvcmUt/cGVyZm9ybWluZy1p/bi1hbGZpZS5qcGc_/cz02MTJ4NjEyJnc9/MCZrPTIwJmM9SlRw/Umw0cE8tQkZ0Q3FZ/azA1OGlSMm02YW03/UGVVdEFVWVZRSTcw/Wk42Zz0"),
      ),
    );
  }
}
