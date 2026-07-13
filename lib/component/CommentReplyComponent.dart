import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../global/environment.dart';
import '../model/socialv/models/PostModel.dart';
import '../utils/SVColors.dart';
import '../utils/SVCommon.dart';

class CommentReplyComponent extends StatefulWidget {
  final TextEditingController _cont;
  final int postId;
  final List<PostCommentModule>? comments;

  CommentReplyComponent( this._cont, this.comments,this.postId, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommentReplyComponentState();
}


class _CommentReplyComponentState extends State<CommentReplyComponent> {

  @override
  Widget build(BuildContext context) {
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
              svCommonCachedNetworkImage('$OldBaseUrl/image'
                  's/socialv/faces/face_5.png', height: 48, width: 48, fit: BoxFit.cover).cornerRadiusWithClipRRect(8),
              10.width,
              Container(
                width: context.width() * 0.6,
                child: AppTextField(
                  textFieldType: TextFieldType.OTHER,
                  controller: widget._cont
                  ,
                  decoration: InputDecoration(
                    hintText: 'Andika maoni',
                    hintStyle: secondaryTextStyle(color: svGetBodyColor()),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
              TextButton(onPressed: () async {
                var ans = await  sendComment(widget._cont.text,widget.postId);
                widget._cont.text = '';
                setState(() {
                  widget.comments?.add(ans);
                });
              }, child: Text('Reply', style: secondaryTextStyle(color: SVAppColorPrimary)))
            ],
          ),
        ],
      ),
    );
  }
}
