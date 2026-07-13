import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../global/special_fun.dart';
import '../model/socialv/models/PostModel.dart';
import '../utils/SVCommon.dart';

class SVCommentComponent extends StatefulWidget {
  final PostCommentModule comment;

  SVCommentComponent({required this.comment});

  @override
  State<SVCommentComponent> createState() => _SVCommentComponentState();
}

class _SVCommentComponentState extends State<SVCommentComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                svCommonCachedNetworkImage(
                        widget.comment.profileImage.validate(),
                        height: 35,
                        width: 35,
                        fit: BoxFit.cover)
                    .cornerRadiusWithClipRRect(100),
                8.width,
                Text(widget.comment.name.validate(),
                    textScaler: TextScaler.noScaling,
                    style: boldTextStyle(size: 14)),
                4.width,
                Image.asset('assets/socialv/icons/verified.png',
                    height: 14, width: 14, fit: BoxFit.cover),
                4.width,
                Text(
                    '${timeAgoSinceDate(DateTime.parse(widget.comment.time.validate()))}',
                    textScaler: TextScaler.noScaling,
                    style:
                        secondaryTextStyle(color: svGetBodyColor(), size: 12)),
              ],
            ),
          ],
        ),
        // 16.height,
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Column(),
            ),
            Expanded(
              flex: 80,
              child: Text(widget.comment.comment.validate(),
                  textScaler: TextScaler.noScaling,
                  style: secondaryTextStyle(color: svGetBodyColor())),
            ),
            Expanded(
              flex: 5,
              child: Column(),
            ),
            Expanded(
                flex: 5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                widget.comment.like.validate()
                                    ? Image.asset(
                                        'assets/socialv/icons/ic_HeartFilled.png',
                                        height: 17,
                                        width: 17,
                                        fit: BoxFit.fill,
                                        color: Colors.red,
                                      )
                                    : Image.asset(
                                        'assets/socialv/icons/ic_Heart.png',
                                        height: 17,
                                        width: 17,
                                        fit: BoxFit.cover,
                                        color: svGetBodyColor(),
                                      ),
                                2.width,
                                Text(widget.comment.likeCount.toString(),
                                    textScaler: TextScaler.noScaling,
                                    style: secondaryTextStyle(size: 12)),
                              ],
                            ),
                          ]),
                    ).onTap(() {
                      widget.comment.like = !widget.comment.like.validate();
                      log(widget.comment.like);
                      setState(() {
                        if (widget.comment.like) {
                          likePostComment(widget.comment.id);
                          widget.comment.likeCount =
                              widget.comment.likeCount + 1;
                        } else {
                          unLikePostComment(widget.comment.id);
                          widget.comment.likeCount =
                              widget.comment.likeCount - 1;
                        }
                      });
                    }, borderRadius: radius(4)),
                  ],
                ))
          ],
        ),
      ],
    ).paddingOnly(
        top: 16,
        left: widget.comment.isCommentReply.validate() ? 70 : 16,
        right: 16,
        bottom: 16);
  }
}
