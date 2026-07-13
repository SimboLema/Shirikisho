import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/utils/WAColors.dart';

import '../../global/environment.dart';
import '../../model/drivers_modules.dart';
import '../../model/social/message_model.dart';
import '../../model/socialv/models/PostModel.dart';
import '../../services/chat_apis.dart';
import '../../utils/widgets/sms_widgets.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class GroupChattingScreen extends StatefulWidget {
  final int? id;
  final String? img;
  final String? name;
  final List<BHMessageModel>? messages;

  GroupChattingScreen({this.img, this.name, this.messages, this.id});

  @override
  _GroupChattingScreenState createState() => _GroupChattingScreenState();
}

class _GroupChattingScreenState extends State<GroupChattingScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController msgController = TextEditingController();
  FocusNode msgFocusNode = FocusNode();

  var sender_user_id;


  List<BHMessageModel> msgListing = [];
  var personName = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {

    var uu_id = await getUserId();
    setState(() {
      msgListing.clear();
      msgListing.addAll(widget.messages!);
      sender_user_id = uu_id;
    });

    connectPusher();


  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }


  sendClick() {
    DateFormat formatter = DateFormat('yyyy-MM-ddTkk:mm:ss');

    if (msgController.text.trim().isNotEmpty) {
      var msgModel = BHMessageModel();
      msgModel.msg = msgController.text.toString();
      msgModel.time = formatter.format(DateTime.now());
      msgModel.senderId = sender_user_id;
      hideKeyboard(context);
      msgListing.insert(0, msgModel);

      widget.messages?.insert(0, msgModel);

      SendMessage(msgController.text.toString(),sender_user_id,widget.id);

      msgController.text = '';

      if (mounted) scrollController.animToTop();
      // FocusScope.of(context).requestFocus(msgFocusNode);
      setState(() {});


      if (mounted) scrollController.animToTop();
    } else {
      // FocusScope.of(context).requestFocus(msgFocusNode);
    }

    setState(() {});
  }

  Future<void>? receiveMessage(event_name,data) {
    DateFormat formatter = DateFormat('yyyy-MM-ddTkk:mm:ss');

    log(data);

    if(event_name == '${widget.id}-group' && data['message']['sender']['user_id'] != sender_user_id){
      var msgModel = BHMessageModel();
      msgModel.msg = data['message']['text'];
      msgModel.time = formatter.format(DateTime.now());
      msgModel.senderId = data['message']['sender']['user_id'];
      msgModel.senderName= data['message']['sender']['user']['first_name'];
      msgListing.insert(0, msgModel);

      widget.messages?.insert(0, msgModel);

      saveMsgToFile();

      if (mounted) scrollController.animToTop();
      // FocusScope.of(context).requestFocus(msgFocusNode);
      setState(() {});


      if (mounted) scrollController.animToTop();

      reload();

      return null;
    }
    return null;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.6,
        leading: GestureDetector(
          onTap: () {
            finish(context);
          },
          child: Icon(Icons.arrow_back, color: WAPrimaryColor),
        ),
        title: Row(
          children: <Widget>[
            CircleAvatar(backgroundImage: CachedNetworkImageProvider(Uri.parse(widget.img!).isAbsolute ? widget.img! : '${Environment.imageUrl}/${widget.img!}'), radius: 16),
            8.width,
            Text(widget.name!, style: TextStyle(color: WAPrimaryColor, fontSize: 16)),
          ],
        ),
        // actions: [Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.call, color: WAPrimaryColor, size: 20))],
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
            decoration: BoxDecoration(color: white),
            child: ListView.separated(
              separatorBuilder: (_, i) => Divider(color: Colors.transparent),
              shrinkWrap: true,
              reverse: true,
              controller: scrollController,
              itemCount: msgListing.length,
              padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 70),
              itemBuilder: (_, index) {
                BHMessageModel data = msgListing[index];


                var isMe = data.senderId == sender_user_id;

                return GroupChatMessageWidget1(isMe: isMe, data: data);
                //return ChatMessageWidget(isMe: isMe, data: data);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              padding: EdgeInsets.only(left: 16),
              decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.all(Radius.circular(20)), backgroundColor: WAPrimaryColor),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: msgController,
                    focusNode: msgFocusNode,
                    autofocus: false,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration.collapsed(
                      hintText: personName.isNotEmpty ? 'Write to ${widget.name}' : 'Type something...',
                      hintStyle: primaryTextStyle(color: white),
                    ),
                    style: primaryTextStyle(color: white),
                    onSubmitted: (s) {
                      sendClick();
                    },
                  ).expand(),
                  IconButton(
                    icon: Icon(Icons.send, size: 20, color: white),
                    alignment: Alignment.center,
                    onPressed: () {
                      sendClick();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future connectPusher() async{
    PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

    void onConnectionStateChange(dynamic currentState, dynamic previousState) {
      log("Connection: $currentState");
    }

    void onError(String message, int? code, dynamic e) {
      log("onError: $message code: $code exception: $e");
    }

    void onEvent(PusherEvent event) {
      log("onEvent Details: ${event.eventName}");
      receiveMessage(event.eventName,jsonDecode(event.data));
    }

    void onSubscriptionSucceeded(String channelName, dynamic data) {
      // log("onSubscriptionSucceeded: $channelName data: $data");
      final me = pusher.getChannel(channelName)?.me;
      log("Me: $me");
    }

    void onSubscriptionError(String message, dynamic e) {
      log("onSubscriptionError: $message Exception: $e");
    }

    void onDecryptionFailure(String event, String reason) {
      log("onDecryptionFailure: $event reason: $reason");
    }

    void onMemberAdded(String channelName, PusherMember member) {
      log("onMemberAdded: $channelName user: $member");
    }

    void onMemberRemoved(String channelName, PusherMember member) {
      log("onMemberRemoved: $channelName user: $member");
    }

    void onSubscriptionCount(String channelName, int subscriptionCount) {
      log("onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
    }

    dynamic onAuthorizer(String channelName, String socketId, dynamic options) {
    return {
      "auth": "foo:bar",
      "channel_data": '{"user_id": 1}',
      "shared_secret": "foobar"
    };
  }

    try {
      await pusher.init(
        apiKey: '0e863b3515907a2dff62',
        cluster: 'eu',
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        // authEndpoint: "<Your Authendpoint>",
        // onAuthorizer: onAuthorizer
      );
      await pusher.subscribe(channelName: 'my-channel');
      await pusher.connect();

    } catch (e) {
      print("ERROR: $e");
    }

    print(pusher.connectionState);

  }

  Future<void> reload() async {
    await loadGroups();
    await loadPosts(null);
    await loadOnlineConversation();
    await loadOfficers();
  }

  void saveMsgToFile() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Encode and store data in SharedPreferences
    final String encodedData = BHMessageModel.encode(widget.messages!);

    await prefs.setString('musics_key', encodedData);

    // Fetch and decode data
    final String? msgString = await prefs.getString('musics_key');

    final List<BHMessageModel> musics = BHMessageModel.decode(msgString!);
}
}
