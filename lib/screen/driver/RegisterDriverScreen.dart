// import 'dart:html';

import 'dart:io';

import 'package:events_emitter/events_emitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shirikisho/component/dialogues/SavedDriverDialog.dart';
import 'package:shirikisho/model/WalletAppModel.dart';
import 'package:shirikisho/model/region/association_model.dart';
import 'package:shirikisho/model/region/prking_model.dart';
import 'package:shirikisho/model/region/ward_model.dart';
import 'package:shirikisho/screen/CmearaScreen.dart';
import 'package:shirikisho/utils/DataGenerator.dart';
import 'package:shirikisho/utils/WAColors.dart';

import '../../controllers/registration_info_controllers.dart';
import '../../global/special_fun.dart';
import '../../main.dart';
import '../../model/DriverPickVerifyModel.dart';
import '../../model/region/chombo_model.dart';
import '../../model/region/district_model.dart';
import '../../model/region/region_model.dart';
import '../../services/post_apis.dart';
import '../../services/region_service.dart';
import '../../utils/WAWidgets.dart';
import '../../utils/styles.dart';

class RegisterDriverScreen extends StatefulWidget {
  static String tag = '/RegisterDriverScreen';

  @override
  RegisterDriverScreenState createState() => RegisterDriverScreenState();
}

class RegisterDriverScreenState extends State<RegisterDriverScreen> {
  //Village
  List<VillageModel> villageList = shiVillageList();

  TextEditingController amountController =
      TextEditingController(text: "\u002450");
  TextEditingController receiptNameController = TextEditingController();
  TextEditingController accountController = TextEditingController();

  final TextEditingController _fnameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  final TextEditingController _phoneNumberController = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();

  final TextEditingController _leseniNumberController = TextEditingController();
  final _leseniKey = GlobalKey<FormFieldState>();
  FocusNode leseniFocusNode = FocusNode();

  final TextEditingController _makaziTextController = TextEditingController();
  final _makaziKey = GlobalKey<FormFieldState>();
  FocusNode makziFocusNode = FocusNode();

  //DOB
  late int _day;
  FocusNode dayFocusNode = FocusNode();
  late String _month;
  FocusNode monthFocusNode = FocusNode();
  late int _year;
  FocusNode yearFocusNode = FocusNode();

  final Map<String, String> _allSelectInputs = {};

  final Map<String, String> _sateInput = {};

  late String _gender;
  late String _marital;

  final TextEditingController _closePersonNameTextController =
      TextEditingController();
  final _closePersonNameKey = GlobalKey<FormFieldState>();
  FocusNode closePersonNameFocusNode = FocusNode();

  final TextEditingController _closePhoneTextController =
      TextEditingController();
  FocusNode closePersonPhoneFocusNode = FocusNode();
  final _closePersonPhoneKey = GlobalKey<FormFieldState>();

  //Page 2
  bool dereva_ni_mmiliki = false;

  final events = EventEmitter();

  //Ownership
  final TextEditingController _chomboNambaTextController =
      TextEditingController();
  FocusNode chomboNoFocusNode = FocusNode();

  FocusNode ainChombiFocusNode = FocusNode();

  late String _umiliki;
  FocusNode umilikiFocusNode = FocusNode();

  final TextEditingController _jinaMilikiTextController =
      TextEditingController();
  FocusNode jinaMilikiNoFocusNode = FocusNode();

  final TextEditingController _nambaMilikiTextController =
      TextEditingController();
  FocusNode nambaMilikiNoFocusNode = FocusNode();

  late String _bimaChomboController;
  FocusNode bimaAfyaFocusNode = FocusNode();

  late String _bimaAfyaController;
  FocusNode bimaChomboFocusNode = FocusNode();

  //Page 3
  late int _regionID;

  String? _typeOfId;
  String? _fPassPath;
  XFile? _pickedPasImage;
  String? _driverIsOwner;
  String? _fIdPath;

  int? onlineImageId;

  String _errorForm = '';
  bool _loading = false;

  final PostMainApis _postMainApis = PostMainApis();
  final SubmitDriverDetailsController _submitDriverDetailsController =
      Get.put(SubmitDriverDetailsController());

  final KishoStyles appStyles = KishoStyles();

  final _storage = const FlutterSecureStorage();

  PageController pageController = PageController(initialPage: 0);

  int pageNumber = 0;
  bool showBottomNav = true;

  String pageTitle = 'Taarifa Binafsi';

  List<Widget> buildDotIndicator() {
    List<Widget> list = [];
    for (int i = 0; i <= 4; i++) {
      list.add(i == pageNumber
          ? indicator(isActive: true)
          : indicator(isActive: false));
    }
    return list;
  }

  List<OPPickVerifyModel> cardList = getCardListItems();

  FocusNode receiptNameFocusNode = FocusNode();
  FocusNode accountFocusNode = FocusNode();

  List<WACardModel> sendViaCardList = waSendViaCardList();
  WACardModel selectedCard = WACardModel();

  var phoneFormatter = new MaskTextInputFormatter(
      mask: '#### ### ###',
      filter: {"#": RegExp(r'[0-9]'), "X": RegExp(r'[A-Z]')},
      type: MaskAutoCompletionType.lazy);

  var licenseFormatter = new MaskTextInputFormatter(
      mask: '##########',
      filter: {"#": RegExp(r'[0-9]'), "X": RegExp(r'[A-Z]')},
      type: MaskAutoCompletionType.lazy);

  var plateFormatter = new MaskTextInputFormatter(
      mask: 'MC ### XXX',
      filter: {"#": RegExp(r'[0-9]'), "X": RegExp(r'[A-Z]')},
      type: MaskAutoCompletionType.lazy);

  List<RegionModule> regionsList = [];
  List<DistrictModule> districtsList = [];
  List<WardModule> wardsList = [];
  List<AssociationModule> associationsList = [];
  List<ParkingModule> parkingsList = [];
  List<vTypeModule> vehicleTypeList = [];

  final GlobalKey<FormFieldState> _distKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _wardKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _assocKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _parkKey = GlobalKey<FormFieldState>();

  int? dropdownDate = null;
  String? dropdownMonth = null;
  int? dropdownYear = null;
  DateTime now = new DateTime.now();
  String? dropdownGender = null;
  FocusNode genderFocusNode = FocusNode();

  String? dropdownMarital = null;
  FocusNode maritalFocusNode = FocusNode();

  String? dropdownChombo = null;
  int? dropdownChomboType = null;
  String? dropdownUmiliki = null;

  String? dropdownBimaChombo = null;
  String? dropdownBimaAfya = null;

  String? dropdownKitio = null;

  RegionModule? dropdownMkoa = null;
  DistrictModule? dropdownWilaya = null;

  String? dropdownKata = null;
  WardModule? dropdownWard = null;
  ParkingModule? dropdownPark = null;
  AssociationModule? dropdownChama = null;

  var _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  File? userImage = null;

  late File imageFile;

  bool loadFromFile = false;

  Future getImage(ImageSource source) async {
    var image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      imageFile = File(image.path);
      loadFromFile = true;
      setState(() {});
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    setName();
    init();

    leseniFocusNode = FocusNode();
    leseniFocusNode.addListener(() {
      if (!leseniFocusNode.hasFocus) {
        _leseniKey.currentState?.validate();
      }
    });

    makziFocusNode = FocusNode();
    makziFocusNode.addListener(() {
      if (!makziFocusNode.hasFocus) {
        _makaziKey.currentState?.validate();
      }
    });

    closePersonNameFocusNode = FocusNode();
    closePersonNameFocusNode.addListener(() {
      if (!closePersonNameFocusNode.hasFocus) {
        _closePersonPhoneKey.currentState?.validate();
      }
    });

    closePersonPhoneFocusNode = FocusNode();
    closePersonPhoneFocusNode.addListener(() {
      if (!closePersonPhoneFocusNode.hasFocus) {
        _closePersonNameKey.currentState?.validate();
      }
    });
  }

  Future<void> setName() async {
    var driver_name = await _storage.read(key: 'driver_name');
    _fnameController.text = driver_name ?? '';

    var driver_phone = await _storage.read(key: 'driver_phone');
    _phoneNumberController.text = driver_phone ?? '';
  }

  Future<void> init() async {
    List<RegionModule> regions = await loadRegions();
    List<vTypeModule> vehicle_types = await loadVehicles();

    setState(() {
      regionsList.clear();
      regionsList.addAll(regions);

      vehicleTypeList.clear();
      vehicleTypeList.addAll(vehicle_types);
    });

    setStatusBarColor(Colors.white, statusBarIconBrightness: Brightness.dark);
    selectedCard = sendViaCardList[0];
    await Future.delayed(Duration(milliseconds: 500));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  //Validte

  bool _loadingState = false;
  String _errorText = '';
  String _imgErrorText = '';

  Future<int> sendDriverForm() async {
    setState(() {
      _errorText = '';
    });

    setState(() {
      _loadingState = true;
    });

    List<String> names = extractThreeNames(_fnameController.text);

    List<String?> inputs = [
      names[0], names[1], names[2],
      _phoneNumberController.text, //3
      _leseniNumberController.text, //4
      _makaziTextController.text, //5
      '${dropdownDate}-${_sateInput['month']}-$dropdownYear', //6
      _allSelectInputs['gender'], //7
      _allSelectInputs['marital'], //8
      _closePersonNameTextController.text, //9
      _closePhoneTextController.text, //10

      dropdownChomboType != null ? '$dropdownChomboType' : '', //11
      _chomboNambaTextController.text, //12
      _allSelectInputs['driver_is_owner'], //13
      _jinaMilikiTextController.text, //14
      _nambaMilikiTextController.text, //15
      _allSelectInputs['bima_chombo'], //16
      _allSelectInputs['bima_afya'], //17

      dropdownWard?.id != null ? '$dropdownChomboType' : '', //19
      dropdownChama?.id != null ? '$dropdownChomboType' : '', //18
      dropdownPark?.id != null ? '$dropdownChomboType' : '', //19
      onlineImageId != null ? '$dropdownChomboType' : '' //20
    ];

    print(_validateForm(inputs));

    // print('nooo');

    String drAns = await _postMainApis.saveDriver(
        names[0],
        names[1],
        names[2],
        _phoneNumberController.text,
        _leseniNumberController.text,
        _makaziTextController.text,
        _allSelectInputs['marital'],
        '${dropdownDate}-${_sateInput['month']}-$dropdownYear',
        _allSelectInputs['gender'],
        _closePersonNameTextController.text,
        _closePhoneTextController.text,
        dropdownChomboType,
        _chomboNambaTextController.text,
        _allSelectInputs['driver_is_owner'],
        _jinaMilikiTextController.text,
        _nambaMilikiTextController.text,
        _allSelectInputs['bima_chombo'],
        _allSelectInputs['bima_afya'],
        dropdownWard?.id,
        dropdownChama?.id,
        dropdownPark?.id,
        onlineImageId);

    if (drAns != 'success') {
      setState(() {
        _loadingState = false;
        _errorText = drAns;
      });
      return 0;
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => SavedDriverDialog(),
    );

    setState(() {
      _loadingState = false;
    });

    return 1;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text('$pageTitle',
                style: boldTextStyle(color: Colors.black, size: 18)),
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: context.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Icon(Icons.arrow_back,
                  color: appStore.isDarkModeOn ? white : black),
            ).onTap(() {
              finish(context);
            }),
            centerTitle: true,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              height: double.infinity,
              child: PageView(
                onPageChanged: (index) => setState(() {
                  pageNumber = index;

                  if (pageNumber == 4) {
                    showBottomNav = false;
                  } else {
                    showBottomNav = true;
                  }

                  switch (pageNumber) {
                    case 0:
                      pageTitle = 'Taarifa Binafsi';
                      break;
                    case 1:
                      pageTitle = 'Taarifa za Chombo';
                      break;
                    case 2:
                      pageTitle = 'Taarifa za kituo';
                      break;
                    case 3:
                      pageTitle = 'Taarifa za Ziada';
                      break;
                    case 4:
                      pageTitle = 'Hakiki Taarifa';
                      break;
                  }
                }),
                controller: pageController,
                children: <Widget>[
// ----------------------  TAARIFA KAMILI ZA MUHUSIKA --------------------------
                  Container(
                    padding: EdgeInsets.only(
                        left: 16,
                        bottom: 70,
                        right: 16,
                        top: size.height * 0.1),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // appLogo(),

                            0.height,
                            // Text("Taarif Binafsi", style: boldTextStyle(size: 18, letterSpacing: 0.2)),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.only(left: 8),
                              alignment: Alignment.topLeft,
                              child: Text('Jina Kamili',
                                  style: boldTextStyle(
                                      size: 15, color: Colors.black)),
                            ),
                            AppTextField(
                              decoration:
                                  waInputDecoration(hint: 'Samia Hasan Suluhu'),
                              textFieldType: TextFieldType.NAME,
                              keyboardType: TextInputType.text,
                              textStyle: primaryTextStyle(
                                  color: appTextColorPrimary, size: 15),
                              controller: _fnameController,
                              focus: nameFocusNode,
                              nextFocus: leseniFocusNode,
                            ),

                            //Phone
                            10.height,
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.only(left: 8),
                              alignment: Alignment.topLeft,
                              child: Text('Namba ya Simu',
                                  style: boldTextStyle(
                                      size: 15, color: Colors.black)),
                            ),
                            AppTextField(
                              decoration: waInputDecoration(hint: '07********'),
                              textFieldType: TextFieldType.NAME,
                              keyboardType: TextInputType.text,
                              textStyle:
                                  primaryTextStyle(color: appTextColorPrimary),
                              controller: _phoneNumberController,
                              focus: phoneFocusNode,
                              nextFocus: leseniFocusNode,
                              enabled: false,
                            ),

                            //Leseni
                            10.height,
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.only(left: 8),
                              alignment: Alignment.topLeft,
                              child: Text('Namba ya Leseni',
                                  style: boldTextStyle(
                                      size: 15, color: Colors.black)),
                            ),
                            AppTextField(
                              key: _leseniKey,
                              decoration: waInputDecoration(hint: '400*******'),
                              textFieldType: TextFieldType.NUMBER,
                              keyboardType: TextInputType.number,
                              textStyle:
                                  primaryTextStyle(color: appTextColorPrimary),
                              controller: _leseniNumberController,
                              focus: leseniFocusNode,
                              nextFocus: makziFocusNode,
                              inputFormatters: [licenseFormatter],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Tafadhali jaza na maba ya leseni';
                                }
                                if (value.length < 10) {
                                  return 'Namba ya leseni haijatimia';
                                }
                                return null;
                              },
                            ),

                            //Makazi
                            10.height,
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.only(left: 8),
                              alignment: Alignment.topLeft,
                              child: Text('Makazi',
                                  style: boldTextStyle(
                                      size: 15, color: Colors.black)),
                            ),
                            AppTextField(
                              key: _makaziKey,
                              decoration: waInputDecoration(
                                  hint: 'Tanki Bovu ka Komba'),
                              textFieldType: TextFieldType.NAME,
                              keyboardType: TextInputType.text,
                              textStyle:
                                  primaryTextStyle(color: appTextColorPrimary),
                              controller: _makaziTextController,
                              focus: makziFocusNode,
                              nextFocus: dayFocusNode,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Jaza makazia ya dereva.';
                                }
                                return null;
                              },
                            ),

                            10.height,
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.only(left: 8),
                              alignment: Alignment.topLeft,
                              child: Text('Tarehe Ya Kuzaliwa',
                                  style: boldTextStyle(
                                      size: 15, color: Colors.black)),
                            ),
                            Row(
                              children: [
                                DropdownButtonFormField(
                                  isExpanded: true,
                                  value: dropdownDate,
                                  focusNode: dayFocusNode,
                                  decoration: waInputDecoration(hint: "Date"),
                                  items: List.generate(31, (index) {
                                    return DropdownMenuItem(
                                        child: Text('${index + 1}',
                                            style: secondaryTextStyle()),
                                        value: index + 1);
                                  }),
                                  onChanged: (value) {
                                    setState(() {
                                      dropdownDate = value;
                                    });
                                    _sateInput['day'] = value as String;
                                    _day = value!;
                                  },
                                ).expand(),
                                16.width,
                                DropdownButtonFormField(
                                  isExpanded: true,
                                  value: dropdownMonth,
                                  focusNode: monthFocusNode,
                                  decoration: waInputDecoration(hint: "Month"),
                                  items: waMonthList.map((String? value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value!,
                                          style: secondaryTextStyle()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      dropdownMonth = value;
                                      _sateInput['month'] = value!;
                                    });
                                    _month = value!;
                                  },
                                ).expand(),
                                16.width,
                                DropdownButtonFormField(
                                  isExpanded: true,
                                  value: dropdownYear,
                                  focusNode: yearFocusNode,
                                  decoration: waInputDecoration(hint: "Year"),
                                  items: List.generate(60, (index) {
                                    return DropdownMenuItem(
                                        child: Text('${index + now.year - 77}',
                                            style: secondaryTextStyle()),
                                        value: index + now.year - 77);
                                  }),

                                  // items: waYearList.map((String? value) {
                                  //   return DropdownMenuItem<String>(
                                  //     value: value,
                                  //     child: Text(value!, style: secondaryTextStyle()),
                                  //   );
                                  // }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      dropdownYear = value;
                                      _sateInput['year'] = value as String;
                                    });
                                    _year = value!;
                                  },
                                ).expand(),
                              ],
                            ),

                            10.height,
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.only(left: 8),
                              alignment: Alignment.topLeft,
                              child: Text('Jinsia',
                                  style: boldTextStyle(
                                      size: 15, color: Colors.black)),
                            ),
                            Row(
                              children: [
                                DropdownButtonFormField(
                                  isExpanded: true,
                                  value: dropdownGender,
                                  focusNode: genderFocusNode,
                                  decoration: waInputDecoration(hint: "Chagua"),
                                  items: gender.map((String? value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value!,
                                          style: secondaryTextStyle()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      dropdownGender = value;
                                      _allSelectInputs['gender'] = value!;
                                    });
                                  },
                                ).expand(),
                              ],
                            ),

                            //Mrital
                            10.height,
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.only(left: 8),
                              alignment: Alignment.topLeft,
                              child: Text('Ndoa',
                                  style: boldTextStyle(
                                      size: 15, color: Colors.black)),
                            ),
                            Row(
                              children: [
                                DropdownButtonFormField(
                                  isExpanded: true,
                                  value: dropdownMarital,
                                  decoration: waInputDecoration(hint: "Chagua"),
                                  items: marital.map((String? value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value!,
                                          style: secondaryTextStyle()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      dropdownMarital = value;
                                      _allSelectInputs['marital'] = value!;
                                    });
                                    _marital = value!;
                                  },
                                ).expand(),
                              ],
                            ),

                            //Close Person
                            10.height,
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.only(left: 8),
                              alignment: Alignment.topLeft,
                              child: Text('Majina Ya Mtu wa Karibu',
                                  style: boldTextStyle(
                                      size: 15, color: Colors.black)),
                            ),
                            AppTextField(
                              decoration:
                                  waInputDecoration(hint: 'Hamis Juma Husein'),
                              textFieldType: TextFieldType.NAME,
                              keyboardType: TextInputType.name,
                              textStyle:
                                  primaryTextStyle(color: appTextColorPrimary),
                              controller: _closePersonNameTextController,
                              focus: closePersonNameFocusNode,
                              nextFocus: closePersonPhoneFocusNode,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Jina Kamili la Mtu wa Karibu.';
                                }
                                if (!hasThreeNames(
                                    _closePersonNameTextController.text)) {
                                  return 'Hakikisha umejaza majina yote matatu';
                                }
                                return null;
                              },
                            ),

                            10.height,
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.only(left: 8),
                              alignment: Alignment.topLeft,
                              child: Text('Namba ya Simu ya Mtu wa Karibu',
                                  style: boldTextStyle(
                                      size: 15, color: Colors.black)),
                            ),
                            AppTextField(
                              decoration: waInputDecoration(hint: '07********'),
                              textFieldType: TextFieldType.NUMBER,
                              keyboardType: TextInputType.phone,
                              textStyle:
                                  primaryTextStyle(color: appTextColorPrimary),
                              controller: _closePhoneTextController,
                              focus: closePersonPhoneFocusNode,
                              nextFocus: ainChombiFocusNode,
                              inputFormatters: [phoneFormatter],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

// ------------------------- TAARIFA ZA CHOMBO -----------------------------------------
                  Container(
                    padding: EdgeInsets.only(
                        left: 16,
                        bottom: 70,
                        right: 16,
                        top: size.height * 0.1),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // 24.height,
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.only(left: 8),
                            alignment: Alignment.topLeft,
                            child: Text('Aina ya Chombo',
                                style: boldTextStyle(
                                    size: 15, color: Colors.black)),
                          ),
                          Row(
                            children: [
                              DropdownButtonFormField(
                                isExpanded: true,
                                value: dropdownChomboType,
                                focusNode: ainChombiFocusNode,
                                decoration: waInputDecoration(hint: "Chagua"),
                                items:
                                    vehicleTypeList.map((vTypeModule? value) {
                                  return DropdownMenuItem<int>(
                                    value: value?.id,
                                    child: Text(value?.name as String,
                                        style: secondaryTextStyle()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropdownChomboType = value;
                                  });
                                },
                              ).expand(),
                            ],
                          ),

                          10.height,
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.only(left: 8),
                            alignment: Alignment.topLeft,
                            child: Text('Namba ya Chombo',
                                style: boldTextStyle(
                                    size: 15, color: Colors.black)),
                          ),
                          AppTextField(
                            decoration: waInputDecoration(hint: 'MC *** ***'),
                            textFieldType: TextFieldType.NAME,
                            keyboardType: TextInputType.name,
                            textStyle:
                                primaryTextStyle(color: appTextColorPrimary),
                            controller: _chomboNambaTextController,
                            focus: chomboNoFocusNode,
                            textCapitalization: TextCapitalization.characters,
                            nextFocus: umilikiFocusNode,
                            inputFormatters: [plateFormatter],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Jaza makazia ya dereva.';
                              }
                              return null;
                            },
                          ),

                          //Umiliki
                          10.height,
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.only(left: 8),
                            alignment: Alignment.topLeft,
                            child: Text('Umiliki Wa Chombo',
                                style: boldTextStyle(
                                    size: 15, color: Colors.black)),
                          ),
                          Row(
                            children: [
                              DropdownButtonFormField(
                                isExpanded: true,
                                value: dropdownUmiliki,
                                focusNode: umilikiFocusNode,
                                decoration: waInputDecoration(hint: "Chagua"),
                                items: ownership.map((String? value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value!,
                                        style: secondaryTextStyle()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropdownUmiliki = value;
                                    _typeOfId = value;
                                    _allSelectInputs['driver_is_owner'] =
                                        value!;
                                  });
                                },
                              ).expand(),
                            ],
                          ),

                          umiliki(),

                          10.height,
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.only(left: 8),
                            alignment: Alignment.topLeft,
                            child: Text('Bima ya Chombo?',
                                style: boldTextStyle(
                                    size: 15, color: Colors.black)),
                          ),
                          Row(
                            children: [
                              DropdownButtonFormField(
                                isExpanded: true,
                                value: dropdownBimaChombo,
                                focusNode: bimaChomboFocusNode,
                                decoration: waInputDecoration(hint: "Chagua"),
                                items: bima.map((String? value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value!,
                                        style: secondaryTextStyle()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropdownBimaChombo = value;
                                    _allSelectInputs['bima_chombo'] = value!;
                                  });
                                },
                              ).expand(),
                            ],
                          ),
                          10.height,
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.only(left: 8),
                            alignment: Alignment.topLeft,
                            child: Text('Bima ya Afya?',
                                style: boldTextStyle(
                                    size: 15, color: Colors.black)),
                          ),
                          Row(
                            children: [
                              DropdownButtonFormField(
                                isExpanded: true,
                                value: dropdownBimaAfya,
                                focusNode: umilikiFocusNode,
                                decoration: waInputDecoration(hint: "Chagua"),
                                items: bima.map((String? value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value!,
                                        style: secondaryTextStyle()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropdownBimaAfya = value;
                                    _allSelectInputs['bima_afya'] = value!;
                                  });
                                },
                              ).expand(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

// ---------------------------- TAARIFA ZA KITUO -----------------------------------
                  Container(
                    padding: EdgeInsets.only(
                        left: 16,
                        bottom: 70,
                        right: 16,
                        top: size.height * 0.1),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          //Page 3
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.only(left: 8),
                            alignment: Alignment.topLeft,
                            child: Text('Chagua Mkoa',
                                style: boldTextStyle(
                                    size: 15, color: Colors.black)),
                          ),
                          Row(
                            children: [
                              DropdownButtonFormField(
                                isExpanded: true,
                                value: dropdownMkoa,
                                focusNode: umilikiFocusNode,
                                decoration: waInputDecoration(hint: "Chagua"),
                                items: regionsList.map((RegionModule? value) {
                                  return DropdownMenuItem<RegionModule>(
                                    value: value,
                                    child: Text(value?.name as String,
                                        style: secondaryTextStyle()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  List? districts = value?.districts as List?;
                                  setState(() {
                                    dropdownMkoa = value;
                                    _distKey.currentState?.reset();
                                    districtsList.clear();

                                    if (districts!.length >= 1) {
                                      districtsList.addAll(districts
                                          as Iterable<DistrictModule>);
                                    }
                                  });
                                  // _marital = value!;
                                },
                              ).expand(),
                            ],
                          ),

                          10.height,
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.only(left: 8),
                            alignment: Alignment.topLeft,
                            child: Text('Chgua Wilaya',
                                style: boldTextStyle(
                                    size: 15, color: Colors.black)),
                          ),
                          Row(
                            children: [
                              DropdownButtonFormField(
                                key: _distKey,
                                isExpanded: true,
                                // focusNode: bimaChomboFocusNode,
                                decoration: waInputDecoration(hint: "Chagua"),
                                items:
                                    districtsList.map((DistrictModule? value) {
                                  return DropdownMenuItem<DistrictModule>(
                                    value: value,
                                    child: Text(value?.name as String,
                                        style: secondaryTextStyle()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  _wardKey.currentState?.reset();
                                  _assocKey.currentState?.reset();
                                  _parkKey.currentState?.reset();

                                  wardsList.clear();
                                  associationsList.clear();
                                  parkingsList.clear();

                                  setState(() {
                                    if (value != null) {
                                      List wards = value.wards as List;
                                      List associations =
                                          value.associations as List;
                                      wardsList.addAll(
                                          wards as Iterable<WardModule>);
                                      associationsList.addAll(associations
                                          as Iterable<AssociationModule>);
                                    }
                                  });
                                },
                              ).expand(),
                            ],
                          ),

                          10.height,
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.only(left: 8),
                            alignment: Alignment.topLeft,
                            child: Text('Chagua Kata',
                                style: boldTextStyle(
                                    size: 15, color: Colors.black)),
                          ),
                          Row(
                            children: [
                              DropdownButtonFormField(
                                key: _wardKey,
                                isExpanded: true,
                                // focusNode: umilikiFocusNode,
                                decoration: waInputDecoration(hint: "Chagua"),
                                items: wardsList.map((WardModule? value) {
                                  return DropdownMenuItem<WardModule>(
                                    value: value,
                                    child: Text(value!.name as String,
                                        style: secondaryTextStyle()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  _parkKey.currentState?.reset();

                                  // if(parkingsList.length != 0)
                                  parkingsList.clear();

                                  setState(() {
                                    if (value != null) {
                                      dropdownWard = value;
                                      List parkings = value.parkings as List;
                                      parkingsList.addAll(
                                          parkings as Iterable<ParkingModule>);
                                    }
                                  });
                                },
                              ).expand(),
                            ],
                          ),

                          10.height,
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.only(left: 8),
                            alignment: Alignment.topLeft,
                            child: Text('Chagua Chama',
                                style: boldTextStyle(
                                    size: 15, color: Colors.black)),
                          ),
                          Row(
                            children: [
                              DropdownButtonFormField(
                                isExpanded: true,
                                key: _assocKey,
                                // focusNode: umilikiFocusNode,
                                decoration: waInputDecoration(hint: "Chagua"),
                                items: associationsList
                                    .map((AssociationModule? value) {
                                  return DropdownMenuItem<AssociationModule>(
                                    value: value,
                                    child: Text(value!.name as String,
                                        style: secondaryTextStyle()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) dropdownChama = value;
                                  // _allSelectInputs['association_id'] = value as String;
                                },
                              ).expand(),
                            ],
                          ),

                          10.height,
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.only(left: 8),
                            alignment: Alignment.topLeft,
                            child: Text('Chagua Kituo',
                                style: boldTextStyle(
                                    size: 15, color: Colors.black)),
                          ),
                          Row(
                            children: [
                              DropdownButtonFormField(
                                isExpanded: true,
                                key: _parkKey,
                                // focusNode: umilikiFocusNode,
                                decoration: waInputDecoration(hint: "Chagua"),
                                items: parkingsList.map((ParkingModule? value) {
                                  return DropdownMenuItem<ParkingModule>(
                                    value: value,
                                    child: Text(value?.name as String,
                                        style: secondaryTextStyle()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) dropdownPark = value;
                                  // _allSelectInputs['park_id'] = value as String;
                                },
                              ).expand(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --------------------- KUPIGA PICHA ----------------------------------
                  Container(
                    padding: EdgeInsets.only(
                        left: 16,
                        bottom: 70,
                        right: 16,
                        top: size.height * 0.1),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Card(
                            elevation: 2.0,
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  userProfileImage(),
                                  const SizedBox(
                                    height: 9,
                                  ),
                                  Text(
                                    'Picha ya paspoti',
                                    style: const TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Color(0xFFE6EBF0)))),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        errIMGFun(_imgErrorText),
                                        btnUploadImageLoader(
                                            _loadingState, context),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

// --------------------------------- IMAGE INFO VERIFIER -----------------------------------
                  Container(
                    padding: EdgeInsets.only(
                        left: 16,
                        bottom: 100,
                        right: 16,
                        top: size.height * 0.05),
                    alignment: AlignmentDirectional.topCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Card(
                            elevation: 2.0,
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  userProfileImage(),
                                  const SizedBox(
                                    height: 9,
                                  ),
                                  Text(
                                    'Picha ya paspoti',
                                    style: const TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                        // border: Border(top: BorderSide(color: Color(0xFFE6EBF0)))
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          15.height,
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            margin: EdgeInsets.only(
                                bottom: 10, left: 10, right: 16),
                            decoration: boxDecorationRoundedWithShadow(16,
                                backgroundColor: context.cardColor),
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
                                  backgroundColor:
                                      Colors.white.withOpacity(0.1),
                                ),
                                child: Icon(
                                  Icons.perm_identity_sharp,
                                  size: 24,
                                  color: Color(0xFF26C884),
                                ),
                              ),
                              title: RichTextWidget(
                                list: [
                                  TextSpan(
                                    text: 'Jina Kamili',
                                    style: boldTextStyle(
                                        size: 14,
                                        color: appStore.isDarkModeOn
                                            ? white
                                            : black),
                                  ),
                                ],
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                _fnameController.text,
                                style: primaryTextStyle(
                                    color: appStore.isDarkModeOn
                                        ? white
                                        : Colors.black54,
                                    size: 14),
                              ),
                            ),
                          ),
                          6.height,
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            margin: EdgeInsets.only(
                                bottom: 10, left: 10, right: 16),
                            decoration: boxDecorationRoundedWithShadow(16,
                                backgroundColor: context.cardColor),
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
                                  backgroundColor:
                                      Colors.white.withOpacity(0.1),
                                ),
                                child: Icon(
                                  Icons.local_phone,
                                  size: 24,
                                  color: Color(0xFF26C884),
                                ),
                              ),
                              title: RichTextWidget(
                                list: [
                                  TextSpan(
                                    text: 'Namba Ya Simu',
                                    style: boldTextStyle(
                                        size: 14,
                                        color: appStore.isDarkModeOn
                                            ? white
                                            : black),
                                  ),
                                ],
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                _phoneNumberController.text,
                                style: primaryTextStyle(
                                    color: appStore.isDarkModeOn
                                        ? white
                                        : Colors.black54,
                                    size: 14),
                              ),
                            ),
                          ),
                          6.height,
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            margin: EdgeInsets.only(
                                bottom: 10, left: 10, right: 16),
                            decoration: boxDecorationRoundedWithShadow(16,
                                backgroundColor: context.cardColor),
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
                                  backgroundColor:
                                      Colors.white.withOpacity(0.1),
                                ),
                                child: Icon(
                                  Icons.document_scanner_outlined,
                                  size: 24,
                                  color: Color(0xFF26C884),
                                ),
                              ),
                              title: RichTextWidget(
                                list: [
                                  TextSpan(
                                    text: 'Namba Leseni',
                                    style: boldTextStyle(
                                        size: 14,
                                        color: appStore.isDarkModeOn
                                            ? white
                                            : black),
                                  ),
                                ],
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                _leseniNumberController.text,
                                style: primaryTextStyle(
                                    color: appStore.isDarkModeOn
                                        ? white
                                        : Colors.black54,
                                    size: 14),
                              ),
                            ),
                          ),
                          verification(),
                          errWigFun(_errorText),
                          btnNLoader(_loadingState, context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNav(),
          ],
        ),
      ),
    );
  }

  Widget appLogo() {
    return Image.asset(
      'assets/images/logo2.png',
      width: 150,
      height: 150,
      fit: BoxFit.fill,
    );
  }

  Widget userProfileImage() {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Container(
          margin: EdgeInsets.only(right: 8),
          height: 200,
          width: 200,
          decoration:
              BoxDecoration(color: WAPrimaryColor, shape: BoxShape.circle),
          child: loadFromFile
              ? Image.file(
                  imageFile,
                  height: 95,
                  width: 95,
                  fit: BoxFit.cover,
                )
              : Icon(Icons.person, color: white, size: 60),
        ),
      ],
    );
  }

  Widget yesBtn() {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Container(
          margin: EdgeInsets.only(right: 8),
          height: 200,
          width: 200,
          decoration:
              BoxDecoration(color: WAPrimaryColor, shape: BoxShape.circle),
          child: Image.asset(
            'assets/images/logo2.png',
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }

  Widget textField(
      {String? title, IconData? image, TextInputType? textInputType}) {
    return TextField(
      keyboardType: textInputType,
      style: primaryTextStyle(),
      decoration: InputDecoration(
        hintText: title,
        hintStyle: secondaryTextStyle(size: 16),
        fillColor: Colors.grey,
        suffixIcon: Icon(image, color: Colors.grey, size: 20),
      ),
    );
  }

  BoxDecoration boxDecoration(
      {double radius = 80.0,
      Color? backGroundColor = Colors.white,
      double blurRadius = 8.0,
      double spreadRadius = 8.0,
      shadowColor = Colors.black12}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
            color: shadowColor,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius)
      ],
      color: backGroundColor,
    );
  }

  Widget indicator({required bool isActive}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: isActive ? 6.0 : 4.0,
      width: isActive ? 6.0 : 4.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF929794),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    );
  }

  Widget umiliki() {
    if (_typeOfId == 'Dereva na Mmiliki') {
      return const SizedBox();
    } else {
      return Column(
        children: <Widget>[
          10.height,
          Container(
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.topLeft,
            child: Text('Mmiliki wa Chombo',
                style: boldTextStyle(size: 15, color: Colors.black)),
          ),
          AppTextField(
            decoration: waInputDecoration(hint: 'Anthon Juma Masanja'),
            textFieldType: TextFieldType.NAME,
            keyboardType: TextInputType.name,
            textStyle: primaryTextStyle(color: appTextColorPrimary),
            controller: _jinaMilikiTextController,
            focus: jinaMilikiNoFocusNode,
            nextFocus: nambaMilikiNoFocusNode,
          ),
          10.height,
          Container(
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.topLeft,
            child: Text('Namba ya Simu',
                style: boldTextStyle(size: 15, color: Colors.black)),
          ),
          AppTextField(
            decoration: waInputDecoration(hint: '07** *** ***'),
            textFieldType: TextFieldType.NUMBER,
            keyboardType: TextInputType.phone,
            textStyle: primaryTextStyle(color: appTextColorPrimary),
            controller: _nambaMilikiTextController,
            focus: nambaMilikiNoFocusNode,
            nextFocus: bimaChomboFocusNode,
            inputFormatters: [phoneFormatter],
          ),
        ],
      );
    }
  }

  Widget verification() {
    if (dropdownPark != null) {
      return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 16),
        decoration: boxDecorationRoundedWithShadow(16,
            backgroundColor: context.cardColor),
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
            child: Icon(
              Icons.local_parking_sharp,
              size: 24,
              color: Color(0xFF26C884),
            ),
          ),
          title: RichTextWidget(
            list: [
              TextSpan(
                text: 'Kituo',
                style: boldTextStyle(
                    size: 14, color: appStore.isDarkModeOn ? white : black),
              ),
            ],
            maxLines: 1,
          ),
          subtitle: Text(
            dropdownPark?.name as String,
            style: primaryTextStyle(
                color: appStore.isDarkModeOn ? white : Colors.black54,
                size: 14),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget btnUplImg(bool lder, BuildContext context) {
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
        sendDriverForm();
      },
      style: appStyles.defaultButtonStyles().copyWith(
          minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45))),
      child: const Text('Sajili'),
    );
  }

  Widget errIMGFun(String erv) {
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
        sendDriverForm();
      },
      style: appStyles.defaultButtonStyles().copyWith(
          minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Symbols.check),
          SizedBox(width: 10),
          Text('Maliza'),
        ],
      ),
    );
  }

  Widget btnUploadImageLoader(bool lder, BuildContext context) {
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
        onPressed: () async {
          _navigateAndDisplaySelection(context);
        },
        style: appStyles.defaultButtonStyles().copyWith(
            minimumSize:
                const WidgetStatePropertyAll(Size(double.infinity, 45))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.photo_camera_rounded),
            SizedBox(width: 10),
            loadFromFile ? Text('Rudia kupiga Picha') : Text('Piga Picha'),
          ],
        ));
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen()),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!context.mounted) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.

    var image_id = await _storage.read(key: 'image_id');
    var image_path = await _storage.read(key: 'image_path');

    if (result != null) {
      // toast('${result[0]}');
      onlineImageId = result[1];
      setState(() {
        imageFile = File(result[0]);
        loadFromFile = true;
      });
    }
  }

  uploadPhotoOld() async {
    _loadingState = true;
    if (await Permission.camera.request().isGranted) {
      _onHorizontalLoading1();
      await Permission.storage.request();
      await Permission.photos.request();
      await Permission.camera.request();
      await Permission.mediaLibrary.request();

      var status = await Permission.camera.status;
      var storage_status = await Permission.photos.status;

      log('granted');
      var HasImage = await getImage(ImageSource.camera);
      if (HasImage) {
        var res = await _postMainApis.postProfile(
            _phoneNumberController.text, imageFile);

        int image_id;

        if (res != 0) {
          image_id = res;
        } else {
          image_id = 4;
        }

        Navigator.of(context).pop();
        setState(() {
          _loadingState = false;
          onlineImageId = image_id;
        });
      }
    }
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

  Widget bottomNav() {
    Size size = MediaQuery.of(context).size;
    if (showBottomNav) {
      return Container(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
        padding: EdgeInsets.only(left: 20, right: 8),
        width: size.width,
        height: 50,
        decoration: BoxDecoration(
            color: WAPrimaryColor, borderRadius: BorderRadius.circular(15.0)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Text('${pageNumber + 1}',
                  style: primaryTextStyle(size: 16, color: WAPrimaryColor)),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: buildDotIndicator(),
            ),
            pageNumber != 4
                ? TextButton(
                    onPressed: () {
                      pageController.nextPage(
                          duration: Duration(milliseconds: 250),
                          curve: Curves.fastOutSlowIn);
                    },
                    child: Text('Next',
                        style: primaryTextStyle(size: 16, color: Colors.white)),
                  )
                : TextButton(
                    onPressed: () async {},
                    child: Text('Uhakiki',
                        style: primaryTextStyle(size: 16, color: Colors.white)),
                  )
          ],
        ),
      );
    }
    return const SizedBox();
  }

  void _onHorizontalLoading1() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                Text(
                  "Inapakia Picha....",
                  style: primaryTextStyle(color: appStore.textPrimaryColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _validateForm(var1) {
    List<String?> items = var1;
    items.asMap().forEach((index, value) {
      if (index == 4) {
        if (value!.length < 10) leseniFocusNode.requestFocus();
      }

      if (value == null) {
        print(index);

        if (index == 5) makziFocusNode.requestFocus();
        if (index == 6) {
          if (DateTime.tryParse(value!) != null) monthFocusNode.requestFocus();
        }
        if (index == 7) genderFocusNode.requestFocus();
        if (index == 8) maritalFocusNode.requestFocus();
        if (index == 9) closePersonNameFocusNode.requestFocus();
        if (index == 10) closePersonPhoneFocusNode.requestFocus();

        if (index <= 10) {
          pageController.animateToPage(0,
              duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
        }
      }
    });

    if (!var1.contains(null)) {
      return false;
    } else {
      return true;
    }
  }
}
