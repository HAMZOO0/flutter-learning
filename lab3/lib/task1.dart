import 'package:flutter/material.dart';

void main() {
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // backgroundColor: const Color.fromARGB(255, 21, 131, 131),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //box1
            Image(
              image: NetworkImage(
                "data:image/jpeg;base64,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",
              ),
            ),
            //box2
            ElevatedButton(
              onPressed: () {
                debugPrint("Button Pressed!");
              },
              child: const Text("ElevatedButton"),
            ),

            //box3
            // Text(("Text Widgets ")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite, color: Colors.red, size: 50),
                Text(("Row Text  ")),
                Icon(
                  Icons.add_circle_outlined,
                  color: const Color.fromARGB(255, 40, 186, 71),
                  size: 50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
