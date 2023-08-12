import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PpdtScreen extends StatefulWidget {
  final String setId;

  const PpdtScreen({required this.setId});

  @override
  _PpdtScreenState createState() => _PpdtScreenState();
}

class _PpdtScreenState extends State<PpdtScreen> {
  List<String> images = [];
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('ppdt')
        .doc(widget.setId)
        .get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data != null && data.isNotEmpty) {
      List<String> urls = data.values.cast<String>().toList();
      setState(() {
        images = urls;
      });
    }
  }

  void showNoImageSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No more images available')),
    );
  }

  void showPreviousImage() {
    setState(() {
      if (currentImageIndex > 0) {
        currentImageIndex--;
      } else {
        showNoImageSnackbar();
      }
    });
  }

  void showNextImage() {
    setState(() {
      if (currentImageIndex < images.length - 1) {
        currentImageIndex++;
      } else {
        showNoImageSnackbar();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PPDT'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: images[currentImageIndex],
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        )
                      : CircularProgressIndicator(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  if (currentImageIndex > 0)
                    Expanded(
                      child: MaterialButton(
                        height: 45,
                        child: Text(
                          'Previous',
                          style: TextStyle(color: Colors.white,fontSize: 18),
                        ),
                        onPressed: showPreviousImage,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        color: Colors.green,
                      ),
                    ),
                  if (currentImageIndex > 0) SizedBox(width: 12),
                  if (currentImageIndex < images.length - 1)
                    Expanded(
                      child: MaterialButton(
                        height: 45,
                        child: Text(
                          'Next',
                          style: TextStyle(color: Colors.white,fontSize: 18),
                        ),
                        onPressed: showNextImage,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 50),
            ],
          );
        },
      ),
    );
  }
}
