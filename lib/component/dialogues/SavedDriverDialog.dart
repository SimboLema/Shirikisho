import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/screen/driver/OTPDriverScreen.dart';
import 'package:shirikisho/screen/home/HomeScreen.dart';

import '../../global/special_fun.dart';
import '../../main.dart';
import '../../model/application_model.dart';
import '../../model/drivers_modules.dart';
import '../../screen/home/DashboardScreen.dart';
import '../../screen/driver/RegisterDriverScreen.dart';
import '../../services/Extensions.dart';
import '../../services/post_apis.dart';
import '../../services/show_alert.dart';
import '../../utils/WAColors.dart';
import '../../utils/WAWidgets.dart';
import '../../utils/styles.dart';

class SavedDriverDialog extends StatefulWidget {
  static String tag = '/SavedDriverDialog';

  final Application? applicationModel;

  SavedDriverDialog({super.key, this.applicationModel});

  @override
  SavedDriverDialogState createState() => SavedDriverDialogState();
}

class SavedDriverDialogState extends State<SavedDriverDialog> {
  var plan;
  var duration;

  var amountController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();


  FocusNode nameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();

  KishoStyles appStyles = KishoStyles();

  final PostMainApis postMainApis = PostMainApis();

  final _storage = const FlutterSecureStorage();




  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  //Validte

  bool _loadingState = false;
  String _errorText = '';

  Future<int> sendContactForm() async {
    setState(() {
      _errorText = '';
    });
    // validate info from the form
    if (!hasThreeNames(_fnameController.text)) {
      setState(() {
        _errorText = 'Hakikisha umeweka majina yote matatu';
      });
      return 0;
    } else if (!isValidPhoneNumber(
        '+255${_phoneNumberController.text.substring(1)}')) {
      setState(() {
        _errorText =
        'Namba ya simu sio sahihi tafadhali hakikisha. Na ujaribu tena';
      });
      return 0;
    }


    setState(() {
      _loadingState = true;
    });

    DriverPhoneVerificationResponseModule resp = await postMainApis.sendDriverPhoneForverification('255${_phoneNumberController.text.substring(1)}');

    await _storage.write(key: 'driver_phone', value: '255${_phoneNumberController.text.substring(1)}');
    await _storage.write(key: 'driver_name', value: _fnameController.text);

    if (resp.state != 'success') {
      setState(() {
        _loadingState = false;
        _errorText = resp.data;
      });
      return 0;
    }

    log(resp.state);

    setState(() {
      _loadingState = false;
    });

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => OTPDriverScreen(),
        ),
            (route) => false,
      );

    return 1;
  }

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
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              // SvgPicture.asset(t10_ic_otp, width: width * 0.25, height: width * 0.4, fit: BoxFit.fill),

              successImage(),
              30.height,
              // Icon(Icons.check),

              Text('Hongera Umefanikiwa Kumsajili Dereva', style: primaryTextStyle(size: 17, color: Colors.black),textAlign: TextAlign.center,),

              30.height,

              btnNLoader(_loadingState, context),

              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              const SizedBox(height: 16.0),
            ],
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
              color: WAPrimaryColor,
            ),
          )
        ],
      );
    }
    return ElevatedButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        WADashboardScreen().launch(context);
      },
      style: appStyles.defaultButtonStyles().copyWith(
          minimumSize:
              const MaterialStatePropertyAll(Size(double.infinity, 45))),
      child: const Text('Sawa'),
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

  Widget successImage() {
    return Image.asset(
      'assets/images/success.png',
      width: 100,
      height: 100,
      fit: BoxFit.fill,
    );
  }
}
