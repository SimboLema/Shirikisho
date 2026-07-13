import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/styles.dart';

class UniformsPopup {
  void openLoadingPayments(
      {required context,
      required String heading,
      required List<Widget> internals,
      required String descrpt}) {
    Get.dialog(
        Dialog(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  heading,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 17),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      descrpt,
                      style: const TextStyle(
                          fontSize: 15, color: Color(0xFF505F79)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                    height: 100,
                    child: widgetIter(
                        iter: internals, sepVal: 5.0, context: context))
              ],
            ),
          ),
        ),
        barrierDismissible: false);
  }

  void openDonePaymentsAdas({
    required context,
    required String heading,
    required List<Widget> internals,
    required String descrpt,
    required Function closePop,
  }) {
    final KishoStyles appStyles = KishoStyles();
    Get.dialog(
        Dialog(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  heading,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 17),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      descrpt,
                      style: const TextStyle(
                          fontSize: 15, color: Color(0xFF505F79)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                    height: 95,
                    child: widgetIter(
                        iter: internals, sepVal: 5.0, context: context)),
                ElevatedButton(
                    onPressed: () {
                      closePop();
                    },
                    style: appStyles.defaultButtonStyles().copyWith(
                        minimumSize: const MaterialStatePropertyAll(
                            Size(double.maxFinite, 40))),
                    child: const Text("Endelea"))
              ],
            ),
          ),
        ),
        barrierDismissible: true);
  }

  Widget widgetIter(
      {required List<Widget> iter, required double sepVal, required context}) {
    if (iter.isEmpty) {
      return const SizedBox();
    }

    return ListView.separated(
        padding: const EdgeInsets.only(left: 7),
        itemBuilder: (context, inde) {
          return iter[inde];
        },
        separatorBuilder: (context, _) {
          return SizedBox(
            height: sepVal,
          );
        },
        itemCount: iter.length);
  }

  Widget loadRowPaymentsLoading({required rowName}) {
    return Row(
      children: [
        const CircularProgressIndicator.adaptive(
          strokeWidth: 6.0,
          backgroundColor: Color(0xFF24B42E),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(rowName)
      ],
    );
  }

  Widget successPaymentRow({required rowName}) {
    return Row(
      children: [
        const Icon(
          Icons.done_all_rounded,
          color: Color(0xFF24B42E),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(rowName)
      ],
    );
  }
}
