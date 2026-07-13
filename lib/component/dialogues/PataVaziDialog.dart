import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/services/get_apis.dart';

import '../../main.dart';
import '../../screen/home/PaymentScreen.dart';
import '../../screen/services/VaziMaipoScreen.dart';
import '../../utils/WAColors.dart';
import '../../utils/styles.dart';

class PataVaziDialog extends StatefulWidget {
  static String tag = '/PataVaziDialog';

  PataVaziDialog({super.key});

  @override
  PataVaziDialogState createState() => PataVaziDialogState();
}

class PataVaziDialogState extends State<PataVaziDialog> {

  var phoneFormatter = new MaskTextInputFormatter(
      mask: '#### ### ###',
      filter: { "#": RegExp(r'[0-9]'),"X": RegExp(r'[A-Z]') },
      type: MaskAutoCompletionType.lazy
  );

    final KishoStyles appStyles = KishoStyles();


  final GetMainApis _getMainApis = GetMainApis();


  var _loading = 0;
  var _loadingLicense = 0;
  var _licenseStatus = '';

  var _loadingLATRA = 0;
  var _licenseLATRAStatus = '';

  var _loadingMaegesho = 0;
  var _licenseMaegeshoStatus = '';

  var _loadingShirikisho = 0;
  var _licenseShirikishoStatus = '';




  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    checkLicense();
    checkLATRA();
  }

  verifyAll(){
    List _loaders = [_loadingLicense,_loadingLATRA,_loadingMaegesho,_loadingShirikisho];
    if(_loaders.contains(0) || _loaders.contains(2)){
      log('Badoo');
    }else{
      // Navigator.pop(context);
      // VaziMalipoScreen().launch(context);
      log('Tayariiii');
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String _errorText = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
    decoration: BoxDecoration(
      color: context.scaffoldBackgroundColor,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(10),
      boxShadow: defaultBoxShadow(),
    ),
    width: MediaQuery.of(context).size.width,
    //height: MediaQuery.of(context).size.height * 0.8,
    padding: EdgeInsets.all(16.0),
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          // SvgPicture.asset(t10_ic_otp, width: width * 0.25, height: width * 0.4, fit: BoxFit.fill),
          SizedBox(height: 16.0),
          Text("Tafadhali Subiri", style: boldTextStyle(size: 20,color: WAPrimaryColor), textAlign: TextAlign.center),
          SizedBox(height: 16.0),
          // Text("Tunaangalia...", style: boldTextStyle(color: appStore.textPrimaryColor,size: 16),),

          Divider(),
          SizedBox(height: 16.0),

          checkItems('Leseni Halali',1,_licenseStatus),

          SizedBox(height: 10.0),
          checkItems('Ada ya LATRA',2,_licenseLATRAStatus),

          SizedBox(height: 10.0),
          checkItems('Ada ya Maegesho',3,_licenseMaegeshoStatus),


          // SizedBox(height: 10.0),
          // checkItems('Ada ya Shirikisho',4,_licenseShirikishoStatus),

          // 30.height,
          errWigFun(_errorText),
          // btnNLoader(_loadingState, context),

          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          const SizedBox(height: 16.0),

          LipaBili(),
        ],
      ),
    ),
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

  Widget checkItems(String item,code, String loaderStatusMessage){
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Row(
          children: [
            16.width,
            SizedBox(
              height: 20.0,
              width: 20,
              child: _loaderStatus(code),
            ),
            16.width,
            Text(item, style: primaryTextStyle(color: appStore.textPrimaryColor,size: 16),),
          ],
          ),
          Row(
            children: [
          16.width,
          Text(loaderStatusMessage,style: primaryTextStyle(color: loaderStatusMessage != "Accepted" ? Colors.red: WAPrimaryColor,size: 9),textAlign: TextAlign.left,),

            ],
          )
        ],
      );
  }

  Future<bool> checkLicense() async {
    var response = await _getMainApis.verifyLicense1  ();
    if(response[0] == 200){
      setState((){
        _licenseStatus = response[1];
        _loadingLicense = 1;
      });
    }else{
      setState((){
        _licenseStatus = response[1];
        _loadingLicense = 2;
      });
    }

    verifyAll();
    return true;
  }

  bool checkLATRA(){
    Future.delayed(Duration(seconds: 2),(){
      setState((){
        _loadingLATRA = 1;
        _licenseLATRAStatus = 'Accepted';
      });
      verifyAll();
    });

    Future.delayed(Duration(seconds: 4),(){
      setState((){
        _loadingMaegesho = 2;
        _licenseMaegeshoStatus = 'Haijalipiwa';
      });
      verifyAll();
    });

    Future.delayed(Duration(seconds: 3),(){
      setState((){
        _loadingShirikisho = 1;
        _licenseShirikishoStatus = 'Accepted';
      });
      verifyAll();
    });

    return true;
  }

  Widget _loaderStatus(int code){
    var _currentLoader;
    switch (code){
      case 1:
        _currentLoader = _loadingLicense;
        break;

       case 2:
        _currentLoader = _loadingLATRA;
       break;

       case 3:
        _currentLoader = _loadingMaegesho;
       break;

       case 4:
        _currentLoader = _loadingShirikisho;
       break;

       default:
         _currentLoader = _loading;
    }

    if(_currentLoader == 0){
      return CircularProgressIndicator(
            backgroundColor: Color(0xffD6D6D6),
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(WAPrimaryColor),
          );
    }else if(_currentLoader == 2){
      return Icon(Icons.close, color: Colors.red);
    }else{
      return Icon(Icons.check, color: WAPrimaryColor);
    }
  }


  Widget LipaBili (){
    List _loaders = [_loadingLicense,_loadingLATRA,_loadingMaegesho,_loadingShirikisho];
    if(_loaders.contains(0)){
      return Text('Inahakiki ...');
    }else{
      if(_loaders.contains(2)) {
        return ElevatedButton(
            onPressed: () {
              // CameraExampleHome().launch(context);
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => PaymentScreen(),
              );
            },
            style: appStyles.defaultButtonStyles().copyWith(
                minimumSize: const MaterialStatePropertyAll(
                    Size(double.maxFinite, 45))),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Fanya Malipo'),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.east_rounded)
              ],
            ));
      }else{
        return ElevatedButton(
            onPressed: () {
              // CameraExampleHome().launch(context);
              // showDialog(
              //   barrierDismissible: false,
              //   context: context,
              //   builder: (BuildContext context) => PataVaziDialog(),
              // );
            },
            style: appStyles.defaultButtonStyles().copyWith(
                minimumSize: const MaterialStatePropertyAll(
                    Size(double.maxFinite, 45))),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Pata Vazi'),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.east_rounded)
              ],
            ));
      }
    }
  }
}
