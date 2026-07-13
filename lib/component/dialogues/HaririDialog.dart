import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/component/dialogues/UpdteDriverDialog.dart';
import 'package:shirikisho/screen/QrScannerScreen.dart';
import 'package:shirikisho/screen/driver/OTPDriverScreen.dart';
import 'package:shirikisho/services/get_apis.dart';

import '../../global/special_fun.dart';
import '../../main.dart';
import '../../model/application_model.dart';
import '../../model/drivers_modules.dart';
import '../../model/region/chombo_model.dart';
import '../../screen/DriverProfileScreen.dart';
import '../../screen/home/DashboardScreen.dart';
import '../../screen/driver/RegisterDriverScreen.dart';
import '../../services/Extensions.dart';
import '../../services/post_apis.dart';
import '../../services/region_service.dart';
import '../../services/show_alert.dart';
import '../../utils/WAColors.dart';
import '../../utils/WAWidgets.dart';
import '../../utils/styles.dart';

class HaririDialog extends StatefulWidget {
  static String tag = '/HaririDialog';

  final DriverDetailsModule driver;

  final Application? applicationModel;

  HaririDialog({super.key, this.applicationModel, required this.driver});


  @override
  HaririDialogState createState() => HaririDialogState();
}

class HaririDialogState extends State<HaririDialog> {
  var plan;
  var duration;

  List<vTypeModule> vehicleTypeList = [];

  var amountController = TextEditingController();
  final TextEditingController? _driverNameController = TextEditingController();
  final TextEditingController _driverLicenceController = TextEditingController();
  final TextEditingController _driverVehicleTypeController = TextEditingController();


  FocusNode nameFocusNode = FocusNode();
  FocusNode licenseFocusNode = FocusNode();
  FocusNode vehicleTypeFocusNode = FocusNode();


  int? dropdownChomboType =  1;

  KishoStyles appStyles = KishoStyles();

  final PostMainApis postMainApis = PostMainApis();
  final GetMainApis getMainApis = GetMainApis();




  @override
  void initState() {
    super.initState();
    _driverNameController?.text = '${widget.driver.firstName} ${widget.driver.middleName} ${widget.driver.lastName}';
    _driverLicenceController.text = '${widget.driver.licenseNumber}';
    dropdownChomboType = widget.driver.vehicleType;
    init();
  }

  init() async {
    List<vTypeModule> vehicle_types = await loadVehicles();

    setState(() {
      vehicleTypeList.clear();
      vehicleTypeList.addAll(vehicle_types);
    });

    _driverVehicleTypeController.text = '${widget.driver.vehicleType}';
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  //Validte

  bool _loadingState = false;
  String _errorText = '';


  var maskFormatter = new MaskTextInputFormatter(
      mask: 'XXX-##-##-###',
      filter: { "#": RegExp(r'[0-9]'),"X": RegExp(r'[A-Z]') },
      type: MaskAutoCompletionType.lazy
  );

    var licenseFormatter = new MaskTextInputFormatter(
      mask: '##########',
      filter: { "#": RegExp(r'[0-9]'),"X": RegExp(r'[A-Z]') },
      type: MaskAutoCompletionType.lazy
  );

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
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(left: 8),
            alignment: Alignment.topLeft,
            child: Text('Jina la dereva', style: boldTextStyle(size: 16, color: Colors.black)),
          ),
          AppTextField(
            controller: _driverNameController,
            decoration: waInputDecoration(hint: 'Juma Mussa Banz'),
            textFieldType: TextFieldType.NAME,
            keyboardType: TextInputType.name,
            textStyle: primaryTextStyle(color: appTextColorPrimary),
            focus: nameFocusNode,
            nextFocus: licenseFocusNode,
            // textCapitalization: TextCapitalization.characters,
          ),

          10.height,
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(left: 8),
            alignment: Alignment.topLeft,
            child: Text('Namba ya Leseni', style: boldTextStyle(size: 16, color: Colors.black)),
          ),

          AppTextField(
            decoration: waInputDecoration(hint: '400********'),
            textFieldType: TextFieldType.NAME,
            keyboardType: TextInputType.name,
            textStyle: primaryTextStyle(color: appTextColorPrimary),
            controller: _driverLicenceController,
            focus: licenseFocusNode,
            nextFocus: vehicleTypeFocusNode,
            inputFormatters: [licenseFormatter],
            textCapitalization: TextCapitalization.characters,
          ),

          10.height,
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(left: 8),
            alignment: Alignment.topLeft,
            child: Text('Aina ya Chombo', style: boldTextStyle(size: 16, color: Colors.black)),
          ),
          Row(
            children: [
              DropdownButtonFormField(
                isExpanded: true,
                value: widget.driver.vehicleType,
                focusNode: vehicleTypeFocusNode,
                decoration: waInputDecoration(hint: "Chagua"),
                items: vehicleTypeList.map((vTypeModule? value) {
                  return DropdownMenuItem<int>(
                    value: value?.id,
                    child: Text(value?.name as String, style: secondaryTextStyle()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    dropdownChomboType =  value ;
                  });
                },
              ).expand(),
            ],
          ),

          30.height,

          errWigFun(_errorText),
          btnNLoader(_loadingState,context),
        ],
      ),
    ),
  ),
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
        setState((){
          _loadingState = true;
        });

         DriverDetailsModule  resp = await getMainApis.findDriver('vazi',_driverLicenceController.text);

         if (resp.id != null){
           setState((){
             _loadingState = false;
           });
           DriverProfileScreen(driver: resp,).launch(context);
         }

         setState((){
          _loadingState = false;
        });
      },
      style: appStyles.defaultButtonStyles().copyWith(
          minimumSize:
              const MaterialStatePropertyAll(Size(double.infinity, 45))),
      child: const Text('Tafuta Dereva'),
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
        _serviceLoader('Inapakia Taarifa');

        List<String> names = extractThreeNames(_driverNameController!.text);

        var res = await postMainApis.updateDriverDetails(names[0], names[1], names[2], _driverLicenceController.text, dropdownChomboType, widget.driver.id);

        if (res == 'true') {
          toast('Taarifa Zimepakiwa');
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => UpdatedDriverDialog(),
          );
        }

        if (res == 'false'){
          setState(() {
            _errorText = "Huduma Haipatikani";
            Navigator.of(context).pop();
            _loadingState = false;
          });
        }


      },
        style:
        appStyles.defaultButtonStyles().copyWith(
            minimumSize:
            const MaterialStatePropertyAll(Size(double.infinity, 45))),

        child: const Text('Save')
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
