import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'exersize_detail.dart';

class ExerciseQusSet extends StatefulWidget {
  @override
  _ExerciseQusSetState createState() => _ExerciseQusSetState();
}

class _ExerciseQusSetState extends State<ExerciseQusSet> {
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  bool isAdmin() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid == 'r0Y23cmSAVWdPTeqqZ13u7YRRuq2';
  }

  Future<List<String>> getImageSetUrls() async {
    try {
      final ListResult result = await _storage.ref('planningImgSet').listAll();
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

  Future<String> fetchDescription(String descriptionRef) async {
    try {
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(descriptionRef);
      String descriptionText =
          await ref.getData().then((data) => String.fromCharCodes(data!));
      return descriptionText;
    } catch (e) {
      print('Error fetching description: $e');
      return 'Error loading description';
    }
  }

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      final fileName = file.path.split('/').last;

      try {
        await _storage.ref('planningImgSet/$fileName').putFile(file);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Questions'),
        elevation: 0.0,
        centerTitle: true,
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
              final descriptionRef = 'planningImgSet/description$itemIndex.txt';

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
                    onTap: () async {
                      String description =
                          await fetchDescription(descriptionRef);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetailScreen(
                            imageUrl: imageUrl,
                            itemIndex: itemIndex,
                          ),
                        ),
                      );
                    },
                    leading: Icon(Icons.next_plan_outlined,color: Colors.white,size: 35,)/*CircleAvatar(
                      maxRadius: 22,
                      backgroundImage: NetworkImage(imageUrl),
                    )*/,
                    title: Text(
                      'Plannig image  $itemIndex',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Open',
                          color: Colors.white,
                          letterSpacing: 1.4,
                      ),
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
