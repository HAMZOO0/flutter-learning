import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  // Sample List of Items
  final List<String> items = List.generate(
    20,
    (index) => "Item ${index + 1} - Hamza Sajid",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ListView - Hamza Sajid"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(Icons.star, color: Colors.blueAccent),
              title: Text(
                items[index],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Description - Hamza Sajid"),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {
                print("${items[index]} clicked by Hamza Sajid");
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("FAB Clicked by Hamza Sajid!");
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
