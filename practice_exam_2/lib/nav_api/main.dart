import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'displayscreen.dart';

class Picture {
  final String id;
  final String download_url;

  const Picture({required this.id, required this.download_url});

  //factory allows this method allows you to convert json to dart object
  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      id: json['id'],
      download_url: json['download_url'],
    );
  }
}

Future<List<Picture>> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://picsum.photos/v2/list'),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Picture.fromJson(json)).toList();

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ApiFetcher(),
    );
  }
}

class ApiFetcher extends StatefulWidget {
  const ApiFetcher({super.key});

  @override
  State<ApiFetcher> createState() => _ApiFetcherState();
}

class _ApiFetcherState extends State<ApiFetcher> {
  late Future<List<Picture>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Api Fetcher'), backgroundColor: Colors.blueAccent,),
      body: Center(
child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Displayscreen(futureAlbum: futureAlbum),
          ),
        );
      },
      child: const Text('Fetch Data'),
    )
  ],
),
      ),
    );
  }
}

