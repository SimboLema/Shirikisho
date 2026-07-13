import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shirikisho/utils/WAColors.dart';

class PdfViewerScreen extends StatefulWidget {
  final String fileUrl;
  final String fileName;

  const PdfViewerScreen(
      {Key? key, required this.fileUrl, required this.fileName})
      : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  // Function to download PDF
  Future<void> _downloadPdf() async {
    try {
      // Download the file from the URL
      var response = await http.get(Uri.parse(widget.fileUrl));
      var bytes = response.bodyBytes;

      print("downloading fuile ::  $response");

      // Get the local path to store the file
      var dir = await getApplicationDocumentsDirectory();
      File file = File('${dir.path}/${widget.fileName}');

      // Save the PDF file locally
      await file.writeAsBytes(bytes, flush: true);

      setState(() {
        localFilePath = file.path; // Set the local file path
      });
    } catch (e) {
      print("Error downloading PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: localFilePath != null
          ? PDFView(
              filePath: localFilePath,
            )
          : Center(
              child: CircularProgressIndicator(
                color: WAPrimaryColor,
              ), // Show a loader while downloading
            ),
    );
  }
}
