import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shirikisho/utils/WAColors.dart';

Widget summaryExplanationDialog() {
  // The bullet list data
  List<Map<String, String>> bulletList = [
    {
      'bolded': 'Notification',
      'unbolded':
          'This app requires notification permissions to keep you updated with important alerts. Please enable notifications in the app settings.',
    },
    {
      'bolded': 'Camera',
      'unbolded':
          'Camera permission is required to allow you to capture photos or videos directly from the app. Without this, features that involve media capture will not work. You can choose to allow now or later when you want to take pictures',
    },
    {
      'bolded': 'Photo',
      'unbolded':
          'Photo access allows the app to read and select images from your device\'s gallery. This is needed to upload or share images within the app.',
    },
    {
      'bolded': 'Storage',
      'unbolded':
          'Storage permission allows the app to save and retrieve data from your device\'s storage. This is essential for storing files like images, documents, and other content.',
    },
    {
      'bolded': 'Media Library',
      'unbolded':
          'Access to the media library is necessary to retrieve music, videos, and other media files stored on your device. This is important for apps that support media playback or file sharing.',
    }
  ];

  return StatefulBuilder(
    builder: (context, setState) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 1.0,
        child: Container(
          // height: 200,
          decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage('images/walletApp/wa_bg.jpg'),
            //   fit: BoxFit.cover,
            //   opacity: 0.2,
            // ),
            color: context.scaffoldBackgroundColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: defaultBoxShadow(),
          ),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.shield,
                        color: WAPrimaryColor,
                      ),
                      Text(
                        " Permission Request",
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(color: WAPrimaryColor, size: 18),
                      ),
                    ],
                  ),
                ),
                10.height,
                // Bullet list using ListView.builder
                ListView.builder(
                  shrinkWrap: true, // To prevent overflow
                  itemCount: bulletList.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = bulletList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• ",
                            textScaler: TextScaler.noScaling,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Flexible(
                            child: Text.rich(
                              textScaler: TextScaler.noScaling,

                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: item['bolded'],
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: " - ${item['unbolded']}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.clip, // Prevents overflow
                              // maxLines: 3, // Limits the text to 3 lines
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                10.height,

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text.rich(
                        textScaler: TextScaler.noScaling,

                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Note : ",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  " All these permission are important for smooth running of some application features you can choose to allow them now by pressing Accept button or later in App settings or when you try to access some service which require these permissions. ",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.clip, // Prevents overflow
                        // maxLines: 3, // Limits the text to 3 lines
                      ),
                    ),
                  ],
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        // await FirebaseMessaging.instance
                        //     .requestPermission(provisional: true);

                        // // Request permissions

                        // final notificationStatus =
                        //     await Permission.notification.request();

                        // if (notificationStatus.isGranted) {
                        //   print("Notification permission granted");
                        // } else if (notificationStatus.isPermanentlyDenied) {
                        //   print(
                        //       "Permission permanently denied. Redirecting to settings...");
                        //   openAppSettings();
                        // } else {
                        //   print("Notification permission denied");
                        // }

                        // await FirebaseMessaging.instance
                        //     .requestPermission(provisional: true);
                        // await Permission.notification.request();
                        await Permission.storage.request();
                        await Permission.photos.request();
                        await Permission.camera.request();
                        await Permission.mediaLibrary.request();

                        Navigator.pop(context);
                        // await delayedNavigatorPop(context, 3000);
                      },
                      child: Text(
                        "Accept",
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(color: WAPrimaryColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(color: WAPrimaryColor),
                      ),
                    ),
                  ],
                )
              ]),
            ),
          ),
        ),
      );
    },
  );
}
