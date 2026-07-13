import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shirikisho/model/WalletAppModel.dart';
import 'package:shirikisho/providers/MkopoManagementProvider.dart';
import 'package:shirikisho/services/auth_service.dart';
import 'package:shirikisho/utils/DataGenerator.dart';
import '../services/LatraScreen.dart';
import '../../component/ServicesComponent.dart';
import '../../main.dart';

class ServicesScreen extends StatefulWidget {
  static String tag = '/ServicesScreen';

  @override
  ServicesScreenState createState() => ServicesScreenState();
}

class ServicesScreenState extends State<ServicesScreen> {
  List<WAOperationsModel> operationsList = serviceList();
  late AuthService authService;

  var profileImage = "";
  var userName = "";
  var userImage = "";
  var phone = "";
  var avatar = "/office/media/avatars/300-1.jpg";
  var vyombo = [];
  @override
  void initState() {
    super.initState();
    authService = Provider.of<AuthService>(context, listen: false);
    Provider.of<Mkopomanagementprovider>(context, listen: false).getVehicles();
    Provider.of<Mkopomanagementprovider>(context, listen: false)
        .getVehicleBrands();

    getUserData();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> getUserData() async {
    setState(
      () {
        userName = authService.user.firstName!;
        userImage = authService.user.imageId!;
        phone = authService.user.phoneNumber!;

        log(userImage);
      },
    );
    // print("user image $userImage");
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(
            'Services',
            textScaler: TextScaler.noScaling,
            style: boldTextStyle(color: Colors.black, size: 20),
          ),
          // leading: Container(
          //   margin: EdgeInsets.all(8),
          //   decoration: boxDecorationWithRoundedCorners(
          //     backgroundColor: context.cardColor,
          //     borderRadius: BorderRadfius.circular(12),
          //     border: Border.all(color: Colors.grey.withOpacity(0.2)),
          //   ),
          //   child: Icon(Icons.arrow_back, color: appStore.isDarkModeOn ? white : black),
          // ).onTap(() {
          //   finish(context);
          // }),
          centerTitle: true,
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark),
      body: Container(
        height: context.height(),
        width: context.width(),
        padding: EdgeInsets.only(top: 80),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/walletApp/wa_bg.jpg'),
                fit: BoxFit.cover)),
        child: Container(
          margin: EdgeInsets.only(top: 30),
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(32), topLeft: Radius.circular(32)),
            backgroundColor: context.cardColor,
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,

                alignment: WrapAlignment.start,
                // crossAxisAlignment:WrapCrossAlignment.center,
                // runAlignment:WrapAlignment.center ,
                children: operationsList.map((item) {
                  return Container(
                    padding:
                        EdgeInsets.only(top: 16, bottom: 8, left: 8, right: 8),
                    decoration: boxDecorationRoundedWithShadow(16,
                        backgroundColor:
                            appStore.isDarkModeOn ? cardDarkColor : white),
                    alignment: AlignmentDirectional.center,
                    width: context.width() * 0.27,
                    child: ServicesComponent(
                      itemModel: item,
                    ),
                  ).onTap(() {
                    if (item.title == 'LATRA') {
                        LatraScreen().launch(context); // Replace LatraScreen() with your actual widget class name
                      }
                   else if (item.title == 'Vazi' ||
                        // item.title == 'BODASURE' ||
                        item.title == 'Bima ya Ajali'
                        ||
                        item.title == 'Bima ya Chombo'
                        
                        ) {
                      item.widget.launch(context);
                    } else {
                      toasty(context, 'Coming Soon');
                    }
                  });
                }).toList(),
              ).paddingAll(16),
            ),
          ),
        ),
      ),
    );
  }
}
