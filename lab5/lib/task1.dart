import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animations',
      debugShowCheckedModeBanner: false,
      home: const Box(),
    );
  }
}

class Box extends StatefulWidget {
  const Box({super.key});

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  double _opacity = 1;
  double _margin = 0;
  double _padding = 0;
  double _width = 200;
  Color _color = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              margin: EdgeInsets.all(_margin),
              padding: EdgeInsets.all(_padding),
              width: _width,
              height: 100,
              color: _color,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _margin = 20;
                });
              },
              child: const Text('Animate the Margin'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _padding = 50;
                });
              },
              child: const Text('Animate the Padding'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _color = Colors.green;
                });
              },
              child: const Text('Animate the Color'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _width = 500;
                });
              },
              child: const Text('Animate the Width'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _opacity = 0;
                });
              },
              child: const Text('Animate the Opacity'),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              duration: const Duration(seconds: 2),
              opacity: _opacity,
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Hide me please',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
