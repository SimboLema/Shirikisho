import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_better_camera/camera.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import '../services/post_apis.dart';

class CameraScreen extends StatefulWidget {
  static String tag = '/CameraScreen';

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  String? imagePath;
  late String videoPath;
  VideoPlayerController? videoController;
  late VoidCallback videoPlayerListener;
  bool enableAudio = true;
  FlashMode flashMode = FlashMode.off;

  List<CameraDescription> cameras = [];

  final PostMainApis _postMainApis = PostMainApis();
  bool isPosting = false;

  final _storage = const FlutterSecureStorage();

  FindCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();

      assignCamera();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }
  }

  assignCamera() {
    if (cameras.isEmpty) {
      log('No camera found');
    } else {
      for (CameraDescription cameraDescription in cameras) {
        log(cameraDescription.lensDirection);
        if (cameraDescription.lensDirection == CameraLensDirection.back) {
          onCameraOpened(cameraDescription);
          return;
        }
      }
    }
  }

  void onCameraOpened(CameraDescription? cameraDescription) async {
    controller = CameraController(
      cameraDescription!,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
    );

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    FindCamera();

    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text('Top Up to Card',
                style: boldTextStyle(color: Colors.black, size: 20)),
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: context.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Icon(Icons.arrow_back,
                  color: appStore.isDarkModeOn ? white : black),
            ).onTap(() {
              finish(context);
            }),
            centerTitle: true,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark),
        body: Container(
          height: context.height(),
          width: context.width(),
          padding: EdgeInsets.only(top: 60),
          decoration: BoxDecoration(
              color: context.cardColor,
              image: DecorationImage(
                  image: AssetImage('images/walletApp/wa_bg.jpg'),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                16.height,
                Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: AspectRatio(
                          aspectRatio: 3 / 4, child: _cameraPreviewWidget()),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 40),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset('assets/images/face.png',
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
                16.height,
                SizedBox(
                  width: context.width() * 0.5,
                  child: AppButton(
                      text: "Piga Picha",
                      color: WAPrimaryColor,
                      textColor: Colors.white,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      width: context.width(),
                      onTap: () {
                        _isTakingPhoto();
                        takePicture().then((String? filePath) async {
                          await controller!.dispose();
                          if (mounted) {
                            setState(() {
                              imagePath = filePath;
                              videoController?.dispose();
                              videoController = null;
                              isPosting = true;
                            });
                            if (filePath != null) {
                              var image_id = await _postMainApis.postProfile(
                                  '0785008133', File(imagePath!));
                              // showInSnackBar('Picture saved to $filePath');

                              await _storage.write(
                                  key: 'image_path', value: filePath);
                              await _storage.write(
                                  key: 'image_id', value: '$image_id');

                              Navigator.pop(context, '$image_id');
                              Navigator.pop(context, [filePath, image_id]);
                            }
                          }
                        });
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller!.value.isInitialized!) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller!.value.aspectRatio,
        child: CameraPreview(controller!),
      );
    }
  }

  IconData getCameraLensIcon(CameraLensDirection? direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      case null:
      // TODO: Handle this case.
    }
    throw ArgumentError('Unknown lens direction');
  }

  void logError(String code, String? message) =>
      print('Error: $code\nError Message: $message');

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    // _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(message)));
    toast(message);
  }

  void toogleAutoFocus() {
    // The CameraController does not support toggling autofocus directly.
    // You may implement autofocus logic here if supported by your camera plugin.
    showInSnackBar('Autofocus toggle not supported.');
  }

  Future<String?> takePicture() async {
    if (!controller!.value.isInitialized!) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller!.value.isTakingPicture!) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await controller!.takePicture();
      await file.saveTo(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  _isTakingPhoto() {
    if (isPosting == false) {
      return _loader();
    }
  }

  void _loader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.all(0.0),
          content: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              children: [
                16.width,
                CircularProgressIndicator(
                  backgroundColor: Color(0xffD6D6D6),
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                ),
                16.width,
                Text(
                  "Inapakia Picha....",
                  style: primaryTextStyle(color: appStore.textPrimaryColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ZoomableWidget extends StatefulWidget {
  final Widget? child;
  final Function? onZoom;
  final Function? onTapUp;

  const ZoomableWidget({Key? key, this.child, this.onZoom, this.onTapUp})
      : super(key: key);

  @override
  _ZoomableWidgetState createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget> {
  Matrix4 matrix = Matrix4.identity();
  double zoom = 1;
  double prevZoom = 1;
  bool showZoom = false;
  Timer? t1;

  bool handleZoom(newZoom) {
    if (newZoom >= 1) {
      if (newZoom > 10) {
        return false;
      }
      setState(() {
        showZoom = true;
        zoom = newZoom;
      });

      if (t1 != null) {
        t1!.cancel();
      }

      t1 = Timer(Duration(milliseconds: 2000), () {
        setState(() {
          showZoom = false;
        });
      });
    }
    widget.onZoom!(zoom);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onScaleStart: (scaleDetails) {
          print('scalStart');
          setState(() => prevZoom = zoom);
          //print(scaleDetails);
        },
        onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
          var newZoom = (prevZoom * scaleDetails.scale);

          handleZoom(newZoom);
        },
        onScaleEnd: (scaleDetails) {
          print('end');
          //print(scaleDetails);
        },
        onTapUp: (TapUpDetails det) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final Offset localPoint = box.globalToLocal(det.globalPosition);
          final Offset scaledPoint =
              localPoint.scale(1 / box.size.width, 1 / box.size.height);
          // TODO IMPLIMENT
          // widget.onTapUp(scaledPoint);
        },
        child: Stack(children: [
          Column(
            children: <Widget>[
              Container(
                child: Expanded(
                  child: widget.child!,
                ),
              ),
            ],
          ),
          Visibility(
            visible: showZoom, //Default is true,
            child: Positioned.fill(
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        valueIndicatorTextStyle: TextStyle(
                            color: Colors.amber,
                            letterSpacing: 2.0,
                            fontSize: 30),
                        valueIndicatorColor: Colors.blue,
                        // This is what you are asking for
                        inactiveTrackColor: Color(0xFF8D8E98),
                        // Custom Gray Color
                        activeTrackColor: Colors.white,
                        thumbColor: Colors.red,
                        overlayColor: Color(0x29EB1555),
                        // Custom Thumb overlay Color
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 20.0),
                      ),
                      child: Slider(
                        value: zoom,
                        onChanged: (double newValue) {
                          handleZoom(newValue);
                        },
                        label: "$zoom",
                        min: 1,
                        max: 10,
                      ),
                    ),
                  ),
                ],
              )),
            ),
            //maintainSize: bool. When true this is equivalent to invisible;
            //replacement: Widget. Defaults to Sizedbox.shrink, 0x0
          )
        ]));
  }
}
