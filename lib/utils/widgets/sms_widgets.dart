

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/utils/WAColors.dart';

import '../../global/special_fun.dart';
import '../../model/social/message_model.dart';

class ChatMessageWidget1 extends StatelessWidget {
  const ChatMessageWidget1({
    Key? key,
    required this.isMe,
    required this.data,
  }) : super(key: key);

  final bool isMe;
  final BHMessageModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isMe.validate() ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          margin: isMe.validate() ? EdgeInsets.only(top: 3.0, bottom: 3.0, right: 0, left: (500 * 0.25).toDouble()) : EdgeInsets.only(top: 4.0, bottom: 4.0, left: 0, right: (500 * 0.25).toDouble()),
          decoration: BoxDecoration(
            color: !isMe ? WAPrimaryColor : white,
            boxShadow: defaultBoxShadow(),
            borderRadius: isMe.validate()
                ? BorderRadius.only(bottomLeft: Radius.circular(10), topLeft: Radius.circular(10), topRight: Radius.circular(10))
                : BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(10)),
            border: Border.all(color: isMe ? Theme.of(context).dividerColor : Colors.transparent),
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: Text(data.msg!, style: primaryTextStyle(color: !isMe ? white : WAPrimaryColor))),
              Text(timeAgoSinceDate(DateTime.parse(data.time!)), style: secondaryTextStyle(color: !isMe ? white : textSecondaryColor, size: 12))
            ],
          ),
        ),
      ],
    );
  }


}


class GroupChatMessageWidget1 extends StatelessWidget {
  const GroupChatMessageWidget1({
    Key? key,
    required this.isMe,
    required this.data,
  }) : super(key: key);

  final bool isMe;
  final BHMessageModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isMe.validate() ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          margin: isMe.validate() ? EdgeInsets.only(top: 3.0, bottom: 3.0, right: 0, left: (500 * 0.25).toDouble()) : EdgeInsets.only(top: 4.0, bottom: 4.0, left: 0, right: (500 * 0.25).toDouble()),
          decoration: BoxDecoration(
            color: !isMe ? WAPrimaryColor : white,
            boxShadow: defaultBoxShadow(),
            borderRadius: isMe.validate()
                ? BorderRadius.only(bottomLeft: Radius.circular(10), topLeft: Radius.circular(10), topRight: Radius.circular(10))
                : BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(10)),
            border: Border.all(color: isMe ? Theme.of(context).dividerColor : Colors.transparent),
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              !isMe ?
              Flexible(child: Text(
                  '${data.senderName!}',
                  textAlign: TextAlign.start,
                  style: primaryTextStyle(color: !isMe ? Colors.yellow : white)
              )) : SizedBox(),
              Flexible(child: Text(data.msg!, style: primaryTextStyle(color: !isMe ? white : WAPrimaryColor))),
              Text(timeAgoSinceDate(DateTime.parse(data.time!)), style: secondaryTextStyle(color: !isMe ? white : textSecondaryColor, size: 12))
            ],
          ),
        ),
      ],
    );
  }


}