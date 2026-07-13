import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../utils/styles.dart';

class ImageUploadScreen extends StatefulWidget {
  final Function backFun;
  final String titles;
  final String imagePath;
  final Function cropFunction;
  final Function doneFunction;
  const ImageUploadScreen(
      {required this.backFun,
      required this.cropFunction,
      required this.doneFunction,
      required this.imagePath,
      required this.titles,
      super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  KishoStyles appStyles = KishoStyles();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.green,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                widget.backFun();
              },
              icon: const Icon(Symbols.arrow_back_ios_new_rounded)),
          title: Text(
            widget.titles,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        body: Column(children: [
          Expanded(
              child: Center(
            child: Image.file(File(widget.imagePath)),
          )),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {
                      widget.cropFunction();
                    },
                    style: appStyles.roundButtonStyles().copyWith(
                        foregroundColor: WidgetStatePropertyAll(
                            Theme.of(context).primaryColor),
                        shadowColor:
                            const WidgetStatePropertyAll(Colors.transparent),
                        backgroundColor:
                            const WidgetStatePropertyAll(Color(0x4524B42E)),
                        padding:
                            const WidgetStatePropertyAll(EdgeInsets.all(5)),
                        maximumSize:
                            const WidgetStatePropertyAll(Size(50, 50))),
                    child: const Icon(
                      Icons.crop_free_rounded,
                    )),
                ElevatedButton(
                    onPressed: () {
                      widget.doneFunction();
                    },
                    style: appStyles.roundButtonStyles().copyWith(
                        foregroundColor: WidgetStatePropertyAll(
                            Theme.of(context).primaryColor),
                        shadowColor:
                            const WidgetStatePropertyAll(Colors.transparent),
                        backgroundColor:
                            const WidgetStatePropertyAll(Color(0x4524B42E)),
                        padding:
                            const WidgetStatePropertyAll(EdgeInsets.all(5)),
                        maximumSize:
                            const WidgetStatePropertyAll(Size(50, 50))),
                    child: const Icon(
                      Icons.send_rounded,
                    ))
              ],
            ),
          )
        ]),
        bottomNavigationBar: Container(
          height: 18,
          decoration: const BoxDecoration(color: Colors.white),
        ),
      ),
    );
  }
}
