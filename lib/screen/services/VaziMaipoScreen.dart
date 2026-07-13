import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/screen/home/PaymentScreen.dart';
import 'package:shirikisho/utils/WAColors.dart';

import 'package:intl/intl.dart' as intl;

import '../../main.dart';
import '../../utils/WAWidgets.dart';

class VaziMalipoScreen extends StatefulWidget {
  static String tag = "/VaziMalipoScreen";

  @override
  _VaziMalipoScreenState createState() => _VaziMalipoScreenState();
}

class _VaziMalipoScreenState extends State<VaziMalipoScreen> {
    var phoneNumberController = TextEditingController();
    var accountNumberController = TextEditingController();
    var accountNameNumberController = TextEditingController();

    bool _phoneError = false;
    bool _logeando = false;



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


  @override
  void initState() {
    super.initState();
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
                        Icons.warehouse_outlined,
                        color: WAPrimaryColor,
                      ),
                      5.width,
                      Text(
                        'Malipo ya Benki',
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        color: WAPrimaryColor,
                      ),
                      5.width,
                      Text(
                        'Malipo Taslimu',
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
                padding: EdgeInsets.all(16),
                // alignment: Alignment.center,
                width: context.width(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _content(),
                      15.height,
                      Text("Namba ya Akaunti (CRDB)", style: boldTextStyle(size: 16,color: Colors.black)),
                      8.height,
                      AppTextField(
                        decoration: waInputDecoration(hint: '#############', prefixIcon: Icons.numbers),
                        textFieldType: TextFieldType.NAME,
                        keyboardType: TextInputType.name,
                        textStyle: primaryTextStyle(color: _phoneError ? Colors.red : WAPrimaryColor),
                        controller: accountNameNumberController,
                        // focus: emailFocusNode,
                        // nextFocus: passWordFocusNode,
                        inputFormatters: [accountFormatter],
                        onChanged: (text) {
                        },
                        onTap: () {
                        },
                      ),

                      15.height,
                      Text("Jina la Akaunti (CRDB)", style: boldTextStyle(size: 16,color: Colors.black)),
                      8.height,
                      AppTextField(
                        decoration: waInputDecoration(hint: 'Jina Kamili la Akaunti', prefixIcon: Icons.badge_outlined),
                        textFieldType: TextFieldType.NAME,
                        keyboardType: TextInputType.name,
                        textStyle: primaryTextStyle(color: _phoneError ? Colors.red : WAPrimaryColor),
                        // controller: accountNameNumberController,
                        // focus: emailFocusNode,
                        // nextFocus: passWordFocusNode,
                        // inputFormatters: [accountFormatter],
                        onChanged: (text) {
                        },
                        onTap: () {
                        },
                      ),

                      15.height,
                      btnNLoader(_logeando, context),
                      15.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Sina akaunti ya benki. ", style: boldTextStyle(size: 16,color: Colors.black)),
                          Text("Omba Akaunti.", style: boldTextStyle(size: 16,color: WAPrimaryColor)),
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
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Vitu vinavyolopiwa', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Color(0xFF505F79)),),
                  ],
                ),
                const SizedBox(height: 10,),

                _line('Koti la dereva'),
                const SizedBox(height: 3,),

                _line('Kofia ngumu ya dereva'),
                const SizedBox(height: 3,),

                _line('Kofia ngumu ya abiria'),
                const SizedBox(height: 3,),

                _line('Kiakisi mwanga cha abiria'),
                const SizedBox(height: 3,),

                const SizedBox(height: 13,),

              ]),
            ),
          ),
          pricing(),
          15.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Kiasi unacholipia:', style: TextStyle(color: appStore.textPrimaryColor, fontSize: 18),),
              Text(intl.NumberFormat.decimalPattern().format(_amount + (_amount * 0.18)), style: TextStyle(color: appStore.textPrimaryColor, fontSize: 18),),
            ],
          ),
        ],
    );
  }

  Widget _line(String text){
    return Row(
      children: [
        Icon(Symbols.point_scan_rounded, size: 14,),
        SizedBox(width: 4,),
        Text(text, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Color(0xFF505F79)),)
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
        text: "Lipa Sasa",
        color: WAPrimaryColor,
        textColor: Colors.white,
        shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        width: context.width(),
        onTap: () async {
          // VaziPaymentScreen().launch(context);
        }).paddingOnly(left: context.width() * 0.1, right: context.width() * 0.1);
  }

}
