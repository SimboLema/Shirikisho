import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';

import '../../../../main.dart';
import '../../../model/socialv/models/PostModel.dart';
import '../../../services/show_alert.dart';
import '../../../utils/SVColors.dart';
import '../../../utils/SVCommon.dart';
import '../../../utils/WAColors.dart';

class SVAddPostFragment extends StatefulWidget {
  const SVAddPostFragment({Key? key}) : super(key: key);

  @override
  State<SVAddPostFragment> createState() => _SVAddPostFragmentState();
}

class _SVAddPostFragmentState extends State<SVAddPostFragment> {
  String image = '';
  PickedFile? pickImage;
  String fileName = '', filePath = '';

  PickedFile? pickVideo;
  String videoName = '', videoPath = '';
  VideoPlayerController? _videoPlayerController;
  bool isVideoPlay = false;

  TextEditingController postTextController = TextEditingController();

  Future getVideo() async {
    pickVideo = await ImagePicker().getVideo(source: ImageSource.gallery);

    if (pickVideo != null) {
      videoName = pickVideo!.path.split('/').last;
      videoPath = pickVideo!.path;
      _videoPlayerController = VideoPlayerController.file(File(pickVideo!.path));
            pickImage = null;
            filePath = '';
      _videoPlayerController!.initialize().then(
        (value) {
          setState(() {
            _videoPlayerController!.pause();
          });
        },
      );
    }
  }

  Future getImage() async {
    pickImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickImage != null) {
      fileName = pickImage!.path.split('/').last;
      filePath = pickImage!.path;

        pickVideo = null;
        videoPath = '';
      setState(() {
      });
    }
  }


  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(context.cardColor);
    });
  }

  @override
  void dispose() {
    setStatusBarColor(appStore.isDarkModeOn ? appBackgroundColorDark : WAPrimaryColor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cardColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.iconColor),
        backgroundColor: context.cardColor,
        title: Text('New Post', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        actions: [
          AppButton(
            shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
            text: 'Post',
            textStyle: secondaryTextStyle(color: Colors.white, size: 10),
            onTap: () async {
              if(validate() == true) {
                _onHorizontalLoading1();
                final postResponse = await uploadPost(postTextController.text,File(videoPath != '' ? videoPath : filePath));

                if (postResponse[0] == 201 ){
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }else{
                  Navigator.of(context).pop();
                  showAlert(context, 'Shida ya mtandao',
                  'Hakikisha post na picha au file vimejazwa.');
                }
              }else{
                showAlert(context, 'Post haijakamilika',
                  'Hakikisha post na picha au file vimejazwa.');
              }

            },
            elevation: 0,
            color: SVAppColorPrimary,
            width: 50,
            padding: EdgeInsets.all(0),
          ).paddingAll(16),
        ],
      ),
      body: SingleChildScrollView(
        // height: context.height(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
                children: [
                  PostText(),
                  10.height,
                  FilePlace(),
                  FilePost(),
                ]
            ),


              // Positioned(
              //   child: FilePost(),
              //   bottom: 10,
              // ),
          ],
        ),
      ),
      floatingActionButton: pickVideo != null
            ? FloatingActionButton(
                backgroundColor: appColorPrimary,
                onPressed: () {
                  isVideoPlay ? _videoPlayerController!.pause() : _videoPlayerController!.play();
                  isVideoPlay = !isVideoPlay;
                  setState(() {});
                },
                child: isVideoPlay ? Icon(Icons.pause, color: Colors.white) : Icon(Icons.play_arrow_sharp, color: Colors.white),
              )
            : null,
    );
  }


  // Future getVideo() async {
  //   pickImage = (await ImagePicker().pickVideo(source: ImageSource.gallery)) as PickedFile?;
  //   if (pickImage != null) {
  //     fileName = pickImage!.path.split('/').last;
  //     filePath = pickImage!.path;
  //     setState(() {});
  //   }
  // }


  Widget FilePlace(){
    if (pickVideo != null){
      return  Container(
        height: 500,
        width: context.width() * 0.9,
        child: AspectRatio(
          child: VideoPlayer(_videoPlayerController!),
          aspectRatio: _videoPlayerController!.value.aspectRatio,
        ),
      ).center();
    }
    if(pickImage != null){
      return Container(
        height: 500,
        width: context.width() * 0.9,
        child: Image.file(File(pickImage!.path), fit: BoxFit.cover),
      ).center();
    }

    return 10.height;
  }




  Widget FilePost(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  child: Container(
                    height: 62,
                    width: 52,
                    color: context.cardColor,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Image.asset('assets/socialv/icons/ic_CameraPost.png', height: 22, width: 22, fit: BoxFit.cover),
                  ),
                  onTap: () async {
                    await getImage();
                  }
                ),
                10.width,
                GestureDetector(
                  child: Container(
                    height: 62,
                    width: 52,
                    color: context.cardColor,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Image.asset('assets/socialv/icons/ic_Video.png', height: 22, width: 22, fit: BoxFit.cover),
                  ),
                  onTap: () async {
                    await getVideo();
                  }
                ),

              ],
            ),
          ),
        ],
      );
  }

  Widget PostText() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: radius(12)),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: postTextController,
        autofocus: false,
        maxLines: 4,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Whats On Your Mind',
          hintStyle: secondaryTextStyle(size: 12, color: svGetBodyColor()),
        ),
      ),
    );
  }

   validate(){
          if(postTextController.text.length < 1){
            setState(
                  () {
                // _postTextError = true;
              },
            );
            return false;
          }

          if(filePath == '' && pickVideo == ''){
            setState(
                  () {
                // _postFileError = true;
              },
            );
            return false;
          }

          return true;
  }

  void _onHorizontalLoading1() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: context.scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                    "Please Wait....",
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
