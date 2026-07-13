import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/component/dialogues/ProfileDialog.dart';
import 'package:shirikisho/component/dialogues/TaarifaChomboDialog.dart';
import 'package:shirikisho/model/bima/chombo_verify_model.dart';
import 'package:shirikisho/screen/QrScannerScreen.dart';
import 'package:shirikisho/services/bima_chombo_apis.dart';
import 'package:shirikisho/services/get_apis.dart';

import '../../global/special_fun.dart';
import '../../model/drivers_modules.dart';
import '../../screen/DriverProfileScreen.dart';
import '../../services/post_apis.dart';
import '../../utils/WAColors.dart';
import '../../utils/WAWidgets.dart';
import '../../utils/styles.dart';

class HakikiDialog extends StatefulWidget {
  static String tag = '/HakikiDialog';
  bool uniformSubscription;

  HakikiDialog({super.key, required this.uniformSubscription});

  @override
  HakikiDialogState createState() => HakikiDialogState();
}

class HakikiDialogState extends State<HakikiDialog> {
  var plan;
  var duration;

  var amountController = TextEditingController();
  final TextEditingController _vaziController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();

  FocusNode vaziFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();

  KishoStyles appStyles = KishoStyles();

  final PostMainApis postMainApis = PostMainApis();
  final GetMainApis getMainApis = GetMainApis();

  final BimaChomboApis bimaMainApis = BimaChomboApis();

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

  String _selectedOption = '';

  late MotorVerificationRes response_data;

  var maskFormatter = new MaskTextInputFormatter(
      mask: 'XXX-##-##-###',
      filter: {"#": RegExp(r'[0-9]'), "X": RegExp(r'[A-Z]')},
      type: MaskAutoCompletionType.lazy);

  var phoneFormatter = new MaskTextInputFormatter(
      mask: '#### ### ###',
      filter: {"#": RegExp(r'[0-9]'), "X": RegExp(r'[A-Z]')},
      type: MaskAutoCompletionType.lazy);

  Future<int> sendHakikiForm() async {
    var phone = _phoneNumberController.text.replaceAll(' ', '').substring(1);
    setState(() {
      _errorText = '';
    });

    if (!isValidPhoneNumber('+255$phone')) {
      log(phone);
      setState(() {
        _errorText =
            'Namba ya simu sio sahihi tafadhali hakikisha. Na ujaribu tena';
      });
      return 0;
    }

    setState(() {
      _loadingState = true;
    });

    DriverDetailsModule resp =
        await getMainApis.findDriver('phone', '255$phone');

    print("DEREVA HAKIKI ${resp}");

    if (resp.id != null) {
      setState(() {
        _loadingState = false;
      });
      Navigator.pop(context);
      DriverProfileScreen(
        driver: resp,
      ).launch(context);
    }

    setState(() {
      _errorText =
          'Namba ya vazi haijathibitishwa, tafadhali fanya malipo ya TZS 2,000';
    });

    setState(() {
      _loadingState = false;
    });

    return 1;
  }

  Future<void> sendHakikiVaziForm() async {
    String rawPhone = _phoneNumberController.text.trim();

    if (rawPhone.isEmpty) {
      setState(() {
        _errorText = 'Tafadhali weka namba ya malipo';
      });
      return;
    }

    var phone = _phoneNumberController.text.replaceAll(' ', '').substring(1);
    setState(() {
      _errorText = '';
      _loadingState = true;
    });

    if (!isValidPhoneNumber('+255$phone')) {
      log(phone);
      setState(() {
        _errorText =
            'Namba ya simu sio sahihi tafadhali hakikisha. Na ujaribu tena';
        _loadingState = false;
      });
      return;
    }

    setState(() {
      _loadingState = true;
    });

    try {
      Map<String, dynamic> resp =
          await getMainApis.hakikiVazi('255$phone', null);

      if (resp['status'] == 'success') {
        // Success message
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 60),
                  SizedBox(height: 16),
                  Text(
                    'Hakiki Imefanikiwa',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Namba ya vazi imehakikiwa kwa mafanikio.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // funga hii dialog
                        Navigator.pop(context, true); // funga ProfileDialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        setState(() {
          // _errorText = resp['message'] ?? 'Kuna tatizo katika uhakiki.';
          _errorText = (resp['message'] != null &&
                  resp['message'].toLowerCase() == 'processing')
              ? 'Tafadhali jaribu tena, hakikisha unaweka namba ya siri kukamilisha malipo mapema.'
              : (resp['message'] ?? 'Kuna tatizo katika malipo.');
        });
      }
    } catch (e) {
      setState(() {
        _errorText = 'Kuna tatizo la mtandao au seva.';
      });
    } finally {
      setState(() {
        _loadingState = false;
      });
    }
  }

  Future hakikiChombo(String vehicleReg) async {
    setState(() {
      _loadingState = true;
    });

    print("plate number $vehicleReg");

    var res = await bimaMainApis.verifyChombo(vehicleReg);

    if (res['status'] == 'success') {
      // print("print success");

      setState(() {
        _loadingState = false;
      });
      Navigator.pop(context);
      // DriverProfileScreen(driver: resp,).launch(context);
      showDialog(
          context: context,
          barrierColor: Colors.transparent,
          useRootNavigator: true,
          builder: (BuildContext context) =>
              chomboSummaryDialog(context, res['data']));

      // print("Data  ${res['data']}");
    } else if (res['status'] == 'fail') {
      setState(() {
        _errorText = 'Namba ya chombo Haipo';
      });
      setState(() {
        _loadingState = false;
      });
    } else {
      setState(() {
        _errorText =
            'Samahani tumeshindwa kuhakika chombo, tafadhali Jaribu tena baadae';
      });
      setState(() {
        _loadingState = false;
      });
    }
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
              SizedBox(height: 16.0),
              _selectedOption == 'hakiki_vazi'
                  ? Text("Malipo ya Namba",
                      style: boldTextStyle(size: 20, color: WAPrimaryColor),
                      textAlign: TextAlign.center)
                  : Text("Hakiki Dereva",
                      style: boldTextStyle(size: 20, color: WAPrimaryColor),
                      textAlign: TextAlign.center),
              SizedBox(height: 16.0),
              menuView('', context),
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

  Widget menuView(String selected, BuildContext context) {
    if (_selectedOption == 'vazi') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 16.0),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.topLeft,
            child: Text('Namba ya Vazi',
                style: secondaryTextStyle(size: 16, color: Colors.black)),
          ),
          AppTextField(
            decoration: waInputDecoration(hint: 'TMK-24-53-001'),
            textFieldType: TextFieldType.NAME,
            keyboardType: TextInputType.name,
            textStyle: primaryTextStyle(color: appTextColorPrimary),
            controller: _vaziController,
            focus: vaziFocusNode,
            nextFocus: phoneFocusNode,
            inputFormatters: [maskFormatter],
            textCapitalization: TextCapitalization.characters,
            onChanged: (text) {
              setState(
                () {
                  _errorText = '';
                },
              );
            },
            onTap: () {
              setState(
                () {
                  _errorText = '';
                },
              );
            },
          ),
          30.height,
          errWigFun(_errorText),
          if (_errorText != '' && _errorText != 'Driver Not Found')
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _loadingState = true;
                });

                DriverDetailsModule response =
                    await getMainApis.findDriver('vazi1', _vaziController.text);

                if (response.id != null) {
                  setState(() {
                    _loadingState = false;
                  });
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierColor: Colors.black.withOpacity(0.3),
                    builder: (ctx) => ProfileDialog(driver: response),
                  );
                }

                setState(() {
                  _errorText = response.message ?? 'Namba ya vazi Haipo';
                });

                setState(() {
                  _loadingState = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                side: BorderSide(color: Colors.orange),
              ),
              child:
                  Text('Lipa Sasa', style: boldTextStyle(color: Colors.white)),
            ),
          btnGetByVaziLoader(_loadingState, context),
        ],
      );
    }

    if (_selectedOption == 'phone') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 16.0),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.topLeft,
            child: Text('Namba ya Simu',
                style: secondaryTextStyle(size: 16, color: Colors.black)),
          ),
          AppTextField(
            decoration: waInputDecoration(hint: '0786 XXX XXX'),
            textFieldType: TextFieldType.NUMBER,
            keyboardType: TextInputType.phone,
            textStyle: primaryTextStyle(color: appTextColorPrimary),
            controller: _phoneNumberController,
            focus: phoneFocusNode,
            // nextFocus: phoneFocusNode,
            inputFormatters: [phoneFormatter],
            textCapitalization: TextCapitalization.characters,
          ),
          30.height,
          errWigFun(_errorText),
          btnGetByPhoneLoader(_loadingState, context),
        ],
      );
    }
    if (widget.uniformSubscription == false) {
      if (_selectedOption == 'hakiki_vazi') {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 16.0),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset('assets/logo/mpesa.png'),
                  )),
                  Flexible(child: Image.asset('assets/logo/Mixx_Logo.png')),
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset('assets/logo/airtelmoney.png'),
                  )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              alignment: Alignment.topLeft,
              child: Text('Namba ya Malipo',
                  style: secondaryTextStyle(size: 16, color: Colors.black)),
            ),
            AppTextField(
              decoration: waInputDecoration(hint: '0786 XXX XXX'),
              textFieldType: TextFieldType.NUMBER,
              keyboardType: TextInputType.phone,
              textStyle: primaryTextStyle(color: appTextColorPrimary),
              controller: _phoneNumberController,
              focus: phoneFocusNode,
              // nextFocus: phoneFocusNode,
              inputFormatters: [phoneFormatter],
              textCapitalization: TextCapitalization.characters,
            ),
            30.height,
            errWigFun(_errorText),
            btnGetByHakikiVaziLoader(_loadingState, context),
          ],
        );
      }
    }
    if (_selectedOption == 'chombo') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 16.0),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.topLeft,
            child: Text('Namba ya Chombo',
                style: secondaryTextStyle(size: 16, color: Colors.black)),
          ),
          AppTextField(
            decoration: waInputDecoration(hint: 'MC***XXX'),
            textFieldType: TextFieldType.OTHER,
            keyboardType: TextInputType.name,

            textStyle: primaryTextStyle(color: appTextColorPrimary),
            controller: _plateNumberController,
            focus: phoneFocusNode,
            // nextFocus: phoneFocusNode,
            // inputFormatters: [phoneFormatter],
            textCapitalization: TextCapitalization.characters,
          ),
          30.height,
          errWigFun(_errorText),
          btnGetByPlateLoader(_loadingState, context),
        ],
      );
    }

    if (_selectedOption == 'bado') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          10.height,
          errWigFun(_errorText),
          btnNLoader(_loadingState, context),
          10.height,
          btn2NLoader(_loadingState, context),
          10.height,
          btn3NLoader(_loadingState, context),
          10.height,
          // btn4NLoader(_loadingState, context),
          if (widget.uniformSubscription == false)
            btn5NLoader(_loadingState, context),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        10.height,
        errWigFun(_errorText),
        btnNLoader(_loadingState, context),
        10.height,
        btn2NLoader(_loadingState, context),
        10.height,
        btn3NLoader(_loadingState, context),
        10.height,
        // btn4NLoader(_loadingState, context),
        if (widget.uniformSubscription == false)
          btn5NLoader(_loadingState, context),
      ],
    );
  }

  Widget btnGetByVaziLoader(bool lder, BuildContext context) {
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
      onPressed: () async {
        setState(() {
          _loadingState = true;
        });

        DriverDetailsModule resp =
            await getMainApis.findDriver('vazi', _vaziController.text);

        if (resp.id != null) {
          setState(() {
            _loadingState = false;
          });
          Navigator.pop(context);
          DriverProfileScreen(
            driver: resp,
          ).launch(context);
        }

        setState(() {
          _errorText = resp.message ?? 'Namba ya vazi Haipo';
        });

        setState(() {
          _loadingState = false;
        });
      },
      style: appStyles.defaultButtonStyles().copyWith(
          minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45))),
      child: const Text('Tafuta Dereva'),
    );
  }

  Widget btnGetByPhoneLoader(bool lder, BuildContext context) {
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
      onPressed: () async {
        sendHakikiForm();
      },
      style: appStyles.defaultButtonStyles().copyWith(
          minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45))),
      child: const Text('Tafuta Dereva'),
    );
  }

  Widget btnGetByHakikiVaziLoader(bool lder, BuildContext context) {
    if (lder) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Tafadhali subiri, utapokea ujumbe wa kukamilisha malipo...',
            style: TextStyle(color: WAPrimaryColor),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
      );
    }
    return ElevatedButton(
      onPressed: () async {
        sendHakikiVaziForm();
      },
      style: appStyles.defaultButtonStyles().copyWith(
          minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45))),
      child: const Text('Lipa'),
    );
  }

  Widget btnGetByPlateLoader(bool lder, BuildContext context) {
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
      onPressed: () async {
        // sendHakikiForm();
        hakikiChombo(_plateNumberController.text);
      },
      style: appStyles.defaultButtonStyles().copyWith(
          minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45))),
      child: const Text('Tafuta Chombo'),
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
        setState(() {
          _selectedOption = 'vazi';
          log(_selectedOption);
        });
      },
      style: appStyles.defaultButtonStyles().copyWith(
          minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45))),
      child: const Text('Namba ya Vazi'),
    );
  }

  Widget btn2NLoader(bool lder, BuildContext context) {
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
        QrScannerScreen().launch(context);
      },
      style: appStyles.defaultButtonStyles().copyWith(
          minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45))),
      child: const Text('Scan QR Code'),
    );
  }

  Widget btn3NLoader(bool lder, BuildContext context) {
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
        setState(() {
          _selectedOption = 'phone';
          log(_selectedOption);
        });
      },
      style: appStyles.defaultButtonStyles().copyWith(
          minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45))),
      child: const Text('Namba ya Simu'),
    );
  }

  // Widget btn4NLoader(bool lder, BuildContext context) {
  //   if (lder) {
  //     return Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Center(
  //           child: CircularProgressIndicator(
  //             color: WAPrimaryColor,
  //           ),
  //         )
  //       ],
  //     );
  //   }
  //   return ElevatedButton(
  //     onPressed: () {
  //       setState(() {
  //         _selectedOption = 'chombo';
  //         log(_selectedOption);
  //       });
  //     },
  //     style: appStyles.defaultButtonStyles().copyWith(
  //         minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45))),
  //     child: const Text('Namba ya Chombo (TRA)'),
  //   );
  // }

  Widget btn5NLoader(bool lder, BuildContext context) {
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
        setState(() {
          _selectedOption = 'hakiki_vazi';
          log(_selectedOption);
        });
      },
      style: appStyles.defaultButtonStyles().copyWith(
            backgroundColor: MaterialStateProperty.all(Color(0xFFf57c00)),
            minimumSize:
                const WidgetStatePropertyAll(Size(double.infinity, 45)),
          ),
      child: const Text('Malipo ya Namba'),
    );
  }

  Widget errWigFun(String erv) {
    if (erv != '') {
      return Column(
        children: [
          Text(
            erv,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 14),
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
