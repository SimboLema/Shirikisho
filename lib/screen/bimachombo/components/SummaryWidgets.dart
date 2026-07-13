import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/model/region/chombo_model.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:shirikisho/utils/WAWidgets.dart';
import 'package:shirikisho/utils/widgets/dashdivider.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
    this.labelStyle = const TextStyle(),
    this.valueStyle = const TextStyle(),
    this.margin = const EdgeInsets.only(bottom: 2),
    this.padding = const EdgeInsets.only(left: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          label,
          style: primaryTextStyle(size: 12),
          overflow: TextOverflow.ellipsis,
          textScaler: TextScaler.noScaling,
        ),
        Flexible(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          
            style: boldTextStyle(size: 13, color: Colors.black),
            textScaler: TextScaler.noScaling,
          ),
        ),
      ],
    );
  }
}

class CustomDropdownField<T> extends StatelessWidget {
  final String labelText;
  final TextStyle labelStyle;
  final TextStyle itemStyle;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final InputDecoration decoration;
  final T? selectedValue;
  final List<T> items;
  final String Function(T) itemLabel;
  final bool Function(T) isDisabled;
  final ValueChanged<T?>? onChanged;

  const CustomDropdownField({
    Key? key,
    required this.labelText,
    required this.items,
    required this.itemLabel,
    this.selectedValue,
    this.labelStyle = const TextStyle(fontSize: 14, color: Colors.black),
    this.itemStyle = const TextStyle(fontSize: 16),
    this.margin = const EdgeInsets.only(bottom: 10),
    this.padding = const EdgeInsets.only(left: 8),
    this.decoration = const InputDecoration(),
    this.isDisabled = _defaultIsDisabled,
    this.onChanged,
  }) : super(key: key);

  static bool _defaultIsDisabled(dynamic item) => false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: margin,
          padding: padding,
          alignment: Alignment.topLeft,
          child: Text(
            labelText,
            style: labelStyle,
            textScaler: TextScaler.noScaling,
          ),
        ),
        DropdownButtonFormField<T>(
          isExpanded: true,
          value: selectedValue,
          decoration: decoration,
          items: items.map((T value) {
            final bool disabled = isDisabled(value);
            return DropdownMenuItem<T>(
              value: disabled ? null : value,
              enabled: !disabled,
              child: Text(
                itemLabel(value),
                style: itemStyle.copyWith(
                  color: disabled ? Colors.grey : itemStyle.color,
                ),
                textScaler: TextScaler.noScaling,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

Widget mitandaoWidget() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: List.generate(3, (index) {
      var staticImage = '';
      if (index == 0) {
        staticImage = "assets/logo/airtelmoney.png";
      } else if (index == 1) {
        staticImage = "assets/logo/Mixx_Logo.png";
      } else {
        staticImage = "assets/logo/mpesa.png";
      }

      return GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            Image.asset(
              staticImage,
              height: index == 1 ? 80 : 60,
              width: index == 1 ? 100 : 60,
            ),
          ],
        ),
      );
    }),
  );
}

Widget financerWidget() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: List.generate(3, (index) {
      var staticImage = '';
      if (index == 0) {
        staticImage = "assets/logo/kmj.png";
      } else if (index == 1) {
        staticImage = "assets/logo/papihumtech.png";
      } else {
        staticImage = "assets/images/logo2.png";
      }

      return GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            Image.asset(
              staticImage,
              height: index == 1 ? 80 : 60,
              width: index == 1 ? 100 : 60,
            ),
          ],
        ),
      );
    }),
  );
}

Widget loadingDialog(BuildContext context, String message) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 1.0,
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: defaultBoxShadow(),
      ),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color:WAPrimaryColor,
              strokeWidth: 1.5,
            ),
            // SizedBox(height: 10),
            10.height,
            Text(
              message,
              style: primaryTextStyle(size: 14),
            ),
          ],
        )
      ),
    ),
  );
}

Widget summaryDialog(
    BuildContext context,
    String userName,
    String userPhone,
    TextEditingController _chomboNambaTextController,
    vTypeModule? selectedVehicle,
    BimaPkgModel? selectedKifurushi,
    PaymentMethodModel? selectedPaymentMethod,
    String Function() currentDate,
    String Function(num amount) formatAmount,
    num Function(num percent, num total) downPayment,
    num Function(num percent, num total) remainAmount,
    num Function(num percent, num total, int duration) mweziPayment,
    num Function(num monthly) dailyPayment,
    TextEditingController phoneNumberController,
    List<String> mitandaoList,
    Color WAPrimaryColor,
    bool isLoading,
    int selectedValue,
    Function(int index) onPaymentOptionSelected) {
  return StatefulBuilder(builder: (context, setState) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          boxShadow: defaultBoxShadow(),
        ),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  "Bima Summary",
                  style: boldTextStyle(size: 16, color: Colors.black),
                ),
                SizedBox(height: 20),
                InfoRow(
                  label: 'Jina Kamili',
                  value: userName,
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 15, color: Colors.black),
                ),
                Divider(color: Colors.black12, thickness: 0.5),
                InfoRow(
                  label: 'Namba ya Simu',
                  value: userPhone,
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 15, color: Colors.black),
                ),
                Divider(color: Colors.black12, thickness: 0.5),
                InfoRow(
                  label: 'Namba ya Chombo',
                  value: _chomboNambaTextController.text,
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 15, color: Colors.black),
                ),
                Divider(color: Colors.black12, thickness: 0.5),
                InfoRow(
                  label: 'Aina ya Chombo',
                  value: selectedVehicle?.name ?? "Hujachagua chombo",
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 15, color: Colors.black),
                ),
                Divider(color: Colors.black12, thickness: 0.5),
                InfoRow(
                  label: 'Aina ya Kifurushi',
                  value:
                      selectedKifurushi?.package_name ?? "hujachagua kifurushi",
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 15, color: Colors.black),
                ),
                Divider(color: Colors.black12, thickness: 0.5),
                InfoRow(
                  label: 'Tarehe ya Maombi',
                  value: currentDate(),
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 15, color: Colors.black),
                ),
                Divider(color: Colors.black12, thickness: 0.5),
                InfoRow(
                  label: 'Njia ya Malipo',
                  value: selectedPaymentMethod?.method_name ??
                      "Hujachagua Njia ya Malipo",
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 15, color: Colors.black),
                ),
                DashedDivider(height: 2, dashWidth: 5, color: Colors.black),
                SizedBox(height: 80),
                if (selectedPaymentMethod?.method_name == "Loan") ...[
                  InfoRow(
                    label: 'Muda wa Malipo',
                    value: selectedVehicle != null
                        ? "Miezi ${selectedVehicle.installment_duration}"
                        : "--",
                    labelStyle: primaryTextStyle(),
                    valueStyle: boldTextStyle(size: 15, color: Colors.black),
                  ),
                  InfoRow(
                    label: 'Malipo ya Awali',
                    value: selectedVehicle != null
                        ? formatAmount(downPayment(
                            selectedVehicle.down_payment_percent as num,
                            selectedVehicle.total_amount as num))
                        : "0",
                    labelStyle: primaryTextStyle(),
                    valueStyle: boldTextStyle(size: 15, color: Colors.black),
                  ),
                  // Add other InfoRow instances as required
                ],
                InfoRow(
                  label: 'Jumla Kuu',
                  value: selectedVehicle != null
                      ? formatAmount(selectedVehicle.total_amount as num)
                      : "0",
                  labelStyle: primaryTextStyle(),
                  valueStyle: boldTextStyle(size: 15, color: Colors.black),
                ),
                SizedBox(height: 20),
                AppTextField(
                  controller: phoneNumberController,
                  textFieldType: TextFieldType.NUMBER,
                  decoration: waInputDecoration(hint: "namba ya simu"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Your onPressed logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WAPrimaryColor,
                    minimumSize: Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1.5,
                        )
                      : Text(
                          'Lipia',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });
}
