import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/model/socialv/models/PostModel.dart';

import '../../../../../main.dart';
import '../../component/SVCommentComponent.dart';
import '../../global/environment.dart';
import '../../utils/SVColors.dart';
import '../../utils/SVCommon.dart';
import '../../utils/WAColors.dart';

class CommentScreen extends StatefulWidget {
  final List<PostCommentModule>? comments;
  final int postId;

  const CommentScreen({Key? key, this.comments, required this.postId})
      : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<PostCommentModule> commentList = [];
  String _userImage = '';

  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    commentList = widget.comments!;
    super.initState();
    init();
    afterBuildCreated(() {
      setStatusBarColor(context.cardColor);
    });
  }

  init() async {
    final _storage = const FlutterSecureStorage();

    var user_image = await _storage.read(key: 'user_image');

    setState(() {
      _userImage = user_image!;
    });
  }

  @override
  void dispose() {
    setStatusBarColor(
        appStore.isDarkModeOn ? appBackgroundColorDark : SVAppLayoutBackground);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cardColor,
      appBar: AppBar(
        backgroundColor: context.cardColor,
        iconTheme: IconThemeData(color: context.iconColor),
        title: Text('Comments',
            textScaler: TextScaler.noScaling, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: widget.comments!.map((e) {
                  return SVCommentComponent(comment: e);
                }).toList(),
              ),
            ),
            bottomSheet: CommentReplyComponentIn(),
          ),
        ],
      ),
    );
  }

  Widget CommentReplyComponentIn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      color: svGetScaffoldColor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Divider(indent: 16, endIndent: 16, height: 20),
          Row(
            children: [
              16.width,
              svCommonCachedNetworkImage('${Environment.imageUrl}/$_userImage',
                      height: 48, width: 48, fit: BoxFit.cover)
                  .cornerRadiusWithClipRRect(8),
              10.width,
              Container(
                width: context.width() * 0.6,
                child: AppTextField(
                  textFieldType: TextFieldType.NAME,
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Andika maoni',
                    hintStyle: secondaryTextStyle(color: svGetBodyColor()),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  var _text = _commentController.text;
                  _commentController.text = '';
                  var ans = await sendComment(_text, widget.postId);
                  setState(() {
                    widget.comments?.insert(0, ans);
                  });
                },
                child: Text('Reply',
                    textScaler: TextScaler.noScaling,
                    style: secondaryTextStyle(color: SVAppColorPrimary)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
