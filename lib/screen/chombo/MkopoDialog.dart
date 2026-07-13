import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/main.dart';
import 'package:shirikisho/screen/bima/ChaguaKifurushiBimaMkopoChombo.dart';
import 'package:shirikisho/screen/chombo/mkopoform.dart';
import 'package:shirikisho/screen/home/ServicesScreen.dart';
import 'package:shirikisho/services/get_apis.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:shirikisho/utils/styles.dart';

class MKopoDialog extends StatefulWidget {
  static String tag = '/MKopoDialog';

  MKopoDialog({super.key});

  @override
  MKopoDialogState createState() => MKopoDialogState();
}

class MKopoDialogState extends State<MKopoDialog> {
  final KishoStyles appStyles = KishoStyles();
  final GetMainApis _getMainApis = GetMainApis();

  bool _licenseVerified = false;
  bool _insuranceVerified = false;
  bool _allVerified = false;

  bool _isLicenseLoading = true; // Loading state for license verification
  bool _isInsuranceLoading = false; // Loading state for insurance verification

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await checkLicense(); // Start by checking the license
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: context.height(),
        width: context.width(),
        padding: EdgeInsets.only(top: context.height() * 0.05),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/walletApp/wa_bg.jpg'),
                fit: BoxFit.cover)),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0.0,
          backgroundColor: Colors.red,
          child: Container(
            decoration: BoxDecoration(
              color: context.scaffoldBackgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: defaultBoxShadow(),
            ),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 16.0),
                  Text("Tafadhali Subiri",
                      style: boldTextStyle(size: 20, color: WAPrimaryColor),
                      textAlign: TextAlign.center),
                  SizedBox(height: 16.0),
                  Divider(),
                  SizedBox(height: 16.0),

                  // License Verification
                  verificationItem(
                    'Leseni ya Udereva',
                    _licenseVerified,
                    'Weka Leseni',
                    _isLicenseLoading,
                    1,
                  ),
                  SizedBox(height: 16.0),

                  // Insurance Verification
                  _licenseVerified
                      ? verificationItem(
                          'Bima ya Ajali',
                          _insuranceVerified,
                          'Lipia Bima',
                          _isInsuranceLoading,
                          2,
                        )
                      : Container(),

                  const SizedBox(height: 24.0),
                  _allVerified ? actionButtons() : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget verificationItem(String item, bool isVerified, String buttonText,
      bool isLoading, int code) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item,
            style:
                primaryTextStyle(color: appStore.textPrimaryColor, size: 16)),
        isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: WAPrimaryColor,
                  strokeWidth: 2,
                ),
              ) // Show loader if it's loading
            : isVerified
                ? Icon(Icons.check_circle,
                    color: WAPrimaryColor) // Success icon
                : actionButton(
                    buttonText, code), // Show action button on failure
      ],
    );
  }

  Widget actionButton(String text, int code) {
    return ElevatedButton(
      onPressed: () {
        _redirectToPage(
            code); // Navigate to the specific page based on the code
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: WAPrimaryColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error, color: Colors.white), // Cross icon for failure
          4.width,
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _redirectToPage(int code) {
    // Navigate to specific page based on the code
    switch (code) {
      case 1:
        // Navigate to the License page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ServicesScreen(),
          ),
        );
        break;
      case 2:
        // Navigate to the Insurance page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChoosePlanMkopoChomboScreen(),
          ),
        );
        break;
      // Add more cases for other verifications if needed
    }
  }

  Widget actionButtons() {
    return Column(
      children: [
        Text(
          "*Hakikisha unapakua fomu ya dhamana kabla ya kuendelea",
          style: TextStyle(color: Colors.red, fontSize: 12),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Expanded(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Logic for downloading verified documents
            //     },
            //     style: ElevatedButton.styleFrom(backgroundColor: WAPrimaryColor),
            //     child: const Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text('Pakua fomu', style: TextStyle(color: Colors.white)),
            //         SizedBox(width: 10),
            //         Icon(Icons.download_rounded, color: Colors.white),
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(height: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Logic to proceed to the next step
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MkopoForm(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: WAPrimaryColor),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Endelea', style: TextStyle(color: Colors.white, fontSize: 12)),
                    SizedBox(width: 10),
                    Icon(Icons.east_rounded, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> checkLicense() async {
    setState(() {
      _isLicenseLoading = true; // Start loading for license check
    });
    try {
      var response = await _getMainApis.verifyLicense();
      setState(() {
        _licenseVerified = response[0] == 200 && response[1] == true;
        _isLicenseLoading = false; // Stop loading after license check
      });

      if (_licenseVerified) {
        await checkBima(); // Check insurance after license is verified
      }
    } catch (e) {
      _showNetworkErrorToast(); // Show error toast message
      await _delayAndPopBack(); // Delay and then navigate back
    }
  }

  Future<void> checkBima() async {
    setState(() {
      _isInsuranceLoading = true; // Start loading for insurance check
    });

    try {
      var res = await _getMainApis.verifyBima();
      setState(() {
        _insuranceVerified = res['active_bima'] != null;
        _isInsuranceLoading = false; // Stop loading after insurance check
        _allVerified = _licenseVerified &&
            _insuranceVerified; // Verify all if both are successful
      });
    } catch (e) {
      _showNetworkErrorToast(); // Show error toast message
      await _delayAndPopBack(); // Delay and then navigate bac
    }
  }

  void _showNetworkErrorToast() {
    Fluttertoast.showToast(
      msg: "Kuna Shida ya Mtandao, Tafadhali Jaribu tena .",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5, // Display time for iOS web
      backgroundColor: const Color.fromARGB(255, 249, 97, 86),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _delayAndPopBack() async {
    await Future.delayed(const Duration(seconds: 5));
    Navigator.of(context).pop();
  }
}
