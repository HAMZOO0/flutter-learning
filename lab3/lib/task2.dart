import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'LAB # 3',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // Red Section with Image
            Container(
              color: Colors.red,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.blue,
                    padding: EdgeInsets.all(5),
                    child: Image.network(
                      'https://media.licdn.com/dms/image/v2/D4D03AQE1L7YkzQjiqg/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1730012871292?e=1747267200&v=beta&t=SSJie6tV2PDTGzPzWI6RfEhV-wOVJlqcr_Ltif3Uv5s',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Overlapping Boxes
            Stack(
              alignment: Alignment.center,
              children: [
                Container(height: 100, width: 100, color: Colors.blue),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(height: 50, width: 50, color: Colors.green),
                ),
              ],
            ),

            // Vertical Numbered List
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              color: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(9, (index) {
                  return Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }),
              ),
            ),

            // Footer Text
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'PRACTICE MORE THEN THIS. IT WILL HELP YOU TO DESIGN COMPLEX MOBILE APP DESIGN',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),

            // Footer Section
            Container(
              color: Colors.green,
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LEADING',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ClipOval(
                    child: Image.network(
                      'https://media.licdn.com/dms/image/v2/D4D03AQE1L7YkzQjiqg/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1730012871292?e=1747267200&v=beta&t=SSJie6tV2PDTGzPzWI6RfEhV-wOVJlqcr_Ltif3Uv5s',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    'TRAILING',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
