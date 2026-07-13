import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/helpers/constantFunctions.dart';
import 'package:shirikisho/utils/WAColors.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, size: 80, color:WAPrimaryColor),
              SizedBox(height: 20),
              Text(
                'Ujumbe wa Hitilafu',
                style: boldTextStyle(size: 24, color:WAPrimaryColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Programu hii haiwezi kufanya kazi wakati Hali ya Mtaalamu (Developer Mode) imewashwa. Tafadhali izime katika mipangilio ya kifaa chako na ujaribu tena.',
                style: primaryTextStyle(size: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  // await openSettings();
                },
                child: Text('Fungua Mipangilio',
                    style: boldTextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: WAPrimaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
