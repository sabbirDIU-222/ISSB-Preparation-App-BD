import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('FAQs').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Process the FAQ documents and create an expandable list view
          // based on the fetched data
          return ListView.builder(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, top: 9.0, bottom: 8.0),
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final faq = snapshot.data!.docs[index];
              final question = faq['question'];
              final answer = faq['answer'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.only(
                      left: 9.0, right: 9.0, bottom: 8.0, top: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFFF5F5DC),
                  ),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.only(bottom: 9.0),
                    title: Text(
                      question,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                          fontFamily: 'Sirin',
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xFFE1F5FE),
                          ),
                          child: Text(
                            answer,
                            style: TextStyle(
                              fontSize: 17.0,
                              height: 1.7,
                              color: Colors.black,
                              fontFamily: 'Open',
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w400,

                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
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
