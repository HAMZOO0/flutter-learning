import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'post.dart';
import 'post_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PostListScreen(),
    );
  }
}

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = PostApi.fetchPosts();
  }

  void _refresh() {
    setState(() {
      futurePosts = PostApi.fetchPosts();
    });
  }

  void _showCreateDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create New Post"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
              TextField(controller: bodyController, decoration: InputDecoration(labelText: "Body")),
            ],
          ),
          actions: [
            TextButton(onPressed: Navigator.of(context).pop, child: Text("Cancel")),
            TextButton(
              onPressed: () async {
                final newPost = Post(id: 0, title: titleController.text, body: bodyController.text);
                await PostApi.createPost(newPost);
                _refresh();
                Navigator.of(context).pop();
              },
              child: Text("Create"),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Post post) {
    TextEditingController titleController = TextEditingController(text: post.title);
    TextEditingController bodyController = TextEditingController(text: post.body);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Post"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
              TextField(controller: bodyController, decoration: InputDecoration(labelText: "Body")),
            ],
          ),
          actions: [
            TextButton(onPressed: Navigator.of(context).pop, child: Text("Cancel")),
            TextButton(
              onPressed: () async {
                final updatedPost = Post(id: post.id, title: titleController.text, body: bodyController.text);
                await PostApi.updatePost(updatedPost);
                _refresh();
                Navigator.of(context).pop();
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this post?"),
          actions: [
            TextButton(onPressed: Navigator.of(context).pop, child: Text("No")),
            TextButton(
              onPressed: () async {
                await PostApi.deletePost(id);
                _refresh();
                Navigator.of(context).pop();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CRUD Posts")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No posts found."));
          } else {
            final posts = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.body),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showEditDialog(context, post),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _showDeleteDialog(context, post.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}