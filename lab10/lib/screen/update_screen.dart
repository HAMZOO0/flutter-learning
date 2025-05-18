import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateScreen extends StatefulWidget {
  final String postId;
  final String currentTitle;
  final String currentDescription;
  final String currentImageUrl;

  UpdateScreen({
    required this.postId,
    required this.currentTitle,
    required this.currentDescription,
    required this.currentImageUrl,
  });

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  File? _newImage;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTitle);
    _descriptionController = TextEditingController(text: widget.currentDescription);
  }

  Future<void> _pickNewImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _newImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _updatePost() async {
    String imageUrl = widget.currentImageUrl;

    if (_newImage != null) {
      // Delete old image
      await FirebaseStorage.instance.refFromURL(widget.currentImageUrl).delete();

      // Upload new image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('post_images').child(fileName);
      UploadTask uploadTask = storageRef.putFile(_newImage!);
      TaskSnapshot storageSnapshot = await uploadTask;
      imageUrl = await storageSnapshot.ref.getDownloadURL();
    }

    // Update Firestore document
    await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'imageUrl': imageUrl,
    });

    Scaffold
::contentReference[oaicite:0]{index=0}
 
