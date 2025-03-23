import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          children: [
            Text("${username}"),
            ElevatedButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text('HOME SCREEN'))
          ],
        ),
      ),
    );
  }
}
