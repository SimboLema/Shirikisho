import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shirikisho/component/WAOperationComponent.dart';
import 'package:shirikisho/component/WATransactionComponent.dart';
import 'package:shirikisho/component/dialogues/HakikiDialog.dart';
import 'package:shirikisho/component/dialogues/SajiliOptionDialog.dart';
import 'package:shirikisho/model/WalletAppModel.dart';
import 'package:shirikisho/screen/MyProfileScreen.dart';
import 'package:shirikisho/screen/mafisa/MaafisaScreen.dart';
import 'package:shirikisho/utils/DataGenerator.dart';
import 'package:shirikisho/utils/WAColors.dart';

import '../../component/MalipoComponent.dart';
import '../../component/dialogues/SajiliDialog.dart';
import '../../global/environment.dart';
import '../../main.dart';
import '../../services/auth_service.dart';
import '../../utils/widgets/mikopo_banner.dart';
import '../../utils/widgets/widgets.dart';

class WAHomeScreen extends StatefulWidget {
  static String tag = '/WAHomeScreen';

  @override
  WAHomeScreenState createState() => WAHomeScreenState();
}

class WAHomeScreenState extends State<WAHomeScreen> {
  late AuthService authService;

  var userName = "";
  var userPhone = "";
  var userJacket = "";
  var userImage = "";
  var isAdmin = false;
  var avatar = "/office/media/avatars/300-1.jpg";
  var uniformSubscription = false;

  List<WACardModel> cardList = waCardList();
  List<WAOperationsModel> operationsList = waOperationList();
  List<WATransactionModel> transactionList = waTransactionList();

  List<WABillPayModel> billPayList = [];
  List<WABillPayModel> hudumaPayList = govPayList();

  int currentIndexPage = 0;
  int? pageLength;
  final _storage = const FlutterSecureStorage();

  Future<void> getUserData() async {
    authService.getUser();

    var name = await _storage.read(key: 'user_name');
    var phone = await _storage.read(key: 'user_phone');
    var uniform = await _storage.read(key: 'user_uniform_number');
    var image = await _storage.read(key: 'user_image');
    var isLeader = await _storage.read(key: 'user_is_leader');
    var activeSubStr = await _storage.read(key: 'user_active_subscription');

    // var token = await _storage.read(key: "token");

    // print("token is $token");
    setState(
      () {
        userName = name!;
        userPhone = phone!;
        userImage = image!;
        userJacket = uniform!;
        isAdmin = isLeader! == 'true' ? true : false;
        uniformSubscription = activeSubStr! == 'true' ? true : false;
      },
    );

    billPayList.addAll(uratibuList());
  }

  @override
  void initState() {
    super.initState();
    authService = Provider.of<AuthService>(context, listen: false);
    getUserData();
    init();
  }

  Future<void> init() async {
    currentIndexPage = 0;
    pageLength = 3;
    // await Permission.storage.request();
    // await Permission.photos.request();
    // await Permission.camera.request();
    // await Permission.mediaLibrary.request();
    // await Permission.manageExternalStorage.request();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 250,
              floating: false,
              pinned: true,
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              backgroundColor: innerBoxIsScrolled ? Colors.white : Colors.white,
              actionsIconTheme: IconThemeData(opacity: 0.0),
              title: Container(
                  padding: EdgeInsets.fromLTRB(16, 42, 16, 32),
                  margin: EdgeInsets.only(bottom: 8, top: 8),
                  child: GestureDetector(
                    onTap: () {
                      WAMyProfileScreen().launch(context);
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              '${Environment.imageUrl}/$userImage'),
                          backgroundColor: Colors.white,
                          radius: 24,
                        ),
                        10.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Habari, $userName",
                                  textScaler: TextScaler.noScaling,
                                  style: primaryTextStyle(color: Colors.black),
                                ),
                                4.width,
                                isAdmin == true
                                    ? Image.asset(
                                        'assets/socialv/icons/verified.png',
                                        height: 14,
                                        width: 14,
                                        fit: BoxFit.cover)
                                    : SizedBox(),
                              ],
                            ),
                            Text(
                              '$userJacket',
                              textScaler: TextScaler.noScaling,
                              style: primaryTextStyle(
                                color: Colors.orange,
                                size: 10,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ).expand(),
                        Icon(Icons.notifications, size: 30, color: Colors.black)
                      ],
                    ),
                  )),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topLeft,
                          colors: <Color>[
                            WAPrimaryColor.withOpacity(0.3),
                            Colors.white
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 110, 16, 8),
                      padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: defaultBoxShadow(),
                        backgroundColor: Colors.grey.shade100,
                      ),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.grey.shade300,
                            height: 120,
                            child: PageView(
                              children: [
                                TopCard(
                                    name: "Mikopo",
                                    acno: "TZS 0",
                                    item1: "Jumla",
                                    item2: "Baki",
                                    bal: "TZS 0"),
                                TopCard(
                                    name: "Malipo ya Serikali",
                                    item1: "Maegesho",
                                    item2: "LATRA",
                                    acno: "TZS 0",
                                    bal: "TZS 0"),
                                TopCard(
                                    name: "Bima",
                                    acno: "TZS 0",
                                    item1: "Chombo",
                                    item2: "Afya",
                                    bal: "TZS 0"),
                              ],
                              onPageChanged: (value) {
                                setState(() => currentIndexPage = value);
                              },
                            ),
                          ),
                          8.height,
                          Align(
                            alignment: Alignment.center,
                            child: DotsIndicator(
                              dotsCount: 3,
                              position: currentIndexPage,
                              decorator: DotsDecorator(
                                size: Size.square(8.0),
                                activeSize: Size.square(8.0),
                                color: appShadowColorDark,
                                activeColor: WAPrimaryColor,
                              ),
                            ),
                          ),
                          // 10.height,
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Container(
                          //       padding: EdgeInsets.only(top: 8, bottom: 8),
                          //       decoration: boxDecorationWithRoundedCorners(
                          //         backgroundColor: WAPrimaryColor,
                          //         borderRadius: BorderRadius.circular(8),
                          //       ),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Icon(Icons.payment, color: appColorPrimaryLight, size: 24),
                          //           10.width,
                          //           Text('Payment', style: boldTextStyle(color: appColorPrimaryLight)),
                          //         ],
                          //       ),
                          //     ).expand(),
                          //     10.width,
                          //     Container(
                          //       padding: EdgeInsets.only(top: 8, bottom: 8),
                          //       decoration: boxDecorationWithRoundedCorners(
                          //         backgroundColor: WAPrimaryColor,
                          //         borderRadius: BorderRadius.circular(8),
                          //       ),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Icon(Icons.notifications, size: 30, color: WAPrimaryColor),
                          //           10.width,
                          //           Text('Transfer', style: boldTextStyle(color: appColorPrimaryLight)),
                          //         ],
                          //       ),
                          //     ).expand(),
                          //   ],
                          // ).paddingAll(16)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ];
        },
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Uratibu',
                        style: boldTextStyle(size: 17, color: Colors.black)),
                  ],
                ).paddingOnly(left: 16, right: 16),
                Container(
                  width: context.width(),
                  decoration: boxDecorationRoundedWithShadow(16,
                      backgroundColor: context.cardColor),
                  padding: EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: billPayList.map((item) {
                      return Container(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 8, right: 8),
                        decoration: boxDecorationRoundedWithShadow(16,
                            backgroundColor:
                                appStore.isDarkModeOn ? cardDarkColor : white),
                        alignment: AlignmentDirectional.center,
                        width: context.width() * 0.25,
                        child: WAOperationComponent(
                          itemModel: item,
                          isApplyColor: true,
                        ),
                      ).onTap(() {
                        if (item.title == 'Sajili')
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) =>
                          //       ApplicationDialog(),
                          // );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                SajiliOptionDialog(),
                          );

                        if (item.title == 'Hakiki')
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => HakikiDialog(
                              uniformSubscription: uniformSubscription,
                            ),
                          );

                        if (item.title == 'Maafisa')
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => MaafiisaScreen(),
                          );
                      });
                    }).toList(),
                  ),
                ),
                16.height,
                const MikopoBannerHome(),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Malipo ya Serikali',
                        style: boldTextStyle(size: 17, color: black)),
                    // Icon(Icons.play_arrow, color: Colors.grey).onTap(() {
                    //   WAOperatorsScreen().launch(context);
                    // }),
                  ],
                ).paddingOnly(left: 16, right: 16),
                Container(
                  width: context.width(),
                  decoration: boxDecorationRoundedWithShadow(16,
                      backgroundColor: context.cardColor),
                  padding: EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: hudumaPayList.map((item) {
                      return Container(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 8, right: 8),
                        decoration: boxDecorationRoundedWithShadow(16,
                            backgroundColor:
                                appStore.isDarkModeOn ? cardDarkColor : white),
                        alignment: AlignmentDirectional.center,
                        width: context.width() * 0.25,
                        child: MalipoComponent(
                          itemModel: item,
                          isApplyColor: true,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Miamala',
                        style: boldTextStyle(size: 17, color: black)),
                    // Icon(Icons.play_arrow, color: Colors.grey),
                  ],
                ).paddingOnly(left: 16, right: 16),
                16.height,
                Column(
                  children: transactionList.map((transactionItem) {
                    return WATransactionComponent(
                        transactionModel: transactionItem);
                  }).toList(),
                ).paddingOnly(bottom: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<WABillPayModel> uratibuList() {
    List<WABillPayModel> list = [];
    if (isAdmin)
      list.add(WABillPayModel(
          title: 'Sajili',
          color: WAPrimaryColor,
          image: 'assets/images/add_user.png'));

    list.add(WABillPayModel(
        title: 'Hakiki',
        color: WAPrimaryColor,
        image: 'assets/images/verify.png'));
    list.add(WABillPayModel(
        title: 'Maafisa',
        color: WAPrimaryColor,
        image: 'assets/images/members.png'));
    return list;
  }
}
