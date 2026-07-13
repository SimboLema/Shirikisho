import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../global/environment.dart';
import '../../../../utils/SVCommon.dart';
import '../../../../utils/SVConstants.dart';

class SVPostOptionsComponent extends StatefulWidget {
  @override
  State<SVPostOptionsComponent> createState() => _SVPostOptionsComponentState();
}

class _SVPostOptionsComponentState extends State<SVPostOptionsComponent> {
  List<String> list = [
    '$OldBaseUrl/images/socialv/posts/post_one.png',
    '$OldBaseUrl/images/socialv/posts/post_two.png',
    '$OldBaseUrl/images/socialv/posts/post_three.png',
    '$OldBaseUrl/images/socialv/postImage.png'
  ];

  PickedFile? pickImage;
  String fileName = '', filePath = '';

  Future getImage() async {
    pickImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickImage != null) {
      fileName = pickImage!.path.split('/').last;
      filePath = pickImage!.path;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: svGetScaffoldColor(),
        borderRadius: radiusOnly(topRight: SVAppContainerRadius, topLeft: SVAppContainerRadius),
      ),
      child: Column(
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

                HorizontalList(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return svCommonCachedNetworkImage(list[index], height: 62, width: 52, fit: BoxFit.cover);
                  },
                )
              ],
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Image.asset('assets/socialv/icons/ic_Video.png', height: 32, width: 32, fit: BoxFit.cover),
          //     Image.asset('assets/socialv/icons/ic_Voice.png', height: 32, width: 32, fit: BoxFit.cover),
          //     Image.asset('assets/socialv/icons/ic_Location.png', height: 32, width: 32, fit: BoxFit.cover),
          //     Image.asset('assets/socialv/icons/ic_Paper.png', height: 32, width: 32, fit: BoxFit.cover),
          //   ],
          // ),
        ],
      ),
    );
  }


}
