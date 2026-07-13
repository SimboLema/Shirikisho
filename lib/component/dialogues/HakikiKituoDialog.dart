import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/services/region_service.dart';

import '../../model/application_model.dart';
import '../../services/post_apis.dart';
import '../../utils/WAColors.dart';
import '../../utils/WAWidgets.dart';
import '../../utils/styles.dart';

class KituoUpdateDialog extends StatefulWidget {
  static String tag = '/KituoUpdateDialog';
  final Map<String, dynamic> parkingData;

  final Application? applicationModel;

  KituoUpdateDialog(
      {super.key, this.applicationModel, required this.parkingData});

  @override
  KituoUpdateDialogState createState() => KituoUpdateDialogState();
}

class KituoUpdateDialogState extends State<KituoUpdateDialog> {
  var plan;
  var duration;
  double? latitude;
  double? longitude;

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
    // fetch leader kituo
// Parse latitude and longitude to double
    try {
      if (widget.parkingData['latitude'] != '0.0000000' &&
          widget.parkingData['longitude'] != '0.0000000') {
        print("user existing location");

        setState(() {
          latitude = double.parse(widget.parkingData['latitude'].toString());
          longitude = double.parse(widget.parkingData['longitude'].toString());
        });
      } else {
        getCurrentLocation();
      }
      // print("Latlong ::$latitude, $longitude ");
    } catch (e) {
      setState(() {
        _errorText = 'Hitilafu wakati wa kuweka taarifa za eneo: $e';
        _loadingState = false;

      });
    }

    setState(() {
      _fnameController.text = widget.parkingData['name'];
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  //Validte

  bool _loadingState = false;
  String _errorText = '';

  Future<int> sendForm() async {
    var res = await updateKituo(
        widget.parkingData['id'],
        widget.parkingData['ward_id'],
        _fnameController.text,
        latitude,
        longitude);
    print("response $res");

    if (res['status'] == "success") {
      toast(res['message'], bgColor: Colors.green, textColor: Colors.white);
      setState(() {
        _errorText = '';
        _loadingState = false;
      });
      Navigator.pop(context);
      return 1;
    } else {
      setState(() {
        _errorText = '${res['message']}';
        _loadingState = false;
      });
      return 0;
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
              // SvgPicture.asset(t10_ic_otp, width: width * 0.25, height: width * 0.4, fit: BoxFit.fill),
              SizedBox(height: 16.0),
              Text("Hakiki Kituo",
                  style: boldTextStyle(size: 20, color: WAPrimaryColor),
                  textAlign: TextAlign.center),
              SizedBox(height: 16.0),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                alignment: Alignment.topLeft,
                child: Text('Jina la Kituo',
                    style: secondaryTextStyle(size: 16, color: Colors.black)),
              ),
              AppTextField(
                decoration: waInputDecoration(hint: 'kituo'),
                textFieldType: TextFieldType.NAME,
                keyboardType: TextInputType.text,
                textStyle: primaryTextStyle(color: appTextColorPrimary),
                controller: _fnameController,
                focus: nameFocusNode,
                nextFocus: phoneFocusNode,
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
      onPressed: () async {
        setState(() {
          _loadingState = true;
        });

        if (widget.parkingData['latitude'] == null &&
            widget.parkingData['longitude'] == null ) {
          await getCurrentLocation();
          print("new latlong ::$latitude, $longitude ");

          sendForm();
        } else {
          sendForm();
        }
      },
      style: appStyles.defaultButtonStyles().copyWith(
          minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45))),
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

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      toast("Huduma ya Location imezimwa. Tafadhali washa GPS.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        toast("Ruhusa ya Location imekataliwa.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // toast(
      //     "Ruhusa ya Location imezuiliwa milele. Tafadhali washa kwenye settings.");
      await Geolocator.openAppSettings(); // Opens the location settings
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    print("set new location");

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }
}
