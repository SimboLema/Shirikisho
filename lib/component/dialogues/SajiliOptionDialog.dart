import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/component/dialogues/HakikiKituoDialog.dart';
import 'package:shirikisho/component/dialogues/SajiliDialog.dart';
import 'package:shirikisho/screen/usajili/HakikiKituoScreen.dart';
import 'package:shirikisho/screen/usajili/SajiliKituoScreen.dart';
import 'package:shirikisho/services/region_service.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:shirikisho/utils/styles.dart';

class SajiliOptionDialog extends StatefulWidget {
  const SajiliOptionDialog({super.key});

  @override
  State<SajiliOptionDialog> createState() => _SajiliOptionDialogState();
}

class _SajiliOptionDialogState extends State<SajiliOptionDialog> {
  KishoStyles appStyles = KishoStyles();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
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
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: [
              // 10.height,
              Text("Usajili",
                  style: boldTextStyle(size: 20, color: WAPrimaryColor),
                  textAlign: TextAlign.center),
              20.height,
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HakikiKituoScreen(),
                    ),
                  );
                },
                style: appStyles.defaultButtonStyles().copyWith(
                    minimumSize: const WidgetStatePropertyAll(
                        Size(double.infinity, 45))),
                child: const Text('Hakiki Kituo'),
              ),
              10.height,
              // ElevatedButton(
              //   onPressed: () async {
              //     setState(() {
              //       isLoading = true;
              //     });
              //     // fetch leader kituo
              //     try {
              //       var res = await loadParking();
              //       if (res['status'] &&
              //           res['parking']['status'] == 'pending') {
              //         showDialog(
              //           context: context,
              //           builder: (BuildContext context) => KituoUpdateDialog(
              //             parkingData: res['parking'],
              //           ),
              //         );
              //       } else if (res['status'] &&
              //           res['parking']['status'] != 'pending') {
              //         toasty(context, "Hongera Kituo chako kilishahakikiwa",
              //             bgColor: Colors.green,
              //             textColor: Colors.white,
              //             duration: Duration(seconds: 3));
              //       } else {
              //         toasty(context, "Samahani Hauna kituo ulichosajili");
              //       }
              //     } catch (error) {
              //       toast("Samahani, kuna tatizo la mtandao");
              //     } finally {
              //       setState(() {
              //         isLoading = false;
              //       });
              //     }
              //   },
              //   style: appStyles.defaultButtonStyles().copyWith(
              //       minimumSize: const WidgetStatePropertyAll(
              //           Size(double.infinity, 45))),
              //   child: isLoading
              //       ? CircularProgressIndicator(
              //           color: Colors.white,
              //         )
              //       : Text('Hakiki Kituo'),
              // ),
              // 10.height,
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => ApplicationDialog(),
                  );
                },
                style: appStyles.defaultButtonStyles().copyWith(
                    minimumSize: const WidgetStatePropertyAll(
                        Size(double.infinity, 45))),
                child: const Text('Sajili Dereva'),
              ),
              const SizedBox(height: 16.0),
              10.height
            ],
          ),
        ),
      ),
    );
  }
}
