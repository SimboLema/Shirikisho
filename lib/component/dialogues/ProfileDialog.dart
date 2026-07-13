import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/global/environment.dart';
import 'package:shirikisho/global/special_fun.dart';
import 'package:shirikisho/model/drivers_modules.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:shirikisho/utils/WAWidgets.dart';
import 'package:shirikisho/utils/styles.dart';

import '../../services/get_apis.dart'; // kwa appStyles kama ulikua nayo

class ProfileDialog extends StatefulWidget {
  final DriverDetailsModule driver;

  const ProfileDialog({super.key, required this.driver});

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();
  final GetMainApis getMainApis = GetMainApis();

  String _errorText = '';
  bool _loadingState = false;

  final KishoStyles appStyles = KishoStyles();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: radius(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Taarifa za Dereva',
                  style: boldTextStyle(color: Colors.black, size: 20)),
              16.height,
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  '${Environment.imageUrl}/${widget.driver.imageId as String}',
                ),
              ),
              12.height,
              Text(
                "${widget.driver.firstName ?? ''} ${widget.driver.lastName ?? ''}",
                style: boldTextStyle(size: 18),
              ),
              16.height,
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.phone, color: Colors.green),
                          SizedBox(width: 4),
                          Text("Namba ya Simu",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      Text(widget.driver.phoneNumber ?? '--',
                          style: secondaryTextStyle()),
                    ],
                  ),
                  SizedBox(width: 40), // nafasi kubwa zaidi katikati
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.location_on_outlined, color: Colors.red),
                          SizedBox(width: 4),
                          Text("Kituo",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      Text(widget.driver.parking_area?.name ?? '--',
                          style: secondaryTextStyle()),
                    ],
                  ),
                ],
              ),

              16.height,
              // Sehemu ya malipo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/logo/mpesa.png', height: 40),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Image.asset('assets/logo/Mixx_Logo.png', height: 40),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/logo/airtelmoney.png',
                          height: 40),
                    ),
                  ),
                ],
              ),
              12.height,
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Namba ya Malipo',
                    style: secondaryTextStyle(size: 16, color: Colors.black)),
              ),
              8.height,
              AppTextField(
                decoration: waInputDecoration(hint: '0786 XXX XXX'),
                textFieldType: TextFieldType.NUMBER,
                keyboardType: TextInputType.phone,
                textStyle: primaryTextStyle(color: appTextColorPrimary),
                controller: _phoneNumberController,
                focus: phoneFocusNode,
              ),
              20.height,
              errWigFun(_errorText),
              btnGetByHakikiVaziLoader(_loadingState, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnGetByHakikiVaziLoader(bool lder, BuildContext context) {
    if (lder) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Tafadhali subiri, utapokea ujumbe wa kukamilisha malipo...',
            style: TextStyle(color: Colors.orange),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ElevatedButton(
      onPressed: () async {
        sendHakikiVaziForm();
      },
      style: appStyles.defaultButtonStyles().copyWith(
          minimumSize:
              const MaterialStatePropertyAll(Size(double.infinity, 45))),
      child: const Text('Lipa'),
    );
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
      _errorText = '';
      _loadingState = true;
    });

    try {
      Map<String, dynamic> resp =
          await getMainApis.hakikiVazi('255$phone', widget.driver.id);

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
        if (!mounted) return;

        setState(() {
          // _errorText = resp['message'] ?? 'Kuna tatizo katika uhakiki.';
          _errorText = (resp['message'] != null &&
                  resp['message'].toLowerCase() == 'processing')
              ? 'Tafadhali jaribu tena, hakikisha unaweka namba ya siri kukamilisha malipo mapema.'
              : (resp['message'] ?? 'Kuna tatizo katika malipo.');
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorText = 'Kuna tatizo la mtandao au seva.';
      });
    } finally {
      setState(() {
        _loadingState = false;
      });
    }
  }

  Widget errWigFun(String erv) {
    if (erv.isNotEmpty) {
      return Column(
        children: [
          Text(
            erv,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
          10.height,
        ],
      );
    }
    return const SizedBox();
  }
}
