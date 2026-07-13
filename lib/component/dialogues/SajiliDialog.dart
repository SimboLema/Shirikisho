import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/screen/driver/OTPDriverScreen.dart';

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

class ApplicationDialog extends StatefulWidget {
  static String tag = '/ApplicationDialog';

  final Application? applicationModel;

  ApplicationDialog({super.key, this.applicationModel});

  @override
  ApplicationDialogState createState() => ApplicationDialogState();
}

class ApplicationDialogState extends State<ApplicationDialog> {
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


   var phoneFormatter = new MaskTextInputFormatter(
      mask: '#### ### ###',
      filter: { "#": RegExp(r'[0-9]'),"X": RegExp(r'[A-Z]') },
      type: MaskAutoCompletionType.lazy
  );


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
    var phone = _phoneNumberController.text.replaceAll(' ', '').substring(1);
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
        '+255$phone')) {
      setState(() {
        _errorText =
        'Namba ya simu sio sahihi tafadhali hakikisha. Na ujaribu tena';
      });
      return 0;
    }


    setState(() {
      _loadingState = true;
    });

    DriverPhoneVerificationResponseModule resp = await postMainApis.sendDriverPhoneForverification('255$phone');

    await _storage.write(key: 'driver_phone', value: '255$phone');
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
          SizedBox(height: 16.0),
          Text("Sajili Dereva", style: boldTextStyle(size: 20,color: WAPrimaryColor), textAlign: TextAlign.center),
          SizedBox(height: 16.0),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.topLeft,
            child: Text('Jina Kamili', style: secondaryTextStyle(size: 16, color: Colors.black)),
          ),
          AppTextField(
            decoration: waInputDecoration(hint: 'Felix Thobias Mgeni'),
            textFieldType: TextFieldType.NAME,
            keyboardType: TextInputType.text,
            textStyle: primaryTextStyle(color: appTextColorPrimary),
            controller: _fnameController,
            focus: nameFocusNode,
            nextFocus: phoneFocusNode,

          ),

          SizedBox(height: 16.0),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.topLeft,
            child: Text('Namba Ya Simu', style: secondaryTextStyle(size: 16, color: Colors.black)),
          ),
          AppTextField(
            decoration: waInputDecoration(hint: '0712******'),
            textFieldType: TextFieldType.NUMBER,
            keyboardType: TextInputType.phone,
            textStyle: primaryTextStyle(color: appTextColorPrimary),
            controller: _phoneNumberController,
            focus: phoneFocusNode,
            inputFormatters: [phoneFormatter],
            // nextFocus: passWordFocusNode,
          ),

          30.height,
          errWigFun(_errorText),
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
        sendContactForm();
      },
      style: appStyles.defaultButtonStyles().copyWith(
          minimumSize:
              const MaterialStatePropertyAll(Size(double.infinity, 45))),
      child: const Text('Sajili'),
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
}
