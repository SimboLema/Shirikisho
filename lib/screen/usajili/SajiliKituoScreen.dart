import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shirikisho/model/region/association_model.dart';
import 'package:shirikisho/model/region/chombo_model.dart';
import 'package:shirikisho/model/region/district_model.dart';
import 'package:shirikisho/model/region/prking_model.dart';
import 'package:shirikisho/model/region/region_model.dart';
import 'package:shirikisho/model/region/ward_model.dart';
import 'package:shirikisho/services/region_service.dart';
import 'package:shirikisho/utils/WAColors.dart';
import 'package:shirikisho/utils/WAWidgets.dart';
import 'package:shirikisho/utils/styles.dart';

class ParkingAreaRegistrationScreen extends StatefulWidget {
  const ParkingAreaRegistrationScreen({super.key});

  @override
  State<ParkingAreaRegistrationScreen> createState() =>
      _ParkingAreaRegistrationScreenState();
}

class _ParkingAreaRegistrationScreenState
    extends State<ParkingAreaRegistrationScreen> {
  KishoStyles appStyles = KishoStyles();

  TextEditingController kituoController = TextEditingController();

  FocusNode umilikiFocusNode = FocusNode();

  List<RegionModule> regionsList = [];
  List<DistrictModule> districtsList = [];
  List<WardModule> wardsList = [];
  List<AssociationModule> associationsList = [];
  List<ParkingModule> parkingsList = [];
  List<vTypeModule> vehicleTypeList = [];

  final GlobalKey<FormFieldState> _distKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _wardKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _assocKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _parkKey = GlobalKey<FormFieldState>();
  RegionModule? dropdownMkoa = null;
  DistrictModule? dropdownWilaya = null;

  String? dropdownKata = null;
  WardModule? dropdownWard = null;
  double? latitude;
  double? longitude;
  bool isLoading = false;
  bool isUploading = false;

  Future<void> init() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<RegionModule> regions = await loadRegions();
      // List<vTypeModule> vehicle_types = await loadVehicles();

      setState(() {
        regionsList.clear();
        regionsList.addAll(regions);

        vehicleTypeList.clear();
        // vehicleTypeList.addAll(vehicle_types);
        isLoading = false; // Hide loading on error
      });
    } catch (error) {
      print("Error fetching data: $error");
      setState(() {
        isLoading = false; // Hide loading on error
      });
    }

    setStatusBarColor(Colors.white, statusBarIconBrightness: Brightness.dark);

    // await Future.delayed(Duration(milliseconds: 500));
  }

  void validateAndSubmit() async {
    if (dropdownWard == null || kituoController.text.isEmpty) {
      toast("Tafadhali jaza taarifa zote",
          bgColor: Colors.red,
          textColor: Colors.white,
          length: Toast.LENGTH_SHORT);

      return;
    } else if (latitude == null || longitude == null) {
      toast("Tafadhali hakikisha location imeruhusiwa.",
          bgColor: Colors.red,
          textColor: Colors.white,
          length: Toast.LENGTH_SHORT);

      getCurrentLocation();
    } else {
      setState(() {
        isUploading = true;
      });
      var res = await saveKituo(
          dropdownWard!.id, kituoController.text, latitude, longitude);
      if (res['status'] == "success") {
        toast(res['message'],
            bgColor: Colors.green,
            textColor: Colors.white,
            length: Toast.LENGTH_LONG);

        setState(() {
          isUploading = false;
        });
        Navigator.pop(context);
      } else {
        toast(res['message'],
            bgColor: Colors.red,
            textColor: Colors.white,
            length: Toast.LENGTH_LONG);
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    init();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: context.scaffoldBackgroundColor,
            // backgroundColor: WAPrimaryColor,
            foregroundColor: Colors.white,

            title: Text(
              "Fomu ya Usajili wa  Kituo",
              textScaler: TextScaler.noScaling,
              style: boldTextStyle(size: 18, color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.only(left: 8),
                alignment: Alignment.topLeft,
                child: Text('Chagua Mkoa',
                    style: boldTextStyle(size: 15, color: Colors.black)),
              ),
              Row(
                children: [
                  DropdownButtonFormField(
                    isExpanded: true,
                    value: dropdownMkoa,
                    // focusNode: umilikiFocusNode,
                    decoration: waInputDecoration(hint: "Chagua"),
                    items: regionsList.map((RegionModule? value) {
                      return DropdownMenuItem<RegionModule>(
                        value: value,
                        child: Text(value?.name as String,
                            style: secondaryTextStyle()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      List? districts = value?.districts as List?;
                      setState(() {
                        dropdownMkoa = value;
                        _distKey.currentState?.reset();
                        districtsList.clear();

                        if (districts!.length >= 1) {
                          districtsList
                              .addAll(districts as Iterable<DistrictModule>);
                        }
                      });
                      // _marital = value!;
                    },
                  ).expand(),
                ],
              ),
              10.height,
              Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.only(left: 8),
                alignment: Alignment.topLeft,
                child: Text('Chgua Wilaya',
                    style: boldTextStyle(size: 15, color: Colors.black)),
              ),
              Row(
                children: [
                  DropdownButtonFormField(
                    key: _distKey,
                    isExpanded: true,
                    // focusNode: bimaChomboFocusNode,
                    decoration: waInputDecoration(hint: "Chagua"),
                    items: districtsList.map((DistrictModule? value) {
                      return DropdownMenuItem<DistrictModule>(
                        value: value,
                        child: Text(value?.name as String,
                            style: secondaryTextStyle()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _wardKey.currentState?.reset();

                      wardsList.clear();

                      setState(() {
                        if (value != null) {
                          List wards = value.wards as List;

                          wardsList.addAll(wards as Iterable<WardModule>);
                        }
                      });
                    },
                  ).expand(),
                ],
              ),
              10.height,
              Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.only(left: 8),
                alignment: Alignment.topLeft,
                child: Text('Chagua Kata',
                    style: boldTextStyle(size: 15, color: Colors.black)),
              ),
              Row(
                children: [
                  DropdownButtonFormField(
                    key: _wardKey,
                    isExpanded: true,
                    // focusNode: umilikiFocusNode,
                    decoration: waInputDecoration(hint: "Chagua"),
                    items: wardsList.map((WardModule? value) {
                      return DropdownMenuItem<WardModule>(
                        value: value,
                        child: Text(value!.name as String,
                            style: secondaryTextStyle()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _parkKey.currentState?.reset();

                      // if(parkingsList.length != 0)
                      parkingsList.clear();

                      setState(() {
                        if (value != null) {
                          dropdownWard = value;
                          List parkings = value.parkings as List;
                          parkingsList
                              .addAll(parkings as Iterable<ParkingModule>);
                        }
                      });
                    },
                  ).expand(),
                ],
              ),
              10.height,
              Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.only(left: 8),
                alignment: Alignment.topLeft,
                child: Text('Jina la Kituo',
                    style: boldTextStyle(size: 15, color: Colors.black)),
              ),
              AppTextField(
                decoration: waInputDecoration(hint: 'kituo'),
                textFieldType: TextFieldType.NAME,
                keyboardType: TextInputType.name,
                textStyle: primaryTextStyle(color: appTextColorPrimary),
                controller: kituoController,
              ),
              10.height,
              ElevatedButton(
                // onPressed: () async {
                //   var res = await saveKituo(dropdownWard!.id,
                //       kituoController.text, latitude, longitude);
                // },
                onPressed: validateAndSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: WAPrimaryColor,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: isUploading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Sajili Kituo',
                        textScaler: TextScaler.noScaling,
                        style: boldTextStyle(size: 14, color: Colors.white),
                      ),
              ),
            ]).paddingSymmetric(horizontal: 16),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.4),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: WAPrimaryColor,
                  ),
                  10.height,
                  Text(
                    'Tafadhali Subiri ....',
                    textScaler: TextScaler.noScaling,
                    style: boldTextStyle(
                        size: 14,
                        color: WAPrimaryColor,
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      toast("Huduma ya Location imezimwa. Tafadhali washa GPS.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        toast("Ruhusa ya Location imekataliwa.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // toast(
      //     "Ruhusa ya Location imezuiliwa milele. Tafadhali washa kwenye settings.");
      await Geolocator.openAppSettings(); // Opens the location settings
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }
}
