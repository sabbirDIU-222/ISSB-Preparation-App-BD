import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PreliminarySection extends StatefulWidget {
  final String collectionName;
  final String appBarTitle;

  PreliminarySection({required this.collectionName, required this.appBarTitle});

  @override
  State<PreliminarySection> createState() => _PreliminarySectionState();
}

class _PreliminarySectionState extends State<PreliminarySection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(widget.collectionName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];

              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 5.0),
                  child: Column(
                    children: [
                      Image.network(doc['img']),
                      SizedBox(height: 19.0),
                      Text(doc['description']),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
