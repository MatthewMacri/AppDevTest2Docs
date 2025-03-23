import 'package:flutter/material.dart';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _id = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Screen'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _username, decoration: InputDecoration(hintText: 'Username')),
            TextField(controller: _password, decoration: InputDecoration(hintText: 'Password')),
            TextField(controller: _id, decoration: InputDecoration(hintText: 'ID')),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () async {
                if (_username.text.isNotEmpty &&
                    _password.text.isNotEmpty &&
                    _id.text.isNotEmpty) {
                  try {
                    User user = User(_username.text, _password.text, int.parse(_id.text));
                    await insertUser(user); // Await the insert
                    Navigator.pop(context);
                  } catch (e) {
                    print("Error inserting user: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error inserting user')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Fields Are Empty !')),
                  );
                }
              },
              child: Text('SUBMIT'),
            )
          ],
        ),
      ),
    );
  }
}
