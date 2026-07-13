

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shirikisho/screen/bima/components/paymentPlanOption.dart';
import 'package:shirikisho/services/auth_service.dart';
import 'package:shirikisho/utils/WAColors.dart';

import '../../model/bima/BimaPackageModal.dart';

class ChoosePlanScreen extends StatefulWidget {
  @override
  ChoosePlanScreenState createState() => ChoosePlanScreenState();
}

class ChoosePlanScreenState extends State<ChoosePlanScreen> {
  List<BimaPackageModal> periodModal = [];
  int selectIndex = 0;
  int selectedMonthIndex = -1;
  List<String> monthOptions = ["1", "3", "6", "12"];
  Color screenColor = WAPrimaryColor;
  late AuthService authService;
  var userName = "";
  var userPhone = "";
  var userJacket = "";
  var userImage = "";
  var isAdmin = false;
  var avatar = "/office/media/avatars/300-1.jpg";

  final _storage = const FlutterSecureStorage();
  bool isLoading = false;

  Future<void> getUserData() async {
    authService.getUser();

    var name = await _storage.read(key: 'full_name');
    var phone = await _storage.read(key: 'user_phone');
    var uniform = await _storage.read(key: 'user_uniform_number');
    var image = await _storage.read(key: 'user_image');
    var isLeader = await _storage.read(key: 'user_is_leader');

    setState(() {
      userName = name!;
      userPhone = phone!;
      userImage = image!;
      userJacket = uniform!;
      isAdmin = isLeader! == 'true' ? true : false;
    });
  }

  @override
  void initState() {
    super.initState();
    authService = AuthService();
    getUserData();
    init();
  }

  Future<void> init() async {
    List<BimaPackageModal> _packages = await loadPosts();

    setState(() {
      periodModal.clear();
      periodModal.addAll(_packages);
    });

    setStatusBarColor(WAPrimaryColor);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(context.scaffoldBackgroundColor);
    super.dispose();
  }

  double calculateTotalAmount() {
    if (selectedMonthIndex == -1 || selectedMonthIndex >= monthOptions.length) return 0;
    int months = int.parse(monthOptions[selectedMonthIndex].split(' ')[0]);
    return periodModal[selectIndex].price.validate().toDouble() * months;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: context.height(),
              width: context.width(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 280,
                      child: Stack(
                        children: [
                          Image.asset('assets/bima/sanlam.png'),
                        ],
                      ),
                    ),
                    16.height,
                    Text('Chagua Bima', style: boldTextStyle(size: 24, color: WAPrimaryColor)).paddingLeft(16.0),
                    16.height,
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: periodModal.length,
                      shrinkWrap: true,
                      itemBuilder: (_, int index) {
                        bool isSelected = selectIndex == index;
                        Color cardColor = context.cardColor;
                        if (periodModal[index].name?.toLowerCase() == "gold") {
                          cardColor = Colors.amber.withOpacity(0.4);
                        } else if (periodModal[index].name?.toLowerCase() == "silver") {
                          cardColor = Colors.grey.withOpacity(0.4);
                        }

                        return GestureDetector(
                          onTap: () {
                            selectIndex = index;
                            setState(() {});
                          },
                          child: Card(
                            elevation: isSelected ? 8 : 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            color: isSelected ? cardColor : context.cardColor,
                            child: Container(
                              height: 150,
                              padding: EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      color: context.cardColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 3, color: isSelected ? Colors.white : Colors.blue),
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 16,
                                      color: isSelected ? Colors.white : Colors.blue,
                                    ).visible(isSelected),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          periodModal[index].name.validate(),
                                          style: boldTextStyle(size: 16),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Tsh. ${intl.NumberFormat.decimalPattern().format(periodModal[index].price.validate())}',
                                          style: primaryTextStyle(size: 18),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Fidia: Tsh. ${intl.NumberFormat.decimalPattern().format(periodModal[index].sumInsured.validate())}',
                                          style: secondaryTextStyle(),
                                        ),
                                        SizedBox(height: 4),
                                        DescriptionText(
                                          text: 'Faida: ${periodModal[index].description.validate()}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    16.height,
                    Text('Chagua Miezi ya Kulipa', style: boldTextStyle(size: 24, color: WAPrimaryColor)).paddingLeft(16.0),
                    16.height,
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: monthOptions.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                      ),
                      itemBuilder: (_, int index) {
                        bool isSelected = selectedMonthIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMonthIndex = index;
                            });
                          },
                          child: Card(
                            elevation: isSelected ? 8 : 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: EdgeInsets.all(8),
                            color: isSelected ? WAPrimaryColor.withOpacity(0.8) : context.cardColor,
                            child: Center(
                              child: Text(
                                "${monthOptions[index]} ${monthOptions[index] == '1' ? 'Mwezi' : 'Miezi'}",
                                style: boldTextStyle(
                                  color: isSelected ? Colors.white : WAPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    16.height,
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Jumla ya Kiasi: Tsh. ${intl.NumberFormat.decimalPattern().format(calculateTotalAmount())}',
                            style: boldTextStyle(size: 20, color: WAPrimaryColor),
                          ),
                          16.height,
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: WAPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            ),
                            onPressed: () {
                              if (selectIndex != -1 && selectedMonthIndex != -1) {
                                String selectedPackage = periodModal[selectIndex].name ?? '';
                                String packageId = periodModal[selectIndex].id.toString();
                                double packagePrice = periodModal[selectIndex].price!.toDouble();
                                int selectedMonth = monthOptions[selectedMonthIndex].toInt();
                                double totalAmount = calculateTotalAmount();

                                showSummaryDialog(
                                  context,
                                  packageId,
                                  selectedPackage,
                                  selectedMonth,
                                  packagePrice,
                                  userPhone,
                                  userName,
                                  isLoading,
                                );
                              } else {
                                toast('Tafadhali chagua mpango na miezi.');
                              }
                            },
                            child: Text(
                              'Endelea',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

class DescriptionText extends StatelessWidget {
  final String text;
  DescriptionText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text.length > 50 ? text.substring(0, 50) + '...' : text, // Show a limited portion of the text
          overflow: TextOverflow.ellipsis,
          style: secondaryTextStyle(),
        ),
        SizedBox(height: 4,),
        GestureDetector(
          onTap: () => _showFullDescriptionDialog(context),
          child: Text(
            'Faida Zake ...',
            style: TextStyle(color:WAPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  // Function to show the dialog with full description
  void _showFullDescriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Faida ya Bima'),
          content: SingleChildScrollView(
            child: Text(
              text,
              style: secondaryTextStyle(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close',style: TextStyle(color: WAPrimaryColor),),
            ),
          ],
        );
      },
    );
  }
}
