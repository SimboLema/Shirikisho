import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../utils/styles.dart';

class PictureSelectorCard extends StatelessWidget {
  final String cardHead;
  final String cardExplain;
  final String cardformat;
  final Function garFun;
  final Function camFun;
  const PictureSelectorCard(
      {required this.camFun,
      required this.cardExplain,
      required this.cardHead,
      required this.cardformat,
      required this.garFun,
      super.key});

  @override
  Widget build(BuildContext context) {
    final KishoStyles appStyles = KishoStyles();
    return Card(
      elevation: 2.0,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              cardHead,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontSize: 17),
            ),
            const SizedBox(
              height: 9,
            ),
            Text(
              cardExplain,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              cardformat,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 14),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFE6EBF0)))),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        camFun();
                      },
                      style: appStyles.defaultButtonStyles().copyWith(
                          minimumSize: const MaterialStatePropertyAll(
                              Size(double.infinity, 45))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Symbols.photo_camera_rounded),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Piga Picha')
                        ],
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
