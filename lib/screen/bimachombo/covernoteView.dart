import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shirikisho/utils/WAColors.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String name;

  const PdfViewerScreen({Key? key, required this.pdfUrl, required this.name})
      : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    _prepareAndLoadPdf();
  }

  Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
    
      status = await Permission.manageExternalStorage.request();
    }
    return status.isGranted;
  }

  Future<void> _prepareAndLoadPdf() async {
    bool hasPermission = await _requestStoragePermission();
    // print("Has permission: $hasPermission");
    if (hasPermission) {
      // await _downloadAndSavePdf();
      await _fetchAndDisplayPdf();
    } else {
      _showError("Storage permission is required to view the PDF.");
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (await Permission.storage.isGranted) {
      // print("checking permisson");

      return true;
    }

    // Request permission if not already granted
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // print("requesting permisson");

      return true;
    }

    // For Android 11+ check and request Manage External Storage permission
    if (Platform.isAndroid &&
        (await Permission.manageExternalStorage.isDenied)) {
      status = await Permission.manageExternalStorage.request();

      // print("requesting permisson 2");

      return status.isGranted;
    }

    return true;
  }

  Future<void> _fetchAndDisplayPdf() async {
    try {
      // Send GET request to fetch PDF
      final response = await http.post(Uri.parse(widget.pdfUrl));

      // print(
      //     "Response of PDF ${widget.pdfUrl}::  with code ${response.statusCode}");
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getTemporaryDirectory();
        final filePath = "${dir.path}/temp_pdf.pdf";

        // Save the file to the device
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        setState(() {
          localFilePath = filePath;
        });

        // print("PDF downloaded and saved to $filePath");
      } else {
        _showError(
            "Failed to download PDF. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // print("Error fetching PDF: $e");

      _showError("An error occurred while fetching the PDF.");
    }
  }

  Future<void> generateAndSavePdf(String tempPath) async {
    // Ensure the directory exists
    final directory = Directory('/storage/emulated/0/shirikisho/covernote');
    if (!(await directory.exists())) {
      await directory.create(recursive: true);
    }

    // Define the destination file path
    final filePath =
        "${directory.path}/${widget.name} Covernote${DateTime.now().millisecondsSinceEpoch}.pdf";

    try {
      // Copy the file from the current path to the new location
      final sourceFile = File(tempPath);
      final destinationFile = File(filePath);
      await sourceFile.copy(destinationFile.path);

      // Show success message
      toast(
        'PDF saved successfully at: $filePath',
        bgColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      // Handle errors
      // print('Error saving PDF: $e');
      toast(
        'Failed to save PDF',
        bgColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _showError(String message) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text(message)),
    // );

    toast(
      message,
      bgColor: Colors.red,
      textColor: Colors.white,
      gravity: ToastGravity.SNACKBAR,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(" ${widget.name} Covernote"),
        ),
        body: localFilePath == null
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: <Widget>[
                  PDFView(
                    filePath: localFilePath!,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: true,
                    pageFling: true,
                    onError: (error) {
                      _showError("Error loading PDF: $error");
                      // print("Error loading PDF: $error");
                    },
                    onPageError: (page, error) {
                      _showError("Error on page $page: $error");
                    },
                  ),
                  Positioned(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: WAPrimaryColor),
                        onPressed: () async {
                          if (await requestStoragePermission()) {
                            await generateAndSavePdf(localFilePath!);
                          } else {
                            toast('Storage permission denied');
                          }
                        },
                        child: Text(
                          "Download",
                          textScaler: TextScaler.noScaling,
                          style: boldTextStyle(size: 16, color: Colors.white),
                        )),
                    bottom: 20,
                    left: 10,
                  )
                ],
              ));
  }
}
