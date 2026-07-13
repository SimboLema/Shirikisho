import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shirikisho/utils/WAColors.dart'; // Angalia kama bado unahitaji hii

class QrScannerScreen extends StatefulWidget {
  static String tag = '/QrScannerScreen';

  @override
  QrScannerScreenState createState() => QrScannerScreenState();
}

class QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.light);
  }

  @override
  void dispose() {
    controller.dispose();
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.dark);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            key: qrKey,
            controller: controller,
            fit: BoxFit.cover,
            onDetect: (BarcodeCapture capture) {
              final String? data = capture.barcodes.first.rawValue;
              if (data != null) {
                log(data);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('QR Code: $data')),
                );
              }
            },
          ),
          Column(
            children: [
              30.height,
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(8),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ).onTap(() {
                  finish(context);
                }).paddingOnly(top: 8, right: 16),
              ),
              30.height,
              Text(
                'Tuliza QR Code ndani ya kiboxi',
                style: boldTextStyle(color: Colors.white, size: 18),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              width: 60,
              padding: EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: radius(30),
                backgroundColor: Colors.white,
              ),
              child: Icon(Icons.close, color: WAPrimaryColor),
            ).onTap(() {
              finish(context);
            }),
          ).paddingBottom(60),
        ],
      ),
    );
  }
}
