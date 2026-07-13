import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/helpers/constantFunctions.dart';
import 'package:shirikisho/model/bima/bima_chombo_model.dart';
import 'package:shirikisho/model/region/chombo_model.dart';
import 'package:shirikisho/screen/bimachombo/components/SummaryWidgets.dart';
import 'package:shirikisho/screen/bimachombo/pdfView.dart';
import 'package:shirikisho/services/auth_service.dart';
import 'package:shirikisho/services/bima_chombo_apis.dart';
import 'package:shirikisho/services/region_service.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:shirikisho/utils/WAWidgets.dart';
import 'package:shirikisho/utils/widgets/dashdivider.dart';

class BimaChomboApplicationScreen extends StatefulWidget {
  const BimaChomboApplicationScreen({super.key});

  @override
  State<BimaChomboApplicationScreen> createState() =>
      _BimaChomboApplicationScreenState();
}

class _BimaChomboApplicationScreenState
    extends State<BimaChomboApplicationScreen> {
  BimaChomboApis _bimaChomboApis = BimaChomboApis();

  final _formKey = GlobalKey<FormState>();

  Timer? _timer;
  int _countdown = 30;

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController _chomboNambaTextController =
      TextEditingController();
  final TextEditingController _kitambulishoController = TextEditingController();
  bool isLoading = false;
  bool isLoading2 = false;
  bool formLoader = false;

  double total_pay = 0.0;

  int _activeStepIndex = 0;

  int selectedValue = 0;
  String mtandao = '';

  var loadermsg = '';

  List mitandaoList = ["airtel", "tigo", "voda"];
  List<vTypeModule> vehicleList = [];
  List<BimaPkgModel> vifurushiList = [];
  List<PaymentMethodModel> paymentMethodList = [];
  List<BimaLoanTypesModel> loanTypesList = [];
  List<LoanModel> loanList = [];
  LoanModel? singleLoan;

  vTypeModule? selectedVehicle;
  BimaPkgModel? selectedKifurushi;
  IdListModel? selectedId;
  PaymentMethodModel? selectedPaymentMethod;
  BimaLoanTypesModel? selectedLoanType;
  bool isLoading3 = true; // Declare at the top of your class

  Future<void> initialData() async {
    setState(() {
      isLoading3 = true; // Show loading
    });

    try {
      List<vTypeModule> vehicles = await loadVehicles();
      List<BimaPkgModel> vifurushi = await loadPackages();
      List<PaymentMethodModel> paymentMethods = await loadPaymentMethod();
      List<BimaLoanTypesModel> loanTypes = await loadLoanTypes();
      LoanModel? loans = await _bimaChomboApis.getUserLoans();

      setState(() {
        vehicleList.clear();
        vifurushiList.clear();
        paymentMethodList.clear();
        loanTypesList.clear();

        vehicleList.addAll(vehicles);
        vifurushiList.addAll(vifurushi);
        paymentMethodList.addAll(paymentMethods);
        loanTypesList.addAll(loanTypes);
        singleLoan = loans;
        isLoading3 = false; // Hide loading
      });
    } catch (e) {
      // print("Error fetching data: $e");
      setState(() {
        isLoading3 = false; // Hide loading on error
      });
    }

    setStatusBarColor(WAPrimaryColor, statusBarIconBrightness: Brightness.dark);
  }
  //  PDF VIEWER FROM ASSET PDF FILE

  String localAssetPDF = "";

  var message_mkopo = "";
  var mkopo_amount;
  bool agree = false;

  var feedback = false;
  var status;
  late AuthService authService;
  // late MKopoData vehicledata;
  var userName = "";
  var userPhone = "";
  var userJacket = "";
  var userImage = "";
  var isAdmin = false;
  var userId = "";
  var avatar = "/office/media/avatars/300-1.jpg";

  final _storage = const FlutterSecureStorage();
  // bool isLoading = false;

  Future<void> getUserData() async {
    authService.getUser();

    var user_id = await _storage.read(key: 'user_id');
    var token = await _storage.read(key: 'token');

    var name = await _storage.read(key: 'full_name');
    var phone = await _storage.read(key: 'user_phone');
    var uniform = await _storage.read(key: 'user_uniform_number');
    var image = await _storage.read(key: 'user_image');
    var isLeader = await _storage.read(key: 'user_is_leader');
    var plateNumber = await _storage.read(key: 'vehicle_number');

    // print("Token ::: ${token}  and user Plate Number ::: ${plateNumber}");

    setState(() {
      userId = user_id!;
      userName = name!;
      userPhone = phone!;
      userImage = image!;
      userJacket = uniform!;
      isAdmin = isLeader! == 'true' ? true : false;

      phoneNumberController.text = userPhone;
      _chomboNambaTextController.text = plateNumber!;
    });
    // print("user name $userName");

    // authService.getDriver(userId);
  }

  @override
  void initState() {
    super.initState();
    authService = AuthService();
    initialData();
    getUserData();
    fromAsset('assets/kmj_terms.pdf', 'kmj_terms.pdf').then((f) {
      setState(() {
        localAssetPDF = f.path;
      });
    });

    // startCountdown();
  }

  void stopCountdown() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fomu ya Maombi ya Bima",
          textScaler: TextScaler.noScaling,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phone
                    CustomDropdownField<vTypeModule>(
                      labelText: 'Aina ya Chombo',
                      labelStyle: boldTextStyle(size: 14, color: Colors.black),
                      selectedValue: selectedVehicle,
                      items: vehicleList,
                      itemLabel: (vTypeModule item) => item.name as String,
                      isDisabled: (vTypeModule item) => item.name == "Guta",
                      decoration: waInputDecoration(
                        hint: "Chagua Chombo",
                      ),
                      itemStyle: TextStyle(
                        fontSize: 16,
                        color: WAPrimaryColor,
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          selectedVehicle = value;

                          if (selectedPaymentMethod != null) {
                            if (selectedPaymentMethod?.method_name == "Loan") {
                              setState(() {
                                mkopo_amount = formatAmount(downPayment(
                                        selectedVehicle!.down_payment_percent,
                                        selectedVehicle!.total_amount)
                                    .toInt());
                              });
                            } else {
                              setState(() {
                                mkopo_amount =
                                    formatAmount(selectedVehicle?.total_amount);
                              });
                            }
                          }
                        }

                        // print("Coverage :: ${selectedVehicle?.coverage}");
                      },
                    ),

                    10.height,
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.only(left: 8),
                      alignment: Alignment.topLeft,
                      child: Text('Namba ya Chombo',
                          textScaler: TextScaler.noScaling,
                          style: boldTextStyle(size: 14, color: Colors.black)),
                    ),
                    AppTextField(
                      decoration: waInputDecoration(hint: 'MC *** ***'),
                      textFieldType: TextFieldType.NAME,
                      keyboardType: TextInputType.visiblePassword,
                      textStyle: primaryTextStyle(color: WAPrimaryColor),
                      controller: _chomboNambaTextController,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [plateFormatter],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Jaza.';
                        }
                        return null;
                      },
                    ),
                    10.height,
                    CustomDropdownField<BimaPkgModel>(
                      labelText: 'Aina ya Kifurushi',
                      labelStyle: boldTextStyle(size: 14, color: Colors.black),
                      selectedValue: selectedKifurushi,
                      items: vifurushiList,
                      itemLabel: (BimaPkgModel item) =>
                          item.package_name as String,
                      isDisabled: (BimaPkgModel item) =>
                          item.package_name == "Comprehensive",
                      decoration: waInputDecoration(
                        hint: "Chagua Kifurushi",
                      ),
                      itemStyle: TextStyle(
                        fontSize: 16,
                        color: WAPrimaryColor,
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          selectedKifurushi = value;
                        }
                      },
                    ),
                    10.height,

                    // KITAMBULISHO
                    CustomDropdownField<IdListModel>(
                      labelText: 'Aina ya Kitambulisho',
                      labelStyle: boldTextStyle(size: 14, color: Colors.black),
                      selectedValue: selectedId,
                      items: id_list, // Using id_list here
                      itemLabel: (IdListModel item) =>
                          item.name, // Updated to use name
                      isDisabled: (IdListModel item) =>
                          item.name == "Comprehensive", // Updated to use name
                      decoration:
                          waInputDecoration(hint: "Chagua Kitambulisho"),
                      itemStyle: TextStyle(
                        fontSize: 16,
                        color: WAPrimaryColor,
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedId = value;
                            print("Selected: ${value.name} (ID: ${value.id})");
                          });
                        }
                      },
                    ),

                    10.height,
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.only(left: 8),
                      alignment: Alignment.topLeft,
                      child: Text('Namba ya Kitambulisho cha Mmiliki wa Chombo',
                          textScaler: TextScaler.noScaling,
                          style: boldTextStyle(size: 14, color: Colors.black)),
                    ),
                    AppTextField(
                      decoration: waInputDecoration(hint: '1234567'),
                      textFieldType: TextFieldType.NAME,
                      keyboardType: TextInputType.visiblePassword,
                      textStyle: primaryTextStyle(color: WAPrimaryColor),
                      controller: _kitambulishoController,
                      // focus: chomboNoFocusNode,
                      textCapitalization: TextCapitalization.characters,
                      // // nextFocus: umilikiFocusNode,
                      // inputFormatters: [plateFormatter],

                      // inputFormatters: [plateNewFormatter],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Jaza.';
                        }
                        return null;
                      },
                    ),
                    10.height,
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.only(left: 8),
                      alignment: Alignment.topLeft,
                      child: Text('Njia za Malipo',
                          textScaler: TextScaler.linear(1),
                          style: boldTextStyle(size: 14, color: Colors.black)),
                    ),
                    DropdownButtonFormField(
                        isExpanded: true,
                        value: selectedPaymentMethod,
                        decoration: waInputDecoration(
                          hint: "Chagua Njia ya Malipo",
                        ),
                        items:
                            paymentMethodList.map((PaymentMethodModel? value) {
                          return DropdownMenuItem<PaymentMethodModel>(
                            value: value,
                            child: Text(
                              value!.method_name as String,
                              textScaler: TextScaler.noScaling,
                              style: TextStyle(
                                fontSize: 16,
                                color: WAPrimaryColor,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedPaymentMethod = value;
                          if (selectedPaymentMethod?.method_name == "Loan") {
                            setState(() {
                              mkopo_amount = formatAmount(downPayment(
                                      selectedVehicle!.down_payment_percent,
                                      selectedVehicle!.total_amount)
                                  .toInt());

                              message_mkopo =
                                  "Lipa Kianzio TZS ${mkopo_amount}";
                            });
                          } else {
                            setState(() {
                              mkopo_amount =
                                  formatAmount(selectedVehicle?.total_amount);
                              message_mkopo =
                                  "Unatakiwa Kulipa Jumla ya TZS ${mkopo_amount}";
                            });
                          }
                        }),

                    10.height,
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.only(left: 8),
                      alignment: Alignment.topLeft,
                      child: Text('Aina ya Mkopo',
                          textScaler: TextScaler.linear(1),
                          style: boldTextStyle(size: 14, color: Colors.black)),
                    ),
                    DropdownButtonFormField(
                        isExpanded: true,
                        value: selectedLoanType,
                        decoration: waInputDecoration(
                          hint: "Chagua Aina ya Mkopo",
                        ),
                        items: loanTypesList.map((BimaLoanTypesModel? value) {
                          final Map<int, String> messages = {
                            1: "${selectedVehicle?.daily_paid_amount.toString()} kwa siku",
                            2: "${selectedVehicle?.weekly_paid_amount.toString()} kwa wiki",
                            3: "${selectedVehicle?.monthly_paid_amount.toString()} kwa mwezi",

                            // Add more id-specific messages here...
                          };
                          return DropdownMenuItem<BimaLoanTypesModel>(
                            value: value,
                            child: Text(
                              selectedVehicle == null
                                  ? "Jaza Taarifa za awali kwanza"
                                  : "${value!.name as String} - ${messages[value.id]}",
                              textScaler: TextScaler.noScaling,
                              style: TextStyle(
                                fontSize: 14,
                                color: WAPrimaryColor,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedLoanType = value;
                        }),
                    5.height,

                    Row(
                      children: [
                        Checkbox(
                          activeColor: WAPrimaryColor,
                          value: agree,
                          onChanged: (value) {
                            setState(() {
                              agree = value!;
                            });
                          },
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: 'Kubali ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PDFScreen(
                                              path: localAssetPDF,
                                              name: userName,
                                            )));
                              },
                            text: 'Vigezo na masharti',
                            style: TextStyle(
                                color: WAPrimaryColor,
                                decoration: TextDecoration.underline,
                                fontSize: 12),
                          ),
                        ]))
                      ],
                    ),
                    if (selectedPaymentMethod != null) ...[
                      10.height,
                      Center(
                        child: Text(
                          message_mkopo,
                          textScaler: TextScaler.noScaling,
                          style: boldTextStyle(size: 16, color: WAPrimaryColor),
                        ),
                      ),
                    ],
                    20.height,
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        // var res =
                        //     await _bimaChomboApis.makePaymentOfLoanRequested(2);

                        // print(agree);
                        // BimaSummaryScreen().launch(context);
                        // FULL CHECKER FOR VEHIVLE PLATE AND  PROCEED WITH SUMMARY

                        if (agree) {
                          if (selectedKifurushi != null &&
                              selectedPaymentMethod != null &&
                              selectedVehicle != null) {
                            var res = await _bimaChomboApis.verifyChombo(
                                _chomboNambaTextController.text.trim());
                            if (res["status"] == "success") {
                              toasty(context, "Namba ya Chombo imethibitishwa",
                                  textColor: Colors.white,
                                  bgColor: Colors.green,
                                  duration: Duration(seconds: 2));
                              Future.delayed(Duration(seconds: 1), () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        summaryDialog());
                                setState(() {
                                  isLoading = false;
                                });
                              });
                              setState(() {
                                isLoading = false;
                              });
                            } else if (res["status"] == "fail") {
                              toasty(context,
                                  "Hauwezi kuendelea Chombo chako hakitambuliki/ hakina usajili ",
                                  textColor: Colors.white,
                                  bgColor: Colors.red,
                                  duration: Duration(seconds: 3));
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              toasty(context,
                                  "Samahani tumeshindwa kuhakiki chombo, kuna tatizo la kimtandao jaribu tena",
                                  textColor: Colors.white,
                                  bgColor: Colors.red,
                                  duration: Duration(seconds: 5));
                              setState(() {
                                isLoading = false;
                              });
                            }
                          } else {
                            toasty(context,
                                "Tafadhali Hakikisha umejaza machaguo yote.",
                                textColor: Colors.white,
                                bgColor: Colors.red,
                                duration: Duration(seconds: 2));
                            setState(() {
                              isLoading = false;
                            });
                          }
                        } else {
                          toasty(
                              context, "Tafadhali kubali masharti na vigezo.",
                              textColor: Colors.white,
                              bgColor: Colors.red,
                              duration: Duration(seconds: 2));
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WAPrimaryColor,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1.5,
                            )
                          : Text(
                              'Endelea',
                              textScaler: TextScaler.linear(1.1),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
// our loader
          if (isLoading3)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: WAPrimaryColor,
                    ),
                    10.height,
                    Text(
                      'Tafadhali Subiri ....',
                      textScaler: TextScaler.noScaling,
                      style: boldTextStyle(size: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget summaryDialog() {
    return StatefulBuilder(builder: (Builder, setState) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 1.0,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Text(
                    "Mchanganuo wa Bima",
                    textScaler: TextScaler.noScaling,
                    style: boldTextStyle(
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                  20.height,
                  InfoRow(
                    label: 'Jina Kamili',
                    value: userName,
                    labelStyle: primaryTextStyle(),
                    valueStyle: boldTextStyle(size: 14, color: Colors.black),
                  ),
                  Divider(
                    color: Colors.black12,
                    thickness: 0.5,
                  ),
                  InfoRow(
                    label: 'Namba ya Simu',
                    value: userPhone,
                    labelStyle: primaryTextStyle(),
                    valueStyle: boldTextStyle(size: 14, color: Colors.black),
                  ),
                  Divider(
                    color: Colors.black12,
                    thickness: 0.5,
                  ),
                  InfoRow(
                    label: 'Aina ya Kitambulisho',
                    value: selectedId?.name ?? '',
                    labelStyle: primaryTextStyle(),
                    valueStyle: boldTextStyle(size: 14, color: Colors.black),
                  ),
                  Divider(
                    color: Colors.black12,
                    thickness: 0.5,
                  ),
                  InfoRow(
                    label: 'Namba ya kitambulisho',
                    value: _kitambulishoController.text,
                    labelStyle: primaryTextStyle(),
                    valueStyle: boldTextStyle(size: 14, color: Colors.black),
                  ),
                  Divider(
                    color: Colors.black12,
                    thickness: 0.5,
                  ),
                  InfoRow(
                    label: 'Namba ya Chombo',
                    value: _chomboNambaTextController.text,
                    // value: selectedVehicle!.coverage ?? "",
                    labelStyle: primaryTextStyle(),
                    valueStyle: boldTextStyle(size: 14, color: Colors.black),
                  ),
                  Divider(
                    color: Colors.black12,
                    thickness: 0.5,
                  ),
                  InfoRow(
                    label: 'Aina ya Chombo',
                    value: selectedVehicle != null
                        ? selectedVehicle?.name as String
                        : "Hujachagua chombo",
                    labelStyle: primaryTextStyle(),
                    valueStyle: boldTextStyle(size: 14, color: Colors.black),
                  ),
                  Divider(
                    color: Colors.black12,
                    thickness: 0.5,
                  ),
                  InfoRow(
                    label: 'Aina ya Kifurushi',
                    value: selectedKifurushi != null
                        ? selectedKifurushi?.package_name as String
                        : "hujachagua kifurushi",
                    labelStyle: primaryTextStyle(),
                    valueStyle: boldTextStyle(size: 14, color: Colors.black),
                  ),
                  Divider(
                    color: Colors.black12,
                    thickness: 0.5,
                  ),
                  InfoRow(
                    label: 'Tarehe ya Maombi',
                    value: currentDate(),
                    labelStyle: primaryTextStyle(),
                    valueStyle: boldTextStyle(size: 14, color: Colors.black),
                  ),
                  Divider(
                    color: Colors.black12,
                    thickness: 0.5,
                  ),
                  InfoRow(
                    label: 'Njia ya Malipo',
                    value: selectedPaymentMethod != null
                        ? selectedPaymentMethod?.method_name as String
                        : "Hujachagua Njia ya Malipo",
                    labelStyle: primaryTextStyle(),
                    valueStyle: boldTextStyle(size: 14, color: Colors.black),
                  ),
                  DashedDivider(
                    height: 2,
                    dashWidth: 5,
                    color: Colors.black,
                  ),
                  60.height,
                  if (selectedPaymentMethod?.method_name == "Loan") ...[
                    InfoRow(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      label: 'Muda wa Malipo',
                      value: selectedLoanType?.name ?? "",
                      // value: selectedVehicle != null
                      //     ? "Miezi ${selectedVehicle?.installment_duration.toString()}"
                      //     : "--",
                      labelStyle: primaryTextStyle(),
                      valueStyle: boldTextStyle(size: 15, color: Colors.black),
                    ),
                    InfoRow(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      label: 'Malipo ya Awali',
                      value: selectedVehicle != null
                          ? formatAmount(downPayment(
                                  selectedVehicle!.down_payment_percent,
                                  selectedVehicle!.total_amount)
                              .toInt())
                          : "0",
                      labelStyle: primaryTextStyle(),
                      valueStyle: boldTextStyle(size: 15, color: Colors.black),
                    ),
                    InfoRow(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      label: 'Malipo ya Awamu',
                      value: selectedVehicle != null
                          ? formatAmount(remainAmount(
                                  selectedVehicle!.down_payment_percent,
                                  selectedVehicle!.total_amount)
                              .toInt())
                          : "0",
                      labelStyle: primaryTextStyle(),
                      valueStyle: boldTextStyle(size: 15, color: Colors.black),
                    ),
                    if (selectedLoanType?.id == 3) ...[
                      InfoRow(
                        margin: EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.only(left: 8),
                        label: 'Malipo ya Kila Mwezi',
                        value: selectedVehicle != null
                            ? formatAmount(selectedVehicle?.monthly_paid_amount)
                            : "0",
                        labelStyle: primaryTextStyle(),
                        valueStyle:
                            boldTextStyle(size: 15, color: Colors.black),
                      )
                    ],
                    if (selectedLoanType?.id == 2) ...[
                      InfoRow(
                        margin: EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.only(left: 8),
                        label: 'Malipo kwa wiki',
                        value: selectedVehicle != null
                            ? formatAmount(selectedVehicle?.weekly_paid_amount)
                            : "0",
                        labelStyle: primaryTextStyle(),
                        valueStyle:
                            boldTextStyle(size: 15, color: Colors.black),
                      ),
                    ],
                    if (selectedLoanType?.id == 1) ...[
                      InfoRow(
                        margin: EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.only(left: 8),
                        label: 'Malipo kwa Siku',
                        value: selectedVehicle != null
                            ? formatAmount(selectedVehicle?.daily_paid_amount)
                            : "0",
                        labelStyle: primaryTextStyle(),
                        valueStyle:
                            boldTextStyle(size: 15, color: Colors.black),
                      ),
                    ],
                  ],
                  InfoRow(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.only(left: 8),
                    label: 'Jumla Kuu',
                    value: selectedVehicle != null
                        // ? selectedVehicle!.total_amount.toString()
                        ? formatAmount(selectedVehicle?.total_amount)
                        : "0",
                    labelStyle: primaryTextStyle(),
                    valueStyle: boldTextStyle(size: 15, color: Colors.black),
                  ),
                  10.height,
                  mitandaoWidget(),
                  10.height,
                  Center(
                    child: Text(
                      message_mkopo,
                      textScaler: TextScaler.noScaling,
                      style: boldTextStyle(size: 16, color: WAPrimaryColor),
                    ),
                  ),
                  20.height,
                  AppTextField(
                    controller: phoneNumberController,
                    textFieldType: TextFieldType.NUMBER,
                    decoration: waInputDecoration(
                      hint: "namba ya simu",
                    ),
                  ),
                  Text("Tumia namba yako kulipia , au weka namba nyingine.",
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(
                        fontSize: 12,
                        // color: Color.fromRGBO(255, 87, 51, 1),
                        color: WAPrimaryColor,
                      )),
                  20.height,
                  ElevatedButton(
                    onPressed: isLoading2
                        ? null
                        : () async {
                            setState(() {
                              isLoading2 = true;
                              loadermsg = "Tafadhali Kamilisha Malipo";
                            });

                            var res = await _bimaChomboApis.saveMkopo(
                                cleanPlate(_chomboNambaTextController.text),
                                // "T171EEK",
                                selectedVehicle?.coverage,
                                // phoneNumberController.text,
                                formatPhoneNumber(phoneNumberController.text),
                                selectedId?.id,
                                _kitambulishoController.text,
                                selectedKifurushi?.id,
                                selectedPaymentMethod?.id,
                                selectedVehicle?.id,
                                selectedLoanType?.id);

                            if (res['status'] == "success") {
                              // HANDLE RESPONSES MESSAGE
                              if (res['provider_message'] == 'Successful') {
                                toasty(context,
                                    "Mkopo wako umetengenezwa kikamilifu.",
                                    textColor: Colors.white,
                                    bgColor: Colors.grey,
                                    duration: Duration(seconds: 4),
                                    gravity: ToastGravity.CENTER);

                                // Wait for the toast duration (5 seconds) before proceeding
                                await Future.delayed(Duration(seconds: 4));
                              } else {
                                toasty(context,
                                    "Mkopo wako umefanikiwa kutengenezwa ila wasiliana na viongozi kwa ajili ya kuweka sawa hili swala : \n ${res['provider_message']}",
                                    textColor: Colors.white,
                                    bgColor: Colors.grey,
                                    duration: Duration(seconds: 5),
                                    gravity: ToastGravity.CENTER);

                                // Wait for the toast duration (5 seconds) before proceeding
                                await Future.delayed(Duration(seconds: 5));
                              }
                              var checkRes = await _bimaChomboApis
                                  .paymentStatus(res['loan_id']);

                              if (checkRes['status'] == "success" &&
                                  checkRes['message'] == "paid") {
                                toasty(context,
                                    "Hongera umefanikiwa kufanya malipo ya mkopo wako",
                                    textColor: Colors.white,
                                    bgColor: Colors.green,
                                    duration: Duration(seconds: 3));

                                setState(() {
                                  isLoading2 = false;
                                });

                                // Close the dialog when loading is complete

                                await delayedNavigatorPop(context, 3000);
                                await delayedNavigatorPop(context, 50);
                                await delayedNavigatorPop(context, 50);
                              } else {
                                // Close the dialog when loading is complete

                                toasty(context,
                                    "Muamala haujakamilika,Tafadhali tembelea maendeleo ya mkopo wako kukamilisha malipo ya awali",
                                    textColor: Colors.white,
                                    bgColor: Colors.orange,
                                    duration: Duration(seconds: 5));

                                setState(() {
                                  isLoading2 = false;
                                });
                                await delayedNavigatorPop(context, 5000);
                                await delayedNavigatorPop(context, 50);
                                await delayedNavigatorPop(context, 50);
                              }

                              // await delayedNavigatorPop(context, 50);
                            } else if (res['status'] == "fail") {
                              setState(() {
                                isLoading2 = false;
                              });
                              toasty(context,
                                  "Malipo ya mkopo yameshindikana. \n ${res['message']}",
                                  textColor: Colors.white,
                                  bgColor: Colors.red,
                                  duration: Duration(seconds: 5));

                              setState(() {
                                isLoading2 = false;
                              });
                            } else {
                              setState(() {
                                isLoading2 = false;
                              });

                              toasty(context, "${res['message']}",
                                  textColor: Colors.white,
                                  bgColor: Colors.red,
                                  duration: Duration(seconds: 5));

                              setState(() {
                                isLoading2 = false;
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WAPrimaryColor,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: isLoading2
                        // ? CircularProgressIndicator(
                        //     color: Colors.white,
                        //     strokeWidth: 1.5,
                        //   )
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Kamilisha Malipo  ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                                // value: 24,
                              )
                            ],
                          )
                        : Text(
                            'Lipia',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Powered by"),
                      Image.asset(
                        "assets/logo/papihumtech.png",
                        height: 40,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<bool> checkMkopoStatusLoop(BuildContext context, int mkopoId) async {
    for (int i = 0; i < 6; i++) {
      await Future.delayed(Duration(seconds: 5));

      var checkRes = await _bimaChomboApis.paymentStatus(mkopoId);

      if (checkRes['status'] == "success" && checkRes['message'] == "paid") {
        // print("Mkopo completed");
        toasty(context, "Malipo ya Mkopo yamekamilika",
            textColor: Colors.white,
            bgColor: Colors.green,
            duration: Duration(seconds: 5));
        return true; // Exit loop once the status is completed
      }

      if (i > 1) {
        setState(() {
          loadermsg = "Tafadhali Subiri Muamala wako unafanyiwa kazi";
        });
      }
    }

    // If the loop finishes and status is not completed
    toasty(context, "Malipo ya Mkopo hayajakamilika",
        textColor: Colors.white,
        bgColor: Colors.orange,
        duration: Duration(seconds: 5));

    return false;
  }

  void startCountdown() {
    setState(() {
      _countdown = 30; // Reset countdown to 30 seconds
    });

    // Cancel any previous timer
    _timer?.cancel();

    // Start a new timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--; // Decrease countdown
        });
      } else {
        timer.cancel(); // Stop the timer when it reaches 0
      }
    });
  }

  Widget loaderDialog() {
    return StatefulBuilder(
      builder: (Builder, setState) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: context.scaffoldBackgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: defaultBoxShadow(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  20.height,
                  Center(
                    child: CircularProgressIndicator(
                      color: WAPrimaryColor,
                    ),
                  ),
                  10.height,
                  Center(
                    child: Text(
                      '${loadermsg} ...',
                      textScaler: TextScaler.noScaling,
                      overflow: TextOverflow.clip,
                      style: boldTextStyle(color: WAPrimaryColor),
                    ),
                  ),
                  20.height,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
