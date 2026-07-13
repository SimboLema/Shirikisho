import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shirikisho/global/smsColors.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

// import 'package:vimeo_video_player/vimeo_video_player.dart';

import '../../global/environment.dart';
import '../../global/special_fun.dart';
import '../../main.dart';
import '../../model/WalletAppModel.dart';
import '../../model/drivers_modules.dart';
import '../../model/social/message_model.dart';
import '../../model/socialv/models/PostModel.dart';
import '../../utils/DataGenerator.dart';
import '../../utils/SVCommon.dart';
import '../../utils/SVConstants.dart';
import '../sms/GroupChattingScreen.dart';
import 'CommentScreen.dart';
import 'addPost/AddPostFragment.dart';
import 'group/createNewConvScreen.dart';
import 'group/createNewGroupScreen.dart';

class ChatScreen extends StatefulWidget {
  static String tag = "/ChatScreen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var phoneNumberController = TextEditingController();
  var accountNumberController = TextEditingController();
  var accountNameNumberController = TextEditingController();

  final String _vimeoVideoUrl = 'https://player.vimeo.com/video/841319969';

  bool? isChecked12 = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidInitializationSettings? androidInitializationSettings;
  DarwinInitializationSettings? iosInitializationSettings;
  late InitializationSettings initializationSettings;

  // final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  List<MessageListModel> groupsList = [];
  List<MessageListModel> convList = [];

  List<PostModel> postsList = [];
  List<DriverDetailsModule> officesList = [];

  //Online
  List<MessageListModel> messageList = getMessageList();

  List<mitandaoModel> miandaoList = mitandaoList();

  String? dropdownHuduma = null;

  var phoneFormatter = new MaskTextInputFormatter(
      mask: '#### ### ###',
      filter: {"#": RegExp(r'[0-9]'), "X": RegExp(r'[A-Z]')},
      type: MaskAutoCompletionType.lazy);

  var accountFormatter = new MaskTextInputFormatter(
      mask: '#############',
      filter: {"#": RegExp(r'[0-9]'), "X": RegExp(r'[A-Z]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    changeStatusColor(appStore.scaffoldBackground!);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    _groupPagingController.addPageRequestListener((pageKey) {
      _fetchGroupsPage(pageKey);
    });

    _conversationPagingController.addPageRequestListener((pageKey) {
      _fetchConversationsPage(pageKey);
    });

    super.initState();
    Timer.periodic(Duration(seconds: 30), (Timer t) {
      _conversationPagingController.refresh();
      _groupPagingController.refresh();
    });
    // refresh();
    // init();

    initPermission();
  }

  init() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = const DarwinInitializationSettings();
    initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    List<MessageListModel> userGroups = await loadGroups();
    List<MessageListModel> userConv = await loadConversation();

    List<DriverDetailsModule> officers = await loadOfficers();

    setState(() {
      groupsList.clear();
      groupsList.addAll(userGroups);

      convList.clear();
      convList.addAll(userConv);

      officesList.clear();
      officesList.addAll(officers);
    });
  }

  //Conversations
  final PagingController<String, MessageListModel>
      _conversationPagingController = PagingController(firstPageKey: '');
  var _conversationsPageSize = 30;

  Future<void> _fetchConversationsPage(String pageKey) async {
    try {
      var res = await loadOnlineConversationN(pageKey);
      final newItems = res[0];
      final isLastPage = newItems.length < _conversationsPageSize;
      if (isLastPage) {
        _conversationPagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = res[2];
        _conversationPagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _conversationPagingController.error = error;
      log(error);
    }
  }

  // Groups
  final PagingController<String, MessageListModel> _groupPagingController =
      PagingController(firstPageKey: '');
  var _groupPageSize = 30;

  Future<void> _fetchGroupsPage(String pageKey) async {
    try {
      var res = await loadOnlineGroupsN(pageKey);
      final newItems = res[0];
      final isLastPage = newItems.length < _groupPageSize;
      if (isLastPage) {
        _groupPagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = res[2];
        _groupPagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _groupPagingController.error = error;
      log(error);
    }
  }

  //Posts
  final PagingController<String, PostModel> _pagingController =
      PagingController(firstPageKey: '');
  void changeStatusColor(Color color) async {
    setStatusBarColor(color);
  }

  var _pageSize = 3;
  var _nextPageKey = null;

  Future<void> _fetchPage(String pageKey) async {
    try {
      var res = await loadOnlinePosts(pageKey);
      final newItems = res[0];
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = res[2];
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
      log(error);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> initPermission() async {
    // passwordController.text = 'password12345';

    // Request permission
    // await FirebaseMessaging.instance.requestPermission(provisional: true);

    // Check if notification permission is granted
    PermissionStatus permissionStatus = await Permission.notification.status;

    if (!permissionStatus.isGranted) {
      print("Permission not granted :: $permissionStatus");
      await FirebaseMessaging.instance.requestPermission(provisional: true);
      await Permission.notification.request();

      // If permission is not granted, show dialog
      // _showPermissionDialog();
    }

    // final notificationStatus = await Permission.notification.request();

    // if (notificationStatus.isGranted) {
    //   print("Notification permission granted");
    // } else if (notificationStatus.isPermanentlyDenied) {
    //   print("Permission permanently denied. Redirecting to settings...");
    //   openAppSettings();
    // } else {
    //   print("Notification permission denied");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: appStore.appBarColor,
            // iconTheme: IconThemeData(color: context.iconColor),
            title: TabBar(
              onTap: (index) {
                print(index);
              },
              labelStyle: primaryTextStyle(),
              indicatorColor: WAPrimaryColor,
              physics: BouncingScrollPhysics(),
              labelColor: appStore.textPrimaryColor,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_outlined,
                        color: WAPrimaryColor,
                      ),
                      5.width,
                      Text(
                        'Social',
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.groups_outlined,
                        color: WAPrimaryColor,
                      ),
                      5.width,
                      Text(
                        'Chat',
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.badge_outlined,
                        color: WAPrimaryColor,
                      ),
                      5.width,
                      Text(
                        'Groups',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Posts
              Container(
                // padding: EdgeInsets.all(16),
                // alignment: Alignment.center,
                width: context.width(),
                child: Scaffold(
                  body: RefreshIndicator(
                    onRefresh: () => Future.sync(
                      () => _pagingController.refresh(),
                    ),
                    child: PagedListView<String, PostModel>.separated(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<PostModel>(
                        itemBuilder: (context, item, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 1),
                            margin: EdgeInsets.symmetric(vertical: 3),
                            decoration: BoxDecoration(
                                borderRadius: radius(SVAppCommonRadius),
                                color: context.cardColor),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        svCommonCachedNetworkImage(
                                          '${Environment.imageUrl}/${item.profileImage.validate()}',
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        ).cornerRadiusWithClipRRect(100),
                                        8.width,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(item.name.validate(),
                                                    style: boldTextStyle()),
                                                4.width,
                                                Image.asset(
                                                    'assets/socialv/icons/verified.png',
                                                    height: 14,
                                                    width: 14,
                                                    fit: BoxFit.cover),
                                              ],
                                            ),
                                            Text(item.address.validate(),
                                                style: boldTextStyle(
                                                    size: 10,
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      ],
                                    ).paddingSymmetric(horizontal: 16),
                                    Row(
                                      children: [
                                        Text(
                                            '${timeAgoSinceDate(DateTime.parse(item.time.validate()))}',
                                            style: secondaryTextStyle(
                                                color: svGetBodyColor(),
                                                size: 12)),
                                        // IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
                                      ],
                                    ).paddingSymmetric(horizontal: 8),
                                  ],
                                ),
                                10.height,
                                item.description.validate().isNotEmpty
                                    ? svRobotoText(
                                            text: item.description.validate(),
                                            textAlign: TextAlign.start)
                                        .paddingSymmetric(horizontal: 16)
                                    : Offstage(),
                                item.description.validate().isNotEmpty
                                    ? 16.height
                                    : Offstage(),
                                item.type == 'video'
                                    ? AspectRatio(
                                        aspectRatio: item.aspect_ratio != null
                                            ? item.aspect_ratio!
                                            : 1,
                                        child: Container(
                                          color: Colors.black,
                                          height: 250,
                                          child: VimeoPlayer(
                                            videoId: item.postImage.validate(),
                                          ),
                                        ),
                                      )
                                    // VimeoVideoPlayer(
                                    //   url: _vimeoVideoUrl,
                                    //   autoPlay: true,
                                    // )
                                    : svCommonCachedNetworkImage(
                                        '${Environment.imageUrl}/${item.postImage.validate()}',
                                        height: 450,
                                        width: context.width() - 32,
                                        fit: BoxFit.cover,
                                      )
                                        .cornerRadiusWithClipRRect(
                                            SVAppCommonRadius)
                                        .center(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/socialv/icons/ic_Chat.png',
                                          height: 22,
                                          width: 22,
                                          fit: BoxFit.cover,
                                          color: context.iconColor,
                                        ).onTap(() {
                                          CommentScreen(
                                                  postId: item.id,
                                                  comments: item.comments)
                                              .launch(context);
                                        },
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent),
                                        IconButton(
                                          icon: item.like.validate()
                                              ? Image.asset(
                                                  'assets/socialv/icons/ic_HeartFilled.png',
                                                  height: 20,
                                                  width: 22,
                                                  fit: BoxFit.fill,
                                                  color: Colors.red,
                                                )
                                              : Image.asset(
                                                  'assets/socialv/icons/ic_Heart.png',
                                                  height: 22,
                                                  width: 22,
                                                  fit: BoxFit.cover,
                                                  color: context.iconColor,
                                                ),
                                          onPressed: () {
                                            item.like = !item.like.validate();
                                            item.like.validate()
                                                ? likePost(item.id)
                                                : unLikePost(item.id);
                                            item.like.validate()
                                                ? item.all_likes++
                                                : item.all_likes--;
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                        '${item.all_comments.validate()} comments',
                                        style: secondaryTextStyle(
                                            color: svGetBodyColor())),
                                  ],
                                ).paddingSymmetric(horizontal: 16),
                                // Divider(indent: 16, endIndent: 16, height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    10.width,
                                    RichText(
                                      text: TextSpan(
                                        text: '${item.all_likes} likes',
                                        style: secondaryTextStyle(
                                            color: svGetBodyColor(), size: 12),
                                        // children: <TextSpan>[
                                        //   TextSpan(text: 'Ms.Mountain ', style: boldTextStyle(size: 12)),
                                        //   TextSpan(text: 'And ', style: secondaryTextStyle(color: svGetBodyColor(), size: 12)),
                                        //   TextSpan(text: '${item.all_likes}', style: boldTextStyle(size: 12)),
                                        // ],
                                      ),
                                    )
                                  ],
                                ).paddingLeft(10),
                                // Divider(indent: 16, endIndent: 16, height: 20),
                              ],
                            ),
                          );
                        },
                        noMoreItemsIndicatorBuilder: (_) {
                          return Text('Post zimeisha!',
                                  style: secondaryTextStyle(
                                      color: svGetBodyColor()))
                              .paddingLeft(20);
                        },
                      ),
                      separatorBuilder: (context, index) => const Divider(
                        thickness: 0.4,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: WAPrimaryColor,
                    onPressed: () {
                      SVAddPostFragment().launch(context);
                    },
                    child: Icon(Icons.add, color: white),
                  ),
                ),
              ),

              // Messages
              Container(
                padding: EdgeInsets.all(16),
                // alignment: Alignment.center,
                width: context.width(),
                child: Scaffold(
                  body: RefreshIndicator(
                    onRefresh: () => Future.sync(
                      () => _conversationPagingController.refresh(),
                    ),
                    child: PagedListView<String, MessageListModel>(
                      pagingController: _conversationPagingController,
                      builderDelegate:
                          PagedChildBuilderDelegate<MessageListModel>(
                        itemBuilder: (context, chatItem, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: boxDecorationWithShadow(
                                    decorationImage: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            '${Environment.imageUrl}/${chatItem.img!}'),
                                        fit: BoxFit.cover),
                                    boxShape: BoxShape.circle,
                                  ),
                                ),
                                16.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            '${chatItem.senderName!} ${chatItem.senderLastName!}',
                                            style: boldTextStyle(
                                                color: t14_colorBlue,
                                                size: 14)),
                                        Icon(Entypo.dot_single,
                                            color: chatItem.isActive!
                                                ? Colors.green
                                                : Colors.transparent,
                                            size: 35),
                                      ],
                                    ),
                                    Text(chatItem.message!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: secondaryTextStyle(
                                            color: t14_colorBlue, size: 12)),
                                  ],
                                ).expand(),
                                Text(
                                    timeAgoSinceDate(
                                        DateTime.parse(chatItem.lastSeen!)),
                                    style: secondaryTextStyle(
                                        color: t14_colorBlue, size: 12)),
                              ],
                            ),
                          ).onTap(() {
                            int? id = chatItem.id;
                            String? img = chatItem.img;

                            GroupChattingScreen(
                                    img: img,
                                    name:
                                        '${chatItem.senderName!} ${chatItem.senderLastName!}',
                                    messages: chatItem.messages,
                                    id: id)
                                .launch(context);
                          });
                        },
                      ),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: WAPrimaryColor,
                    onPressed: () async {
                      CreateNewConvScreenScreen().launch(context);
                    },
                    child: Icon(Icons.chat_outlined, color: white),
                  ),
                ),
              ),

              // Groups
              Container(
                padding: EdgeInsets.all(16),
                // alignment: Alignment.center,
                width: context.width(),
                child: Scaffold(
                  body: RefreshIndicator(
                    onRefresh: () => Future.sync(
                      () => _groupPagingController.refresh(),
                    ),
                    child: PagedListView<String, MessageListModel>(
                      pagingController: _groupPagingController,
                      builderDelegate:
                          PagedChildBuilderDelegate<MessageListModel>(
                        itemBuilder: (context, item, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: boxDecorationWithShadow(
                                    decorationImage: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            item.img!),
                                        fit: BoxFit.cover),
                                    boxShape: BoxShape.circle,
                                  ),
                                ),
                                16.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(item.name!,
                                            style: boldTextStyle(
                                                color: t14_colorBlue,
                                                size: 14)),
                                        Icon(Entypo.dot_single,
                                            color: item.isActive!
                                                ? Colors.green
                                                : Colors.transparent,
                                            size: 35),
                                      ],
                                    ),
                                    Text(item.message!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: secondaryTextStyle(
                                            color: t14_colorBlue, size: 12)),
                                  ],
                                ).expand(),
                                Text(
                                    timeAgoSinceDate(
                                        DateTime.parse(item.lastSeen!)),
                                    style: secondaryTextStyle(
                                        color: t14_colorBlue, size: 12)),
                              ],
                            ),
                          ).onTap(() {
                            GroupChattingScreen(
                                    img: item.img,
                                    name: item.name,
                                    messages: item.messages,
                                    id: item.id)
                                .launch(context);
                          });
                        },
                      ),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: WAPrimaryColor,
                    onPressed: () {
                      CreteNewGroupScreen().launch(context);
                      // ShowCreateGroupBottomSheet(context,officesList);
                      // _mBottomSheet6();
                    },
                    child: Icon(Icons.group_add, color: white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _mBottomSheet6() {
    showModalBottomSheet(
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.2,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return Container(
              color: context.cardColor,
              padding: EdgeInsets.symmetric(vertical: 16),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.group_add,
                          color: appStore.iconColor,
                          size: 50,
                        ),
                        8.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Crete new Group',
                              style: primaryTextStyle(size: 20),
                            ),
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.security)
                      ],
                    ).paddingSymmetric(horizontal: 16),
                    Divider(),
                    16.height,
                    ...List.generate(
                      officesList.length,
                      (index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Card(
                            elevation: 4,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor:
                                    appStore.textPrimaryColor,
                              ),
                              child: CheckboxListTile(
                                value: isChecked12,
                                checkColor: appStore.appBarColor,
                                secondary: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                      '${Environment.imageUrl}/${officesList[index].imageId}',
                                    )),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                onChanged: (checked) {
                                  setState(() {
                                    isChecked12 = checked;
                                  });
                                },
                                title: Text(
                                  officesList[index].firstName!,
                                  style: boldTextStyle(size: 18),
                                ),
                                subtitle: Text(
                                  'Custom Leading value ',
                                  style: secondaryTextStyle(),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Color> color1 = [
    Colors.green,
    Colors.deepOrange,
    darkGreen,
    Colors.yellow,
    Colors.teal,
    navy,
    greenColor,
    Colors.brown,
  ];

  Future<void> buildSingleNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'Channel ID',
      'Channel title',
      priority: Priority.high,
      importance: Importance.max,
      icon: "app_icon",
      channelShowBadge: true,
      largeIcon: DrawableResourceAndroidBitmap("app_icon"),
    );

    NotificationDetails notificationDetail =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'New Notification', 'New User send Message', notificationDetail);
  }
}
