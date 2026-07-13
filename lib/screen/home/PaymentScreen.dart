import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/utils/WAColors.dart';

import 'package:intl/intl.dart' as intl;

import '../../component/ServicesComponent.dart';
import '../../main.dart';
import '../../model/WalletAppModel.dart';
import '../../utils/DataGenerator.dart';
import '../../utils/WAWidgets.dart';

class PaymentScreen extends StatefulWidget {
  static String tag = "/PaymentScreen";

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
    var phoneNumberController = TextEditingController();
    var accountNumberController = TextEditingController();
    var accountNameNumberController = TextEditingController();

    var kumbukumbuNambaController = TextEditingController();
    var amountController = TextEditingController();

    List<mitandaoModel> miandaoList = mitandaoList();



    bool _phoneError = false;
    bool _logeando = false;

    String? dropdownHuduma =  null;


    var phoneFormatter = new MaskTextInputFormatter(
        mask: '#### ### ###',
        filter: { "#": RegExp(r'[0-9]'),"X": RegExp(r'[A-Z]') },
        type: MaskAutoCompletionType.lazy
    );

    var accountFormatter = new MaskTextInputFormatter(
        mask: '#############',
        filter: { "#": RegExp(r'[0-9]'),"X": RegExp(r'[A-Z]') },
        type: MaskAutoCompletionType.lazy
    );

    var amountFormatter = new MaskTextInputFormatter(
        mask: '#############',
        filter: { "#": RegExp(r'[0-9]'),"X": RegExp(r'[A-Z]') },
        type: MaskAutoCompletionType.lazy
    );


  @override
  void initState() {
    super.initState();
    kumbukumbuNambaController.text = '99133028625';
    amountController.text = '36,000';
  }

  static const _amount = 50000;

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appStore.appBarColor,
            iconTheme: IconThemeData(color: context.iconColor),
            title: Text('Uchaguzi wa Malipo', style: boldTextStyle(color: appStore.textPrimaryColor, size: 20)),
            bottom: TabBar(
              onTap: (index) {
                print(index);
              },
              labelStyle: primaryTextStyle(),
              indicatorColor: WAPrimaryColor,
              physics: BouncingScrollPhysics(),
              labelColor: appStore.textPrimaryColor,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.phone,
                        color: WAPrimaryColor,
                      ),
                      5.width,
                      Text(
                        'Simu',
                      ),
                    ],
                  ),
                ),
                // Tab(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Icon(
                //         Icons.warehouse_outlined,
                //         color: WAPrimaryColor,
                //       ),
                //       5.width,
                //       Text(
                //         'CRDB',
                //       ),
                //     ],
                //   ),
                // ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.badge_outlined,
                        color: WAPrimaryColor,
                      ),
                      5.width,
                      Text(
                        'N-Card',
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                padding: EdgeInsets.all(14),
                // alignment: Alignment.center,
                width: context.width(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      15.height,
                      _content(),
                      15.height,
                      _mitandao(),
                      15.height,
                      btnNLoader(_logeando, context),
                      15.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text("Sina akaunti ya benki. ", style: boldTextStyle(size: 16,color: Colors.black)),
                          Text("Omba Mkopo.", style: boldTextStyle(size: 16,color: WAPrimaryColor)),
                        ],
                      ),


                      15.height,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
                      )
                    ],
                  ),),
              ),
              // Container(
              //   padding: EdgeInsets.all(16),
              //   // alignment: Alignment.center,
              //   width: context.width(),
              //   child: SingleChildScrollView(
              //     child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       _content(),
              //       15.height,
              //
              //       Text("Namba ya Simu", style: boldTextStyle(size: 16,color: Colors.black)),
              //       8.height,
              //       AppTextField(
              //         decoration: waInputDecoration(hint: '07## ### ####', prefixIcon: Icons.numbers),
              //         textFieldType: TextFieldType.NUMBER,
              //         keyboardType: TextInputType.phone,
              //         textStyle: primaryTextStyle(color: _phoneError ? Colors.red : WAPrimaryColor),
              //         controller: phoneNumberController,
              //         // focus: emailFocusNode,
              //         // nextFocus: passWordFocusNode,
              //         inputFormatters: [phoneFormatter],
              //         onChanged: (text) {
              //         },
              //         onTap: () {
              //         },
              //       ),
              //
              //       15.height,
              //       btnNLoader(_logeando, context),
              //
              //       15.height,
              //       Column(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [],
              //       )
              //     ],
              //   ),
              //   ),
              // ),
              Container(
                padding: EdgeInsets.all(16),
                // alignment: Alignment.center,
                width: context.width(),
                child: SingleChildScrollView(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _content(),
                    15.height,

                    Text("Namba ya Simu", style: boldTextStyle(size: 16,color: Colors.black)),
                    8.height,
                    AppTextField(
                      decoration: waInputDecoration(hint: '07## ### ####', prefixIcon: Icons.numbers),
                      textFieldType: TextFieldType.NUMBER,
                      keyboardType: TextInputType.phone,
                      textStyle: primaryTextStyle(color: _phoneError ? Colors.red : WAPrimaryColor),
                      controller: phoneNumberController,
                      // focus: emailFocusNode,
                      // nextFocus: passWordFocusNode,
                      inputFormatters: [phoneFormatter],
                      onChanged: (text) {
                      },
                      onTap: () {
                      },
                    ),

                    15.height,
                    btnNLoader(_logeando, context),

                    15.height,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    )
                  ],
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pricing() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Card(
            // color: Colors.lightGreenAccent.withOpacity(0.1),
            surfaceTintColor: Colors.green,
            shadowColor: Colors.green,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              onTap: () {},
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                      child: Text('Kiasi Halisi', maxLines: 2, overflow: TextOverflow.ellipsis, style: primaryTextStyle(color: appStore.textPrimaryColor,),),
                    ),
                    Divider(height: 1,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('TZS ${intl.NumberFormat.decimalPattern().format(_amount)}', style: boldTextStyle(color: appStore.textSecondaryColor),),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Card(
            // color: Colors.lightGreenAccent.withOpacity(0.1),
            surfaceTintColor: Colors.green,
            shadowColor: Colors.green,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              onTap: () {},
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                      child: Text('VAT', maxLines: 2, overflow: TextOverflow.ellipsis, style: primaryTextStyle(color: appStore.textPrimaryColor,),),
                    ),
                    Divider(height: 1,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('TZS ${intl.NumberFormat.decimalPattern().format(_amount * 0.18)}', style: boldTextStyle(color: appStore.textSecondaryColor),),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _content(){
    return Column(
        children: [
          10.height,
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(left: 8),
            alignment: Alignment.topLeft,
            child: Text('Huduma', style: boldTextStyle(size: 15, color: Colors.black)),
          ),
          Row(
            children: [
              DropdownButtonFormField(
                isExpanded: true,
                value: huduma[1],
                decoration: waInputDecoration(hint: "Chagua"),
                items: huduma.map((String? value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value!, style: secondaryTextStyle()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    dropdownHuduma = value;
                    // _allSelectInputs['bima_chombo'] = value!;
                  });
                },
              ).expand(),
            ],
          ),
          15.height,
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(left: 8),
            alignment: Alignment.topLeft,
            child: Text('Kumbukumbu namba', style: boldTextStyle(size: 15, color: Colors.black)),
          ),
          AppTextField(
            decoration: waInputDecoration(hint: '99133028625', prefixIcon: Icons.numbers),
            textFieldType: TextFieldType.NUMBER,
            keyboardType: TextInputType.number,
            // initialValue: '10000',
            textStyle: primaryTextStyle(color: _phoneError ? Colors.red : WAPrimaryColor),
            controller: kumbukumbuNambaController,
            // focus: emailFocusNode,
            // nextFocus: passWordFocusNode,
            inputFormatters: [accountFormatter],
            onChanged: (text) {
            },
            onTap: () {
            },
          ),
          15.height,
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(left: 8),
            alignment: Alignment.topLeft,
            child: Text('Kiasi', style: boldTextStyle(size: 15, color: Colors.black)),
          ),
          AppTextField(
            decoration: waInputDecoration(hint: '36,000', prefixIcon: Icons.numbers),
            textFieldType: TextFieldType.NUMBER,
            keyboardType: TextInputType.number,
            // initialValue: '36000',
            textStyle: primaryTextStyle(color: _phoneError ? Colors.red : WAPrimaryColor),
            controller: amountController,
            // focus: emailFocusNode,
            // nextFocus: passWordFocusNode,
            inputFormatters: [amountFormatter],
            onChanged: (text) {
            },
            onTap: () {
            },
          ),
          15.height,
        ],
    );
  }

  Widget _line(String text){
    return Row(
      children: [
        Icon(Symbols.point_scan_rounded, size: 14,),
        SizedBox(width: 4,),
        Text(text, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xFF505F79)),)
      ],
    );
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

    return AppButton(
        text: "Fanya Malipo",
        color: WAPrimaryColor,
        textColor: Colors.white,
        shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        width: context.width(),

        enabled: false,
        disabledColor: Colors.grey,
        onTap: () async {

        }).paddingOnly(left: context.width() * 0.1, right: context.width() * 0.1);
  }

  Widget _mitandao(){
    return SingleChildScrollView(
      child: Wrap(
        spacing: 3,
        runSpacing: 3,
        alignment: WrapAlignment.center,
        children: miandaoList.map((item) {
          return Container(
            padding: EdgeInsets.only(top: 16, bottom: 8, left: 8, right: 8),
            decoration: boxDecorationRoundedWithShadow(16, backgroundColor: appStore.isDarkModeOn ? cardDarkColor : white),
            alignment: AlignmentDirectional.center,
            width: context.width() * 0.2,
            child: ServicesComponent(
              itemModel: item,
            ),
          ).onTap(() {
            if (item.title == 'Vazi') {
              item.widget.launch(context);
            }
          });
        }).toList(),
      ).paddingAll(16),
    );
  }

}
