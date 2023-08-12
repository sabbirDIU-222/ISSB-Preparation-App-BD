import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class PdfListScreen extends StatefulWidget {
  @override
  _PdfListScreenState createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  List<Map<String, dynamic>> pdfList = [];

  @override
  void initState() {
    super.initState();
    fetchPdfList();
  }

  Future<void> fetchPdfList() async {
    final collectionRef =
        firebase_storage.FirebaseStorage.instance.ref('pdf_file');
    final listResult = await collectionRef.listAll();

    final List<Map<String, dynamic>> pdfData = [];
    for (final item in listResult.items) {
      final url = await item.getDownloadURL();
      pdfData.add({
        'name': item.name,
        'url': url,
      });
    }

    setState(() {
      pdfList = pdfData;
    });
  }

  Future<void> _openPdfViewer(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    final dir = await getApplicationDocumentsDirectory();
    final File file = File('${dir.path}/temp.pdf');
    await file.writeAsBytes(response.bodyBytes);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PDFViewerPage(file: file),
      ),
    );
  }

  Future<void> _downloadPdf(String url, String filename) async {
    final http.Response response = await http.get(Uri.parse(url));
    final dir = await getApplicationDocumentsDirectory();
    final File file = File('${dir.path}/$filename');
    await file.writeAsBytes(response.bodyBytes);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('PDF downloaded successfully!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous preli qus'),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: pdfList.length,
        itemBuilder: (context, index) {
          final pdfData = pdfList[index];
          return Padding(
            padding: const EdgeInsets.only(left: 18.0,right: 18.0,top: 9.0,bottom: 9.0),
            child: Container(
              padding: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ),
              decoration: BoxDecoration(
                color: Color(0xFF6BAF7D),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: Icon(Icons.picture_as_pdf_sharp,color: Colors.white70,),
                title: Text(
                  pdfData['name'],
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onTap: () => _openPdfViewer(pdfData['url']),
                trailing: IconButton(
                  icon: Icon(Icons.download,color: Colors.white70,),
                  onPressed: () =>
                      _downloadPdf(pdfData['url'], pdfData['name']),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PDFViewerPage extends StatelessWidget {
  final File file;

  PDFViewerPage({required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practice this question'),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: PDFView(
        filePath: file.path,
      ),
    );
  }
}
