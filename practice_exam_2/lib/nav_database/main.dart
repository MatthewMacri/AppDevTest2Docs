import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:practice_exam_2/nav_database/registerpage.dart';
import 'package:sqflite/sqflite.dart';
import 'homescreen.dart';
import 'package:sqflite/sqflite.dart';

class User {
  String username;
  String password;
  int id;

  User(this.username, this.password, this.id);

  Map<String, Object?> toMap() {
    return {'username': username, 'password': password, 'id' : id};
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

Future<Database> getDatabase() async {
  return openDatabase(
    join(await getDatabasesPath(), "user_database.db"),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT)');
    },
    version: 1,
  );
}

Future<void> insertUser(User user) async {
  final db = await getDatabase();
  await db.insert("users", user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<void> removeUser(User user) async {
  final db = await getDatabase();
  await db.delete("users", where: 'id = ?', whereArgs: [user.id]);
}

Future<User?> getUser(String username) async {
  final db = await getDatabase();
  List<Map<String, Object?>> result = await db.query(
    'users',
    where: 'username = ?',
    whereArgs: [username],
  );
  if (result.isNotEmpty) {
    return User(
      result[0]['username'] as String,
      result[0]['password'] as String,
      result[0]['id'] as int,
    );
  }
  return null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RandomScreen(),
    );
  }
}

class RandomScreen extends StatefulWidget {
  const RandomScreen({super.key});

  @override
  State<RandomScreen> createState() => _RandomScreenState();
}

class _RandomScreenState extends State<RandomScreen> {

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test 2 Nav and Database'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              child: Column(
                children: [
                  TextField(controller: _username, decoration: InputDecoration(hintText: 'Username')),
                  TextField(controller: _password, decoration: InputDecoration(hintText: 'Password')),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));

                      }, child: Text('Register')),
                      SizedBox(width: 20,),
                      ElevatedButton(
                        onPressed: () async {
                          String inputUsername = _username.text;
                          String inputPassword = _password.text;

                          User? user = await getUser(inputUsername);

                          if (user != null && user.password == inputPassword) {
                            // Credentials match, proceed with login
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen(username: user.username)),
                            );
                          } else {
                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Invalid username or password')),
                            );
                          }
                        },
                        child: Text('Login'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

