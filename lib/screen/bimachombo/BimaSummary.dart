import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/helpers/constantFunctions.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:shirikisho/utils/widgets/dashdivider.dart';

class BimaSummaryScreen extends StatefulWidget {
  const BimaSummaryScreen({super.key});

  @override
  State<BimaSummaryScreen> createState() => _BimaSummaryScreenState();
}

class _BimaSummaryScreenState extends State<BimaSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bima Summary'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                20.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,
                      child: Text('Jina Kamili', style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('George Prosper Mushi',
                          style: boldTextStyle(size: 15, color: Colors.black)),
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
                      child: Text('Namba ya Simu', style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('0719401504',
                          style: boldTextStyle(size: 15, color: Colors.black)),
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
                      child: Text('Aina ya Chombo', style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('Bajaji',
                          style: boldTextStyle(size: 15, color: Colors.black)),
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
                      child:
                          Text('Aina ya Kifurushi', style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('Comprehensive',
                          style: boldTextStyle(size: 15, color: Colors.black)),
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
                      child:
                          Text('Tarehe ya Maombi', style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text(currentDate(),
                          style: boldTextStyle(size: 15, color: Colors.black)),
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
                      child: Text('Njia ya Malipo', style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('Cash',
                          style: boldTextStyle(size: 15, color: Colors.black)),
                    ),
                  ],
                ),
                DashedDivider(
                  height: 2,
                  dashWidth: 5,
                  color: Colors.black,
                ),
                200.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,
                      child: Text('Muda wa Malipo ', style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('Miezi 3',
                          style: boldTextStyle(size: 15, color: Colors.black)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,
                      child:
                          Text('Malipo kwa mwezi', style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('10,000',
                          style: boldTextStyle(size: 15, color: Colors.black)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,
                      child: Text('Malipo kwa siku', style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('300',
                          style: boldTextStyle(size: 15, color: Colors.black)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,
                      child: Text('Jumla Kuu', style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('30000',
                          textScaler: TextScaler.noScaling,
                          style: boldTextStyle(size: 16, color: Colors.black)),
                    ),
                  ],
                ),
                20.height,
                ElevatedButton(
                  onPressed: () {
                    // summaryDialog().launch(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => summaryDialog());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WAPrimaryColor,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Lipia',
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget summaryDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.0,
      // backgroundColor: Colors.transparent,

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  "Bima Summary",
                  textScaler: TextScaler.noScaling,
                  style: boldTextStyle(
                    size: 16,
                    color: Colors.black,
                  ),
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
                      child: Text('Jina Kamili',
                          textScaler: TextScaler.noScaling,
                          style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('George Prosper Mushi',
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
                      child: Text('Namba ya Simu',
                          textScaler: TextScaler.noScaling,
                          style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('0719401504',
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
                      child: Text('Aina ya Chombo',
                          textScaler: TextScaler.noScaling,
                          style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('Bajaji',
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
                      child:
                          Text('Aina ya Kifurushi', style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('Comprehensive',
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
                      child: Text('Tarehe ya Maombi',
                          textScaler: TextScaler.noScaling,
                          style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text(currentDate(),
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
                      child: Text('Njia ya Malipo',
                          textScaler: TextScaler.noScaling,
                          style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('Cash',
                          textScaler: TextScaler.noScaling,
                          style: boldTextStyle(size: 16, color: Colors.black)),
                    ),
                  ],
                ),
                DashedDivider(
                  height: 2,
                  dashWidth: 5,
                  color: Colors.black,
                ),
                100.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,
                      child: Text('Muda wa Malipo ',
                          textScaler: TextScaler.noScaling,
                          style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('Miezi 3',
                          textScaler: TextScaler.noScaling,
                          style: boldTextStyle(size: 16, color: Colors.black)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,
                      child: Text('Malipo kwa mwezi',
                          textScaler: TextScaler.noScaling,
                          style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('10,000',
                          textScaler: TextScaler.noScaling,
                          style: boldTextStyle(size: 16, color: Colors.black)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,
                      child: Text('Malipo kwa siku',
                          textScaler: TextScaler.noScaling,
                          style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('300',
                          textScaler: TextScaler.noScaling,
                          style: boldTextStyle(size: 16, color: Colors.black)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,
                      child: Text('Jumla Kuu',
                          textScaler: TextScaler.noScaling,
                          style: primaryTextStyle()),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      // alignment: Alignment.topLeft,
                      alignment: Alignment.center,

                      child: Text('30000',
                          textScaler: TextScaler.noScaling,
                          style: boldTextStyle(size: 16, color: Colors.black)),
                    ),
                  ],
                ),
                20.height,
                ElevatedButton(
                  onPressed: () {
                    BimaSummaryScreen().launch(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WAPrimaryColor,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Lipia',
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
