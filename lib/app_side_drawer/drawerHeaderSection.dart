import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizapplication/login_signup_functionality/log_in.dart';

class DrawerHeaderSection extends StatefulWidget {
  final User user;

  const DrawerHeaderSection({required this.user});

  @override
  _DrawerHeaderSectionState createState() => _DrawerHeaderSectionState();
}

class _DrawerHeaderSectionState extends State<DrawerHeaderSection> {
  final List<String> quotes = [
    "Be yourself, If you want to become an officer. make yourself honest first",
    "Be somebody..nobody thought you could be",
    "Success is not final Failure is not fatal It is the courage to continue That counts",
  ];

  ImageProvider fallbackImage = AssetImage('images/usersimage.png');

  String randomQuote = '';

  @override
  void initState() {
    super.initState();
    randomQuote = getRandomQuote();
  }

  String getRandomQuote() {
    final Random random = Random();
    final int index = random.nextInt(quotes.length);
    return quotes[index];
  }

  Future<void> _changeProfilePicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('userProfile')
        .child('${widget.user.uid}.jpg');

    try {
      await storageReference.putFile(File(image.path));
      final String downloadURL = await storageReference.getDownloadURL();
      setState(() {
        // Update the user's photoURL with the new downloadURL
        widget.user.updatePhotoURL(downloadURL);
      });
    } catch (e) {
      // Handle the error, if any
      print('Error uploading profile picture: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    String userName = '';
    String userPhotoUrl = widget.user.photoURL ?? '';

    if (widget.user.providerData.first.providerId == 'password') {
      userName = widget.user.email.toString();
    } else if (widget.user.providerData.first.providerId == 'google.com') {
      userName = widget.user.displayName.toString();
    }

    ImageProvider fallbackImage = AssetImage('images/usersimage.png');

    if (userPhotoUrl.isNotEmpty) {
      fallbackImage = NetworkImage(userPhotoUrl);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: fallbackImage,
                    radius: 40,
                    backgroundColor: Colors.white,
                  ),
                  Positioned(
                    bottom: 0,
                    top: 0,
                    left: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _changeProfilePicture,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontFamily: 'Sirin',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            '"$randomQuote"',
            textAlign: TextAlign.justify,
            maxLines: 2, // Limit the quote to two lines
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

}
