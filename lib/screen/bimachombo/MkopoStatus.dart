import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/component/circularPercentIndicator.dart';
import 'package:shirikisho/helpers/constantFunctions.dart';
import 'package:shirikisho/model/bima/bima_chombo_model.dart';
import 'package:shirikisho/screen/bimachombo/components/SummaryWidgets.dart';
import 'package:shirikisho/services/auth_service.dart';
import 'package:shirikisho/services/bima_chombo_apis.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:shirikisho/utils/WAWidgets.dart';

class MkopoBimaStatus extends StatefulWidget {
  MkopoBimaStatus(
      {super.key,
      this.mkopoData,
      this.malipo_kiasi,
      this.malipo_muda,
      this.msg,
      this.onUpdateMkopoData});
  LoanModel? mkopoData;
  final String? malipo_kiasi;
  final String? malipo_muda;
  final String? msg;
  final Function(LoanModel?)? onUpdateMkopoData;

  @override
  State<MkopoBimaStatus> createState() => _MkopoBimaStatusState();
}

class _MkopoBimaStatusState extends State<MkopoBimaStatus> {
  LoanModel? mkopoData;

  BimaChomboApis _bimaChomboApis = BimaChomboApis();

  bool isLoading = false;
  bool isLoading2 = false;

  bool isLoading3 = false;

  double totalPaidAmount = 0; // Declare at the top of your class
  int selectedMonthIndex = -1;
  List<String> monthOptions = ["1", "3", "6", "12"];
  List<String> amountOptions = ["1,000", "3,000", "5,000", "10,000"];
  List<String> timeOptions = ["siku", "wiki", "mwezi", "yote"];

  String kiasi = "0";
  String miezi = "0";

  bool isUploading = false;

  List installmentList = [];

  var loadermsg = '';

  Future<void> initialData() async {
    setState(() {
      isUploading = true;
    });

    if (mkopoData != null) {
      mkopoData = await _bimaChomboApis.getUserLoans();

      setState(() {
        widget.mkopoData = mkopoData;
      });
    }

    List installments =
        await _bimaChomboApis.getInstallments(widget.mkopoData!.id);

    setState(() {
      installmentList.clear();
      installmentList.addAll(installments);
    });

// Calculate total paid amount where status is "paid"
    totalPaidAmount = installmentList
        .where((installment) => installment['status'] == 'paid')
        .fold(
            0.0, (sum, installment) => sum + (installment['paid_amount'] ?? 0));

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

    setState(() {
      userId = user_id!;
      userName = name!;
      userPhone = phone!;
      userImage = image!;
      userJacket = uniform!;
      isAdmin = isLeader! == 'true' ? true : false;
      phoneController.text = phoneFormat(userPhone);
    });
    // print("user name $userName");
  }

  TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    authService = AuthService();
    mkopoData = widget.mkopoData;
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
        title: Text(
          'Maendeleo ya Mkopo',
          textScaler: TextScaler.noScaling,
          style: boldTextStyle(color: Colors.black, size: 20),
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
      ),
      body: Container(
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
        child: RefreshIndicator(
          onRefresh: () async {
            // Refetch user data and installments
            await getUserData();
            await initialData();
          },
          color: WAPrimaryColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                30.height,

                // _buildNoInsuranceMessage(context),
                mkopoInformation(context)
              ],
            ),
          ),
        ),
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
                      "Tsh ${formatAmount((widget.mkopoData?.remainBalance.toInt())) ?? ''}",
                      textScaler: TextScaler.noScaling,
                      style: boldTextStyle(
                          size: 32,
                          color: WAPrimaryColor,
                          weight: FontWeight.w900),
                    ),
                    // 10.height,
                    Text(
                      "Kiasi Kilichobakia",
                      textScaler: TextScaler.noScaling,
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
                        style: primaryTextStyle(size: 12)),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.only(left: 8),
                    // alignment: Alignment.topLeft,
                    alignment: Alignment.center,

                    child: Text(
                        // currentDate(),
                        // widget.mkopoData?.request?.response?.covernote_start_date ??
                        widget.mkopoData?.request?.start_date ?? '',
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(size: 12, color: Colors.black)),
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
                        style: primaryTextStyle(size: 12)),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.only(left: 8),
                    // alignment: Alignment.topLeft,
                    alignment: Alignment.center,

                    child: Text(
                        // currentDate(),
                        // widget.mkopoData?.request?.response?.covernote_end_date ?? '',
                        // widget.mkopoData?.request?.end_date ?? '',
                        calculateEndDate(
                                widget.mkopoData?.request?.start_date) ??
                            '',
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(size: 12, color: Colors.black)),
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
                        style: primaryTextStyle(size: 12)),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.only(left: 8),
                    // alignment: Alignment.topLeft,
                    alignment: Alignment.center,

                    child: Text(
                        // '73,700',
                        "${formatAmount(widget.mkopoData?.remainBalance.toInt()) ?? ''}",
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(size: 12, color: Colors.black)),
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
                        style: primaryTextStyle(size: 12)),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.only(left: 8),
                    // alignment: Alignment.topLeft,
                    alignment: Alignment.center,

                    child: Text(
                        // '13,700',
                        formatAmount(widget.mkopoData?.paidAmount.toInt()) ??
                            '',
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(size: 12, color: Colors.black)),
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
                        style: primaryTextStyle(size: 12)),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.only(left: 8),
                    // alignment: Alignment.topLeft,
                    alignment: Alignment.center,

                    child: Text('0',
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(size: 12, color: Colors.black)),
                  ),
                ],
              ),
              Divider(
                color: Colors.black12,
                thickness: 0.5,
              ),
              30.height,
              Text(
                "Maendeleo ya Mkopo",
                textScaler: TextScaler.noScaling,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              4.height,
              CircularPercentIndicator(
                radius: 100.0,
                lineWidth: 20.0,
                animation: true,
                // percent: 0.7,
                percent: percentage(widget.mkopoData?.paidAmount ?? 0.0,
                    widget.mkopoData?.totalAmount ?? 0.0),
                center: Text(
                  // "70.0%",
                  " ${(percentage(widget.mkopoData?.paidAmount ?? 0.0, widget.mkopoData?.totalAmount ?? 0.0) * 100).toString()}%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),

                circularStrokeCap: CircularStrokeCap.round,
                // progressColor: Colors.green,
                progressColor: Colors.purple,
              ),
              30.height,
              isUploading
                  ? CircularProgressIndicator(
                      color: WAPrimaryColor,
                    )
                  : Center(
                      child: Text(
                        "Unapaswa kulipa kiasi cha ${widget.malipo_kiasi} ${widget.msg} ndani ya ${widget.malipo_muda}",
                        overflow: TextOverflow.clip,
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(size: 14, color: WAPrimaryColor),
                      ),
                    ),
              10.height,
              mitandaoWidget(),
              10.height,
              AppTextField(
                controller: phoneController,
                textFieldType: TextFieldType.NUMBER,
                decoration: waInputDecoration(
                    hint: "namba ya simu",
                    bgColor: Colors.white.withOpacity(0.6)),
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
                onPressed: () {
                  setState(() {
                    isLoading2 = true;
                  });

                  Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      isLoading2 = false;
                    });
                  });

                  showDialog(
                      context: context,
                      // useRootNavigator: false,
                      // barrierColor: WAPrimaryColor,
                      builder: (BuildContext context) {
                        // return confirmationDialog();
                        return installmentListDialog();

                        // return ReceiptDialog();
                      });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: WAPrimaryColor,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: isLoading2
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

  Widget confirmationDialog(String? installmentNumber, String? installmentId,
      String kiasi_rejesho, String remainingAmount) {
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
                  10.height,
                  Center(
                    child: Text(
                      "Uthibitsho",
                      textScaler: TextScaler.noScaling,
                      style: boldTextStyle(size: 18, color: WAPrimaryColor),
                    ),
                  ),
                  20.height,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: Text(
                        "Unakaribia kulipa kiasi cha TZS ${kiasi_rejesho}  kupitia namba ${phoneController.text} kama rejesho lako la ${installmentNumber} la mkopo wa bima",
                        overflow: TextOverflow.clip,
                        textScaler: TextScaler.noScaling,
                        style: primaryTextStyle(size: 14),
                      ),
                    ),
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Funga",
                          textScaler: TextScaler.noScaling,
                          style: boldTextStyle(size: 16, color: WAPrimaryColor),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: white,
                          // minimumSize: Size(MediaQuery.of(context).size.width, 45),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: WAPrimaryColor),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: isLoading3
                            ? null
                            : () async {
                                setState(() {
                                  isLoading3 = true;
                                  loadermsg = "Tafadhali Kamilisha malipo";
                                });

                                var response =
                                    await _bimaChomboApis.installmentPayment(
                                  phoneController.text,
                                  installmentId,
                                );

                                if (response['status'] == 'success' &&
                                    response['message'] == "paid") {
                                  toasty(
                                    context,
                                    "Malipo ya Rejesho lako la mkopo wa bima yamekamilika",
                                    textColor: Colors.white,
                                    bgColor: Colors.green,
                                    duration: Duration(seconds: 3),
                                  );

                                  await delayedNavigatorPop(context, 3000);
                                  await delayedNavigatorPop(context, 50);
                                  await initialData();

                                  setState(() {
                                    isLoading3 = false;
                                  });
                                } else if (response['status'] == 'fail') {
                                  toasty(
                                    context,
                                    "Malipo ya Rejesho lako la mkopo wa bima yameshindikana",
                                    textColor: Colors.white,
                                    bgColor: Colors.red,
                                    duration: Duration(seconds: 5),
                                  );
                                  setState(() {
                                    isLoading3 = false;
                                  });
                                  await delayedNavigatorPop(context, 2000);
                                } else {
                                  toasty(
                                    context,
                                    response['message'],
                                    textColor: Colors.white,
                                    bgColor: Colors.red,
                                    duration: Duration(seconds: 5),
                                  );
                                  setState(() {
                                    isLoading3 = false;
                                  });
                                  await delayedNavigatorPop(context, 2000);
                                }
                              },
                        child: isLoading3
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Thibitisha",
                                textScaler: TextScaler.noScaling,
                                style: boldTextStyle(
                                    size: 16, color: Colors.white),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: WAPrimaryColor,
                          // minimumSize: Size(MediaQuery.of(context).size.width, 45),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                  10.height,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget loaderDialog() {
    return StatefulBuilder(
      builder: (Builder, setState) {
        // setState(() {
        //   loadermsg = loadermsg;
        // });
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
                      'Tafadhali Subiri',
                      textScaler: TextScaler.noScaling,
                      style: boldTextStyle(color: WAPrimaryColor),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${loadermsg} ...',
                      textScaler: TextScaler.noScaling,
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

  Widget installmentListDialog() {
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
                  10.height,
                  Center(
                    child: Text(
                      "Marejesho",
                      textScaler: TextScaler.noScaling,
                      style: boldTextStyle(size: 20, color: WAPrimaryColor),
                    ),
                  ),
                  10.height,
                  installmentList.isEmpty
                      ? Center(
                          child: Text(
                            "No Installments Found",
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: installmentList.length,
                            itemBuilder: (context, index) {
                              var installment = installmentList[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: ListTile(
                                  title: Text(
                                    "Rejesho #${installment['installment_number']}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        style: primaryTextStyle(size: 12),
                                        "Kiasi: ${formatAmount(installment['amount'])}",
                                        textScaler: TextScaler.noScaling,
                                      ),
                                      Text(
                                        style: primaryTextStyle(size: 12),
                                        "Kiasi Kilicholipwa: ${formatAmount(installment['paid_amount'])}",
                                        textScaler: TextScaler.noScaling,
                                      ),
                                      Text(
                                        style: primaryTextStyle(size: 12),
                                        "Kiasi Killichobaki: ${formatAmount(installment['remain_balance'])}",
                                        textScaler: TextScaler.noScaling,
                                      ),
                                      Text(
                                        style: primaryTextStyle(size: 12),
                                        "Tarehe ya Rejesho: ${installment['due_date']}",
                                        textScaler: TextScaler.noScaling,
                                      ),
                                      Text(
                                        installment['status'] == "pending"
                                            ? "HAUJALIPA"
                                            : "UMELIPA",
                                        style: boldTextStyle(
                                            size: 12,
                                            color: installment['status'] ==
                                                    "pending"
                                                ? Colors.orange.shade400
                                                : Colors.greenAccent.shade700),
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ],
                                  ),
                                  trailing: installment['status'] == "pending"
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return confirmationDialog(
                                                      installment[
                                                              'installment_number']
                                                          .toString(),
                                                      installment['id']
                                                          .toString(),
                                                      installment['amount']
                                                          .toString(),
                                                      installment[
                                                              'remain_balance']
                                                          .toString());

                                                  // return installmentListDialog();
                                                });
                                          },
                                          child: Text(
                                            "Lipa",
                                            textScaler: TextScaler.noScaling,
                                            style: boldTextStyle(
                                                size: 10, color: Colors.white),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: WAPrimaryColor,
                                            // minimumSize: Size(MediaQuery.of(context).size.width, 45),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        )
                                      : Icon(Icons.check_circle,
                                          color: Colors.green),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> checkInstallmentStatusLoop(
      BuildContext context, int paymentId, String installmentId) async {
    for (int i = 0; i < 6; i++) {
      await Future.delayed(Duration(seconds: 5));

      var checkRes = await _bimaChomboApis.installmentPaymentChecker(
          installmentId, paymentId);

      if (checkRes['status'] == "success" && checkRes['message'] == "paid") {
        // print("Mkopo completed");
        toasty(context, "Malipo ya Mkopo yamekamilika",
            textColor: Colors.white,
            bgColor: Colors.green,
            duration: Duration(seconds: 5));
        return true; // Exit loop once the status is completed
      }

      // print("Checking status... (Attempt ${i + 1})");
      if (i > 1) {
        setState(() {
          loadermsg = "Muamala wako unafanyiwa kazi";
        });
      }
    }

    // If the loop finishes and status is not completed
    toasty(context, "Malipo ya Rejesho hayajakamilika",
        textColor: Colors.white,
        bgColor: Colors.orange,
        duration: Duration(seconds: 5));

    return false;
  }
}
