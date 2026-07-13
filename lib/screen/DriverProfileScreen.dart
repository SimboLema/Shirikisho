import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shirikisho/component/CustomInfoTile.dart';
import 'package:shirikisho/component/dialogues/HaririDialog.dart';
import 'package:shirikisho/model/drivers_modules.dart';
import 'package:shirikisho/screen/EditProfileScreen.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:shirikisho/utils/WAWidgets.dart';

import '../global/environment.dart';
import '../main.dart';
import '../services/auth_service.dart';
import '../services/post_apis.dart';
import '../store/profile_ob.dart';
import '../utils/styles.dart';
import 'LoginScreen.dart';

class DriverProfileScreen extends StatefulWidget {
  static String tag = '/DriverProfileScreen';

  final DriverDetailsModule driver;

  DriverProfileScreen({super.key,required this.driver});

  @override
  DriverProfileScreenState createState() => DriverProfileScreenState();
}

class DriverProfileScreenState extends State<DriverProfileScreen> {
  late AuthService authService;
  var profileImage = "";
  var userName = "";

  // DriverDetailsModule? driver = DriverDetailsModule();
  var phone = "";
  var avatar = "/office/media/avatars/300-1.jpg";
  bool? isDarkMode = true;

  ProfileOb pr_ob = ProfileOb();
  String? DriverImage;
  String? imagePath;

  bool _loadingState = false;
  String _errorText = '';

  late File imageFile;
  bool loadFromCamera = false;

  final PostMainApis _postMainApis = PostMainApis();


  final KishoStyles appStyles = KishoStyles();

  

  @override
  void initState() {
    authService = Provider.of<AuthService>(context, listen: false);

    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Taarifa za Dereva', style: boldTextStyle(color: Colors.black, size: 20)),
          leading: Container(
            margin: EdgeInsets.all(8),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: context.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Icon(Icons.arrow_back, color: appStore.isDarkModeOn ? white : black),
          ).onTap(() {
            finish(context);
          }),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Container(
          height: context.height(),
          width: context.width(),
          padding: EdgeInsets.only(top: 60),
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/walletApp/wa_bg.jpg'), fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Observer(
                        builder: (context) => GestureDetector(
                          onTap: () async {
                            if(IsLeader){
                              var HasImage = await getImage(ImageSource.camera);
                              if(HasImage){

                                print('sdsds');

                                _serviceLoader('Inapakia Picha');
                                var res = await _postMainApis.updateDriverImage(widget.driver.id,imageFile);

                                if(res == 'true'){
                                  Navigator.of(context).pop();
                                  toast('Picha Imepkiwa');
                                }

                                setState(() {
                                  _loadingState = false;
                                });
                              }
                            }

                          },
                          child: (loadFromCamera)
                              ? Image.file(
                                  File(imageFile.path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRect(60)
                              : Image.network(
                            '${Environment.imageUrl}/${widget.driver.imageId as String}',
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                ).cornerRadiusWithClipRRect(60),
                        ),
                      ),
                      editButton(),
                    ],
                  ),
                14.height,
                Text(widget.driver.firstName as String, style: boldTextStyle()),
                Text(widget.driver.phoneNumber as String, style: secondaryTextStyle()),

                15.height,
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.only(bottom: 10, left: 10, right: 16),
                  decoration: boxDecorationRoundedWithShadow(16, backgroundColor: context.cardColor),
                  child: ListTile(
                    tileColor: Colors.red,
                    enabled: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: boxDecorationWithRoundedCorners(
                        boxShape: BoxShape.circle,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                      child: Icon(Icons.perm_identity_sharp,
                        size: 24,
                        color: Color(0xFF26C884),
                      ),
                    ),
                    title: RichTextWidget(
                      list: [
                        TextSpan(
                          text: 'Jina Kamili',
                          style: boldTextStyle(size: 14, color: appStore.isDarkModeOn ? white : black),
                        ),
                      ],
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      '${widget.driver.firstName as String} ${widget.driver.middleName as String} ${widget.driver.lastName as String}',
                      style: primaryTextStyle(color: appStore.isDarkModeOn ? white : Colors.black54, size: 14),
                    ),

                  ),
                ).onTap(() {

                }),

                4.height,
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.only(bottom: 10, left: 10, right: 16),
                  decoration: boxDecorationRoundedWithShadow(16, backgroundColor: context.cardColor),
                  child: ListTile(
                    tileColor: Colors.red,
                    enabled: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: boxDecorationWithRoundedCorners(
                        boxShape: BoxShape.circle,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                      child: Icon(Icons.local_phone,
                        size: 24,
                        color: Color(0xFF26C884),
                      ),
                    ),
                    title: RichTextWidget(
                      list: [
                        TextSpan(
                          text: 'Namba Ya Simu',
                          style: boldTextStyle(size: 14, color: appStore.isDarkModeOn ? white : black),
                        ),
                      ],
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      widget.driver.phoneNumber as String,
                      style: primaryTextStyle(color: appStore.isDarkModeOn ? white : Colors.black54, size: 14),
                    ),

                  ),
                ),

                4.height,
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.only(bottom: 10, left: 10, right: 16),
                  decoration: boxDecorationRoundedWithShadow(16, backgroundColor: context.cardColor),
                  child: ListTile(
                    tileColor: Colors.red,
                    enabled: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: boxDecorationWithRoundedCorners(
                        boxShape: BoxShape.circle,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                      child: Icon(Icons.document_scanner_outlined,
                        size: 24,
                        color: Color(0xFF26C884),
                      ),
                    ),
                    title: RichTextWidget(
                      list: [
                        TextSpan(
                          text: 'Namba ya Leseni',
                          style: boldTextStyle(size: 14, color: appStore.isDarkModeOn ? white : black),
                        ),
                      ],
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      widget.driver.licenseNumber as String,
                      style: primaryTextStyle(color: appStore.isDarkModeOn ? white : Colors.black54, size: 14),
                    ),

                  ),
                ),
4.height,
                CustomInfoTile(
                  icon: Icons.motorcycle_outlined,
                  title: 'Namba ya Chombo',
                  subtitle: widget.driver.vehicle?.vehicle_number ?? '--',
                ),
                4.height,
                CustomInfoTile(
                  icon: Icons.dry_cleaning_outlined,
                  title: 'Namba ya Vazi',
                  subtitle: widget.driver.uniformId.toString() ?? '--',
                ),
                4.height,
                CustomInfoTile(
                  icon: Icons.location_on_outlined,
                  title: 'Kituo',
                  subtitle: widget.driver.parking_area?.name ?? '--',
                ),
                 4.height,
                CustomInfoTile(
                  icon: Icons.location_on_outlined,
                  title: 'Mkoa',
                  subtitle: widget.driver.parking_area?.ward?.district?.region?.name ?? '--',
                ),
                 4.height,
                CustomInfoTile(
                  icon: Icons.location_on_outlined,
                  title: 'Wilaya',
                  subtitle: widget.driver.parking_area?.ward?.district?.name ?? '--',
                ),
                 4.height,
                CustomInfoTile(
                  icon: Icons.location_on_outlined,
                  title: 'Kata',
                  subtitle: widget.driver.parking_area?.ward?.name ?? '--',
                ),
                
                
                14.height,
                errWigFun(_errorText),
                if(IsLeader)
                btnNLoader(_loadingState, context),
              ],

            ).paddingAll(16),
          ),
        ),
      ),
    );
  }


  Widget btnNLoader(bool lder, BuildContext context) {
    if (lder) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      );
    }
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => HaririDialog(driver: widget.driver),
        );
      },
      style: appStyles.defaultButtonStyles().copyWith(
          minimumSize:
          const MaterialStatePropertyAll(Size(double.infinity, 45))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(Symbols.edit),
          SizedBox(width: 10),
          Text('Hariri'),
        ],
      ),
    );
  }

  Widget errWigFun(String erv) {
    if (erv != '') {
      return Column(
        children: [
          Text(
            erv,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red, fontSize: 14),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Future getImage(ImageSource source) async {
    var image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      imageFile = File(image.path);
      loadFromCamera = true;
      setState(() {});
      return true;
    }
      return false;
  }

  Widget editButton(){
    if(IsLeader){
      return Positioned(
                        right: 0,
                        bottom: 8,
                        child: GestureDetector(
                          onTap: () async {
                            if(IsLeader){
                              var HasImage = await getImage(ImageSource.camera);
                              if(HasImage){

                                _serviceLoader('Inapakia Picha');
                                var res = await _postMainApis.updateDriverImage(widget.driver.id,imageFile);

                                if(res == 'true'){
                                  Navigator.of(context).pop();
                                  toast('Picha Imepkiwa');
                                }

                                setState(() {
                                  _loadingState = false;
                                });
                              }
                            }

                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.black.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.edit, color: white, size: 16),
                          ),
                        ),
                      );
    }
    return Column();
  }


  void _serviceLoader(text) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: context.scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                children: [
                  16.width,
                  CircularProgressIndicator(
                    backgroundColor: Color(0xffD6D6D6),
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                  ),
                  16.width,
                  Text(text, style: primaryTextStyle(color: appStore.textPrimaryColor),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

}
