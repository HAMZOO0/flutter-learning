import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: DatabaseListScreen());
  }
}

class DatabaseListScreen extends StatelessWidget {
  const DatabaseListScreen({super.key});

  // Simulating a local database query with Future.delayed
  Future<List<String>> fetchFakeData() async {
    await Future.delayed(Duration(seconds: 2)); // simulate delay
    return [
      'Post 1: Learn Flutter',
      'Post 2: Build UI',
      'Post 3: Use Future',
      'Post 4: Async/Await',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Local DB Simulation")),
      body: Center(
        child: FutureBuilder<List<String>>(
          future: fetchFakeData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // show loader while waiting
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              final items = snapshot.data!;
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.article),
                    title: Text(items[index]),
                  );
                },
              );
            } else {
              return Text("No data found.");
            }
          },
        ),
      ),
    );
  }
}
