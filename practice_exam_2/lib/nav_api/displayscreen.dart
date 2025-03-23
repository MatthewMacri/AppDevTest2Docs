import 'package:flutter/material.dart';
import 'main.dart';

class Displayscreen extends StatelessWidget {
  final Future<List<Picture>> futureAlbum;
  const Displayscreen({super.key, required this.futureAlbum});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Display Screen"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Picture>>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No images found!"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final picture = snapshot.data![index];
                return ListTile(
                  title: Text(picture.id),
                  trailing: Image.network(picture.download_url),
                );
              },
            );
          }
        },
      ),
    );
  }
}