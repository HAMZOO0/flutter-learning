import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class FeedScreen extends StatelessWidget {
  Future<void> _downloadImage(String imageUrl, BuildContext context) async {
    try {
      // Request storage permission
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission is required')),
        );
        return;
      }

      // Get image data
      var response = await http.get(Uri.parse(imageUrl));
      var documentDirectory = await getExternalStorageDirectory();
      String path = documentDirectory!.path;
      File file = File('$path/${DateTime.now().millisecondsSinceEpoch}.jpg');
      file.writeAsBytesSync(response.bodyBytes);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Image downloaded successfully')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error downloading image')));
    }
  }

  Future<void> _deletePost(
    String postId,
    String imageUrl,
    BuildContext context,
  ) async {
    bool confirm = await showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Delete Post'),
            content: Text('Are you sure you want to delete this post?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
    );

    if (confirm) {
      // Delete image from Firebase Storage
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      // Delete post from Firestore
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Post deleted successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feed')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('posts')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView(
            children:
                snapshot.data!.docs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(data['title'] ?? ''),
                      subtitle: Text(data['description'] ?? ''),
                      leading: GestureDetector(
                        onLongPress:
                            () => _downloadImage(data['imageUrl'], context),
                        child: Image.network(
                          data['imageUrl'] ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Navigate to update screen with post data
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => UpdateScreen(
                                        postId: doc.id,
                                        currentTitle: data['title'],
                                        currentDescription: data['description'],
                                        currentImageUrl: data['imageUrl'],
                                      ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed:
                                () => _deletePost(
                                  doc.id,
                                  data['imageUrl'],
                                  context,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
