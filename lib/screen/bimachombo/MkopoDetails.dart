import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/component/Loader.dart';
import 'package:shirikisho/component/circularPercentIndicator.dart';
import 'package:shirikisho/global/environment.dart';
import 'package:shirikisho/helpers/constantFunctions.dart';
import 'package:shirikisho/model/bima/bima_chombo_model.dart';
import 'package:shirikisho/screen/bima/components/bimacart.dart';
import 'package:shirikisho/screen/bimachombo/BimaChomboApplicationScreen.dart';
import 'package:shirikisho/screen/bimachombo/MkopoStatus.dart';
import 'package:shirikisho/screen/bimachombo/components/SummaryWidgets.dart';
import 'package:shirikisho/services/auth_service.dart';
import 'package:shirikisho/services/bima_chombo_apis.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:shirikisho/utils/WAWidgets.dart';

class MkopoBimaDetails extends StatefulWidget {
  const MkopoBimaDetails({super.key});

  @override
  State<MkopoBimaDetails> createState() => _MkopoBimaDetailsState();
}

class _MkopoBimaDetailsState extends State<MkopoBimaDetails> {
  BimaChomboApis _bimaChomboApis = BimaChomboApis();

  bool isLoading = false;
  bool isUploading = false;
  bool coverLoading = false;
  bool covernoteButton = false;

  var malipo_kiasi;
  var malipo_muda;
  var msg;
  double totalPaidAmount = 0; // Declare at the top of your class

  int selectedMonthIndex = -1;
  List<String> monthOptions = ["1", "3", "6", "12"];
  List<String> amountOptions = ["1,000", "3,000", "5,000", "10,000"];
  List<String> timeOptions = ["siku", "wiki", "mwezi", "yote"];

  String kiasi = "0";
  String miezi = "0";

  List<LoanModel> loanList = [];
  LoanModel? singleLoan;
  List installmentList = [];

  Future<void> initialData() async {
    setState(() {
      isUploading = true;
    });
    // List<LoanModel> loans = await _bimaChomboApis.getUserLoans();
    LoanModel? loans = await _bimaChomboApis.getUserLoans();

    if (loans?.status == 'active') {
      setState(() {
        // loanList.addAll(loans);
        singleLoan = loans;
        // covernoteButton = true;
      });
    } else {
      setState(() {
        // loanList.addAll(loans);

        // singleLoan = singleLoan; //kutoa mkopo kama haujakamilika usionekane

        singleLoan = loans;
        // covernoteButton = false;
      });
    }

    if (loans != null) {
      installmentData(loans.id);

      if (loans.loan_type?.id == 1) {
        malipo_kiasi = loans.vehicle_type?.daily_paid_amount;
        malipo_muda = loans.loan_type?.name;
        msg = "kila siku";
      } else if (loans.loan_type?.id == 2) {
        malipo_kiasi = loans.vehicle_type?.weekly_paid_amount;

        malipo_muda = loans.loan_type?.name;
        msg = "kila wiki";
      } else {
        malipo_kiasi = loans.vehicle_type?.monthly_paid_amount;
        malipo_muda = loans.loan_type?.name;
        msg = "kila mwezi";
      }

      setState(() {
        amountController.text = malipo_kiasi.toString();
      });
      if (loans.request?.response?.covernote_id != null) {
        // print("covernote id ${loans.request!.response?.covernote_id}");
        var res = await _bimaChomboApis
            .checkCovernoteInfo(loans.request?.response?.covernote_id);
      }
    }

    // print("kiasi cha kulipa  $malipo_kiasi $msg kwa  muda wa $malipo_muda");

    setStatusBarColor(WAPrimaryColor, statusBarIconBrightness: Brightness.dark);
    await Future.delayed(Duration(milliseconds: 500), () {
      CircularProgressIndicator();
    });
    setState(() {
      isUploading = false;
    });
  }

  Future<void> installmentData(int ID) async {
    setState(() {
      isUploading = true;
    });
    List installments = await _bimaChomboApis.getInstallments(ID);

    setState(() {
      installmentList.addAll(installments);
    });

    // print("installments ${installmentList}");

    // Check the first installment (installment_number == 1)
    if (installmentList.isNotEmpty) {
      // print("before first installment :: ${installmentList[0]}");

      // Assuming installmentList[0] is always installment_number == 1
      if (installmentList[0]['status'] == "paid") {
        print("success");
        setState(() {
          covernoteButton = true;
        });
      } else {
        print("First installment not paid");
        setState(() {
          covernoteButton = false;
        });
      }
    } else {
      print("installmentList is empty");
    }

    setStatusBarColor(WAPrimaryColor, statusBarIconBrightness: Brightness.dark);
    await Future.delayed(Duration(milliseconds: 500), () {
      CircularProgressIndicator();
    });
    setState(() {
      isUploading = false;
    });
  }

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

  Future<void> getUserData() async {
    authService.getUser();

    var user_id = await _storage.read(key: 'user_id');
    var name = await _storage.read(key: 'full_name');
    var phone = await _storage.read(key: 'user_phone');
    var uniform = await _storage.read(key: 'user_uniform_number');
    var image = await _storage.read(key: 'user_image');
    var isLeader = await _storage.read(key: 'user_is_leader');
    var token = await _storage.read(key: "token");

    setState(() {
      userId = user_id!;
      userName = name!;
      userPhone = phone!;
      userImage = image!;
      userJacket = uniform!;
      isAdmin = isLeader! == 'true' ? true : false;
      phoneController.text = phoneFormat(userPhone);
    });

    // print("user name $userName   my token $token");
  }

  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    authService = AuthService();

    getUserData();

    initialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bima ya Chombo',
              textScaler: TextScaler.noScaling,
              style: boldTextStyle(color: Colors.black, size: 20),
            ),
            1.width,
            isLoading
                ? CircularProgressIndicator(
                    color: WAPrimaryColor,
                  )
                : Container(),
          ],
        ),
        centerTitle: true,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Icon(Icons.arrow_back),
        ).onTap(() {
          finish(context);
        }),
        actions: [],
      ),
      body: isUploading
          // ? Center(
          //     child: CircularProgressIndicator(
          //       color: WAPrimaryColor,
          //     ),
          //   )
          ? customLoader(context)
          : Container(
              height: context.height(),
              width: context.width(),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/walletApp/wa_bg.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.9,
                ),
                color: Colors.black,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    20.height,
                    singleLoan == null
                        ? _buildNoInsuranceMessage(context)
                        : Column(
                            children: [
                              100.height,
                              PaymentCard(
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    "",
                                    // images/walletApp/placeholder.jpg
                                currency: "TZS",
                                cardNumber: "cardNumber",
                                validity: singleLoan?.request?.response
                                        ?.covernote_end_date ??
                                    "",
                                start: singleLoan?.request?.response
                                        ?.covernote_start_date ??
                                    "",
                                // validity: singleLoan?.request?.end_date ?? "",
                                // start: singleLoan?.request?.start_date ?? "",
                                colors: Colors.white,
                                holder: userName,
                                title: "BIMA YA CHOMBO",
                                status: true,
                                statusAppear: true,
                                imagePkg: "",
                                userProfile: userImage,
                                companyLogo: "assets/bima/sanlam.png",
                                companyLogo2: "assets/logo/kmj.png",
                                secondComp: true,
                              ),
                              20.height,
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                              context.width() * 0.36,
                                              context.height() * 0.05),

                                          // primary: Colors.blue, // Use your app's primary color
                                          backgroundColor: Colors.blueGrey,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        onPressed: covernoteButton
                                            ? () async {
                                                // await Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         PdfViewerScreen(
                                                //       pdfUrl:
                                                //           'https://portal.bimakwik.com/api/print-motor/${singleLoan?.request?.response?.covernote_id}',
                                                //       name: userName,
                                                //     ),
                                                //   ),
                                                // );

                                                if (singleLoan
                                                        ?.request
                                                        ?.response
                                                        ?.covernote_id !=
                                                    null) {
                                                  var res =
                                                      await getCovernoteLink(
                                                          singleLoan!
                                                              .request!
                                                              .response!
                                                              .covernote_id);
                                                }
                                              }
                                            : null,
                                        child: Center(
                                          child: coverLoading
                                              ? CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : Text(
                                                  "Hati ya Bima",
                                                  textScaler:
                                                      TextScaler.noScaling,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                ),
                                        ),
                                      ),
                                    ),
                                    20.width,
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                              context.width() * 0.36,
                                              context.height() * 0.05),
                                          // primary: Colors.blue, // Use your app's primary color
                                          backgroundColor: WAPrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MkopoBimaStatus(
                                                        mkopoData: singleLoan,
                                                        malipo_kiasi:
                                                            malipo_kiasi
                                                                .toString(),
                                                        malipo_muda:
                                                            malipo_muda,
                                                        msg: msg,
                                                      )));
                                        },
                                        child: Center(
                                          child: Text(
                                            "Maendeleo",
                                            textScaler: TextScaler.noScaling,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ),
    );
  }

  Future getCovernoteLink(int covernoteId) async {
    var token = await _storage.read(key: 'token');
    setState(() {
      coverLoading = true;
    });
    try {
      var res = await http.get(
        Uri.parse('${Environment.apiUrl}/sendCovernote/$covernoteId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      
      // print("response ${res.statusCode}");
      // print("response ${res.body}");


      if (res.statusCode == 200) {
        // print("empty");
        toasty(context,
            "Anwani ya hati ya bima yako imetumwa kikamilifu tafadhali bonyeza anwani ya wavuti iliopo kwenye ujumbe mfupi.",
            bgColor: Colors.green,
            textColor: Colors.white,
            duration: Duration(seconds: 5));
        return true;
      } else {
        print("");
        toasty(context,
            "Samahani, kuna tatizo la kimfumo, hati yako haijapatikana",
            bgColor: Colors.orange,
            textColor: Colors.white,
            duration: Duration(seconds: 5));
        return true;
      }
    } catch (e) {
      print(e);

      toasty(context, "Samahani, kuna tatizo la mtandao, tafadhali jaribu tena",
          bgColor: Colors.red,
          textColor: Colors.white,
          duration: Duration(seconds: 5));
      return true;
    } finally {
      setState(() {
        coverLoading = false;
      });
    }
  }

  Widget _mkopoList(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        // itemCount: loanList.length,
        itemCount: 1,

        itemBuilder: (context, index) {
          // final loan = loanList[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              onTap: () {
                MkopoBimaStatus(mkopoData: singleLoan).launch(context);
              },
              title: Text(
                'Loan ID: ${singleLoan?.id}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Loan Type ID: ${singleLoan?.id}'),
                  Text('Vehicle Type ID: ${singleLoan?.vehicleTypeId}'),
                  Text('Total Amount: TZS ${singleLoan?.totalAmount}'),
                  Text('Status: ${singleLoan?.packageId}'),
                ],
              ),
            ),
          ).paddingSymmetric(horizontal: 8);
        },
      ),
    );
  }

  Widget _buildNoInsuranceMessage(BuildContext context) {
    return Container(
      height: context.height(),
      width: context.width(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/walletApp/wa_bg.jpg'),
          fit: BoxFit.cover,
          opacity: 0.9,
        ),
        color: Colors.black,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            80.height,
            Image.asset(
              'assets/bima/no ins.png',
              height: 150,
            ),
            32.height,
            Text('Hauna Bima!',
                textScaler: TextScaler.linear(1),
                style: boldTextStyle(size: 20)),
            16.height,
            Text(
              'Hauna Bima ya Chombo, Tafadhali omba bima.',
              style: secondaryTextStyle(),
              textScaler: TextScaler.linear(1),
              textAlign: TextAlign.center,
            ).paddingSymmetric(vertical: 8, horizontal: 60),
            50.height,
            AppButton(
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(30)),
              color: WAPrimaryColor,
              elevation: 10,
              onTap: () async {
                // BimaChomboApplicationScreen().launch(context);
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BimaChomboApplicationScreen()));
              },
              child: Text('Omba Bima',
                      textScaler: TextScaler.linear(1),
                      style: boldTextStyle(color: Colors.white))
                  .paddingSymmetric(horizontal: 32),
            ),
          ],
        ).paddingAll(30),
      ),
    );
  }

  Widget mkopoInformation(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: context.height(),
      width: context.width(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/walletApp/wa_bg.jpg'),
          fit: BoxFit.cover,
          opacity: 0.9,
        ),
        color: Colors.black,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              80.height,
              Container(
                width: screenWidth,
                // height: screenWidth * 0.19,
                height: 72,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      // " TZS 60,000",
                      "TZS ${singleLoan?.remainBalance.toString() ?? ''}",
                      style: boldTextStyle(
                          size: 36,
                          color: WAPrimaryColor,
                          weight: FontWeight.w900),
                    ),
                    10.height,
                    Text(
                      "Kiasi Kilichobakia",
                      style: primaryTextStyle(size: 16),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16)),
              ),

              20.height,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.only(left: 8),
                    // alignment: Alignment.topLeft,
                    alignment: Alignment.center,
                    child: Text('Tarehe ya Kuanza mkopo',
                        textScaler: TextScaler.noScaling,
                        style: primaryTextStyle()),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.only(left: 8),
                    // alignment: Alignment.topLeft,
                    alignment: Alignment.center,

                    child: Text(
                        // currentDate(),
                        singleLoan?.request?.response?.covernote_start_date ??
                            '',
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(size: 16, color: Colors.black)),
                  ),
                ],
              ),
              Divider(
                color: Colors.black12,
                thickness: 0.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.only(left: 8),
                    // alignment: Alignment.topLeft,
                    alignment: Alignment.center,
                    child: Text('Tarehe ya Kumaliza mkopo',
                        textScaler: TextScaler.noScaling,
                        style: primaryTextStyle()),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.only(left: 8),
                    // alignment: Alignment.topLeft,
                    alignment: Alignment.center,

                    child: Text(
                        // currentDate(),
                        singleLoan?.request?.response?.covernote_end_date ?? '',
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(size: 16, color: Colors.black)),
                  ),
                ],
              ),
              Divider(
                color: Colors.black12,
                thickness: 0.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.only(left: 8),
                    // alignment: Alignment.topLeft,
                    alignment: Alignment.center,
                    child: Text('Jumla ya malipo (mkopo + riba)',
                        textScaler: TextScaler.noScaling,
                        style: primaryTextStyle()),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.only(left: 8),
                    // alignment: Alignment.topLeft,
                    alignment: Alignment.center,

                    child: Text(
                        // '73,700',
                        "${singleLoan?.remainBalance.toString() ?? ''}",
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(size: 16, color: Colors.black)),
                  ),
                ],
              ),
              Divider(
                color: Colors.black12,
                thickness: 0.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.only(left: 8),
                    // alignment: Alignment.topLeft,
                    alignment: Alignment.center,
                    child: Text('Kiasi kilicholipwa',
                        textScaler: TextScaler.noScaling,
                        style: primaryTextStyle()),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.only(left: 8),
                    // alignment: Alignment.topLeft,
                    alignment: Alignment.center,

                    child: Text(
                        // '13,700',
                        singleLoan?.paidAmount.toString() ?? '',
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(size: 16, color: Colors.black)),
                  ),
                ],
              ),
              Divider(
                color: Colors.black12,
                thickness: 0.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.only(left: 8),
                    // alignment: Alignment.topLeft,
                    alignment: Alignment.center,
                    child: Text('Penati',
                        textScaler: TextScaler.noScaling,
                        style: primaryTextStyle()),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.only(left: 8),
                    // alignment: Alignment.topLeft,
                    alignment: Alignment.center,

                    child: Text('0',
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(size: 16, color: Colors.black)),
                  ),
                ],
              ),
              Divider(
                color: Colors.black12,
                thickness: 0.5,
              ),

              30.height,

              CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 20.0,
                animation: true,
                // percent: 0.7,
                percent: percentage(singleLoan?.paidAmount ?? 0.0,
                    singleLoan?.totalAmount ?? 0.0),
                center: Text(
                  // "70.0%",
                  " ${(percentage(singleLoan?.paidAmount ?? 0.0, singleLoan?.totalAmount ?? 0.0) * 100).toString()}%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                header: Text(
                  "Maendeleo ya mkopo",
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),

                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.green,
              ),
              30.height,

              isUploading
                  ? CircularProgressIndicator(
                      color: WAPrimaryColor,
                    )
                  : Center(
                      child: Text(
                        "Unapaswa kulipa kiasi cha ${malipo_kiasi} ${msg} ndani ya ${malipo_muda}",
                        overflow: TextOverflow.clip,
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(size: 16, color: Colors.black),
                      ),
                    ),

              // GestureDetector(
              //   onTap: () async {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => PdfViewerScreen(
              //             pdfUrl:
              //                 'https://portal.bimakwik.com/api/print-motor/${singleLoan?.request?.response?.covernote_id}'),
              //       ),
              //     );
              //   },
              //   child: coverNoteDocuments(
              //       size: size, file_name: "Cover Note", file_path: "path_url"),
              // ),

              10.height,
              mitandaoWidget(),
              // 10.height,
              // AppTextField(
              //   controller: amountController,
              //   textFieldType: TextFieldType.NUMBER,
              //   decoration:
              //       waInputDecoration(hint: "kiasi", bgColor: Colors.white),
              // ),

              10.height,
              AppTextField(
                controller: phoneController,
                textFieldType: TextFieldType.NUMBER,
                decoration: waInputDecoration(
                    hint: "namba ya simu", bgColor: Colors.white),
              ),
              Text("Tumia namba yako kulipia , au weka namba nyingine ",
                  textScaler: TextScaler.linear(1.0),
                  style: TextStyle(
                    fontSize: 12,
                    // color: Color.fromRGBO(255, 87, 51, 1),
                    color: WAPrimaryColor,
                  )),
              10.height,
              ElevatedButton(
                onPressed: () {},
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
                        'Lipia',
                        textScaler: TextScaler.noScaling,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
              10.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Powered by",
                    textScaler: TextScaler.noScaling,
                  ),
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
    );
  }
}
