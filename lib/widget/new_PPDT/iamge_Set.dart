import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'image_detail.dart';

class ImageSetListScreen extends StatefulWidget {
  @override
  _ImageSetListScreenState createState() => _ImageSetListScreenState();
}

class _ImageSetListScreenState extends State<ImageSetListScreen> {
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  bool isAdmin() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid == 'r0Y23cmSAVWdPTeqqZ13u7YRRuq2';
  }

  Future<List<String>> getImageSetUrls() async {
    try {
      final ListResult result = await _storage.ref('imageSets').listAll();
      final imageUrls = <String>[];

      for (final ref in result.items) {
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }

      return imageUrls;
    } catch (e) {
      print('Error loading image sets: $e');
      return [];
    }
  }

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      final fileName = file.path.split('/').last;

      try {
        await _storage.ref('imageSets/$fileName').putFile(file);
        setState(() {
          // Refresh the list after uploading the image
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      await _storage.refFromURL(imageUrl).delete();
      setState(() {
        // Refresh the list after deleting the image
      });
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  void _showSuggestionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tips'),
        content: Text('Examine the pictures carefully.\n'
            'Focus specifically on the surroundings.\n'
            'Identify the main character as “the hero of the story\n'
            'Maintain your optimism throughout the procedure.\n'
            'Refrain from exaggerating anything you portray.\n'
            ' Be imaginative as you write your story.\n'
            'When writing, use your imagination.\n'
            'Stay focused on time and accuracy.\n'
            'Avoid any type of deceptive or misleading behavior\n'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Got It!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Picture Perception Test'),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.lightbulb,
              color: Colors.white,
            ),
            onPressed: () {
              _showSuggestionDialog();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: getImageSetUrls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading image sets'),
            );
          }
          final imageSetUrls = snapshot.data;

          return ListView.builder(
            itemCount: imageSetUrls!.length,
            itemBuilder: (context, index) {
              final imageUrl = imageSetUrls[index];
              final itemIndex = index + 1;

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                  top: 9.0,
                  left: 8.0,
                  right: 8.0,
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 8.0, left: 5.0, right: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF6BAF7D),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageSetDetailScreen(imageUrl: imageUrl),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      maxRadius: 22,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    title: Text(
                      'Image  $itemIndex',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Open',
                          letterSpacing: 2.5,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    trailing: isAdmin()
                        ? IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Image'),
                                  content: Text(
                                    'Are you sure you want to delete this image?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteImage(imageUrl);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : null,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: isAdmin()
          ? FloatingActionButton(
              onPressed: () {
                uploadImage();
              },
              child: Icon(Icons.upload),
            )
          : null,
    );
  }
}
