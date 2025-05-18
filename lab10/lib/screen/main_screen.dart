import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadPost() async {
    if (_image == null ||
        _titleController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please complete all fields')));
      return;
    }

    // Upload image to Firebase Storage
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('post_images')
        .child(fileName);
    UploadTask uploadTask = storageRef.putFile(_image!);
    TaskSnapshot storageSnapshot = await uploadTask;
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();

    // Save post data to Firestore
    await FirebaseFirestore.instance.collection('posts').add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'imageUrl': downloadUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Clear fields
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _image = null;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Post uploaded successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Post Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Post Description'),
            ),
            SizedBox(height: 10),
            _image != null
                ? Image.file(_image!, height: 150)
                : Text('No image selected'),
            ElevatedButton(onPressed: _pickImage, child: Text('Select Image')),
            ElevatedButton(onPressed: _uploadPost, child: Text('Upload')),
          ],
        ),
      ),
    );
  }
}
