


import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/model/bima/chombo_verify_model.dart';
import 'package:shirikisho/screen/bimachombo/components/SummaryWidgets.dart';


// Widget chomboSummaryDialog( BuildContext context,MotorVerificationRes data) {

Widget chomboSummaryDialog(BuildContext context, var data) {

  return StatefulBuilder(builder: (Builder, setState) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: context.scaffoldBackgroundColor,
          image: DecorationImage(
            image: AssetImage('assets/images/logo2.png'),
            fit: BoxFit.contain,
            opacity: 0.04,
          ),
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
                  "Taarifa za Usajili wa Chombo",
                  textScaler: TextScaler.noScaling,
                  style: boldTextStyle(
                    size: 16,
                    color: Colors.black,
                  ),
                ),
                20.height,
                InfoRow(
                  label: "Jina la Mmiliki",
                  // value: data.verificationDtl.ownerName,
                  value: data['OwnerName'].toString(),
                  
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 14, color: Colors.black),
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 0.5,
                ),
                 InfoRow(
                  label: "Namba ya Usajili",
                  // value: data.verificationDtl.registrationNumber,
                  value: data['RegistrationNumber'].toString(),
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 14, color: Colors.black),
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 0.5,
                ),
                InfoRow(
                  label: "Aina ya Umiliki",
                  // value: data.verificationDtl.ownerCategory,
                  value:data['OwnerCategory'].toString(),
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 14, color: Colors.black),
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 0.5,
                ),
                InfoRow(
                  label: "Aina ya Chombo",
                  // value: data.verificationDtl.model ,
                  value: data['Model'].toString(),
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 14, color: Colors.black),
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 0.5,
                ),
                InfoRow(
                  label: "Rangi",
                  // value: data.verificationDtl.color,
                  value: data['Color'].toString(),
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 14, color: Colors.black),
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 0.5,
                ),
                InfoRow(
                  label: "Namba ya Engine",
                  // value: data.verificationDtl.engineNumber,
                  value:data['EngineNumber'].toString(),
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 14, color: Colors.black),
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 0.5,
                ),
                InfoRow(
                  label: "Uwezo wa Engine",
                  // value: data.verificationDtl.engineCapacity,
                  value:data['EngineCapacity'].toString(),
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 14, color: Colors.black),
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 0.5,
                ),
                InfoRow(
                  label: "Mafuta yanayotumika",
                  // value: data.verificationDtl.fuelUsed,
                  value: data['FuelUsed'].toString(),
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 14, color: Colors.black),
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 0.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });
}
