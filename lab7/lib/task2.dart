import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApiApp());
}

class MyApiApp extends StatelessWidget {
  const MyApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PostScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Map<String, dynamic>? _postData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  Future<void> fetchPost() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _postData = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
        _postData = {
          'title': 'Error',
          'body': 'Could not fetch post. Please try again later.'
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Random Post')),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _postData!['title'] ?? '',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text(_postData!['body'] ?? ''),
                  ],
                ),
              ),
      ),
    );
  }
}