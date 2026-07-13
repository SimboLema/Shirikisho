import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shirikisho/utils/WAColors.dart';

class PDFScreen extends StatefulWidget {
  final String? path;
  final String? name;

  PDFScreen({Key? key, this.path, this.name}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      // status = await Permission.accessMediaLocation.request();
      // status = await Permission.storage.request();
      // st = await Permission.storage.request();
      status = await Permission.manageExternalStorage.request();
    }
    return status.isGranted;
  }

  Future<void> generateAndSavePdf() async {
    // Ensure the directory exists
    final directory = Directory('/storage/emulated/0/shirikisho');
    if (!(await directory.exists())) {
      await directory.create(recursive: true);
    }

    // Define the destination file path
    final filePath =
        "${directory.path}/${widget.name} ${DateTime.now().millisecondsSinceEpoch}.pdf";

    try {
      // Copy the file from the current path to the new location
      final sourceFile = File(widget.path!);
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

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.path!),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            
          
          fitEachPage: true,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            // backgroundColor: Colors.black,
          
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              // print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              // print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              // print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              // print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                ),
          Positioned(
            child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: WAPrimaryColor),
                onPressed: () async {
                  if (await requestStoragePermission()) {
                    await generateAndSavePdf();
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
      ),
      // floatingActionButton: FutureBuilder<PDFViewController>(
      //   future: _controller.future,
      //   builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
      //     if (snapshot.hasData) {
      //       return FloatingActionButton.extended(
      //         label: Text("Go to ${pages! ~/ 2}"),
      //         onPressed: () async {
      //           await snapshot.data!.setPage(pages! ~/ 2);
      //         },
      //       );
      //     }

      //     return Container();
      //   },
      // ),
    );
  }
}
