import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/component/dialogues/PataVaziDialog.dart';
import 'package:shirikisho/screen/services/VaziMaipoScreen.dart';
import 'package:shirikisho/utils/WAColors.dart';

import '../../services/camera.dart';
import '../../services/popups.dart';
import '../../utils/styles.dart';
import '../WATopUPCardScreen.dart';

class VaziScreen extends StatefulWidget {
  static String tag = '/VaziScreen';

  @override
  VaziScreenState createState() => VaziScreenState();
}

class VaziScreenState extends State<VaziScreen> {

  final UniformsPopup _uniformsPopup = UniformsPopup();
  final KishoStyles appStyles = KishoStyles();

  final _storage = const FlutterSecureStorage();

  var _district = 'Ilala';



  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    var district = await  _storage.read(key: 'user_district');
    if(district != null){
      setState((){
        log(district);
        _district = district;
      });
    }

  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
            'Vazi',
            style: boldTextStyle(color: Colors.black, size: 20),
          ),
        centerTitle: true,
          // systemOverlayStyle: SystemUiOverlayStyle.dark),
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Icon(Icons.arrow_back),
        ).onTap(() {
          finish(context);
        }),
      ),
      body: Container(
        height: context.height(),
        width: context.width(),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/walletApp/wa_bg.jpg'), fit: BoxFit.cover,opacity: 0.9),
          color: Colors.black,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              60.height,

               Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 0),
            child: Text(
              _district,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          )
        ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Column(
                      children: [
                        Image(
                          image: const AssetImage(
                            'assets/images/helment.png',
                          ),
                          width: MediaQuery.of(context).size.width * 0.25,
                        ),
                        const Text(
                          'Dereva',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Column(
                      children: [
                        Image(
                          image: const AssetImage(
                            'assets/images/helment.png',
                          ),
                          width: MediaQuery.of(context).size.width * 0.25,
                        ),
                        const Text(
                          'Abiria',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _vaziImage(),
                ],
              ),
              const SizedBox(
                height: 15,
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vazi Bodaboda',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: Color(0xFF505F79)),
                        ),
                        // Text(
                        //   '59,000',
                        //   style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                        // )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      children: [
                        Icon(
                          Symbols.point_scan_rounded,
                          size: 14,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Koti la dereva',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xFF505F79)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    const Row(
                      children: [
                        Icon(
                          Symbols.point_scan_rounded,
                          size: 14,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Kofia ngumu ya dereva',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xFF505F79)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    const Row(
                      children: [
                        Icon(
                          Symbols.point_scan_rounded,
                          size: 14,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Kofia ngumu ya abiria',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xFF505F79)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    const Row(
                      children: [
                        Icon(
                          Symbols.point_scan_rounded,
                          size: 14,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Kiakisi mwanga cha abiria',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xFF505F79)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          // CameraExampleHome().launch(context);
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => PataVaziDialog(),
                          );

                        },
                        style: appStyles.defaultButtonStyles().copyWith(
                            minimumSize: const MaterialStatePropertyAll(
                                Size(double.maxFinite, 45))),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Pata vazi jipya'),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.east_rounded)
                          ],
                        ))
                  ]),
                ),
              ),

            ],
          ).paddingAll(30),
        ),
      ),
    );
  }

  Widget _vaziImage(){
    return Image(
      image: AssetImage('assets/uniform/$_district.png',),
      width: MediaQuery.of(context).size.width * 0.5,
    );
  }
}
