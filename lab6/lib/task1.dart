import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageGridScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ImageGridScreen extends StatelessWidget {
  final List<String> imageUrls = List.generate(
    20,
    (index) => 'https://picsum.photos/id/${index + 10}/200/200',
  );

  ImageGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth ~/ 150).clamp(2, 6);

    return Scaffold(
      appBar: AppBar(title: Text('Responsive Image Grid')),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Image.network(imageUrls[index], fit: BoxFit.cover);
        },
      ),
    );
  }
}
