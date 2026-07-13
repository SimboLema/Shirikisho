import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/screen/home/ServicesScreen.dart';

import '../styles.dart';

class MikopoBannerHome extends StatelessWidget {
  const MikopoBannerHome({super.key});

  @override
  Widget build(BuildContext context) {
    KishoStyles appStyles = KishoStyles();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      child: Stack(children: [
        Card(
          margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
          color: Color.fromRGBO(36, 48, 24, 1),
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 190,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ni wakati wa kutoka kiuchumi.',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Pata huduma za mikopo kwa riba nafuu kutoka watoa huduma wetu',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            ServicesScreen().launch(context);
                          },
                          style: appStyles.defaultButtonStyles(),
                          child: const Text('Ona huduma'))
                    ],
                  ),
                ),
                Expanded(
                  child: Image(
                    image: const AssetImage(
                      'assets/images/intro2.png',
                    ),
                    // width: MediaQuery.of(context).size.width * 0.9 - 190,
                    // width: screenWidth * 0.3,
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
